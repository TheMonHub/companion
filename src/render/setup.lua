local ffi = require("ffi")

ffi.cdef[[
typedef void* HWND;
typedef long LONG_PTR;

HWND GetActiveWindow();
LONG_PTR GetWindowLongPtrA(HWND hWnd, int nIndex);
LONG_PTR SetWindowLongPtrA(HWND hWnd, int nIndex, LONG_PTR dwNewLong);
int SetLayeredWindowAttributes(HWND hwnd, unsigned int crKey, unsigned char bAlpha, unsigned int dwFlags);
]]

local user32 = ffi.load("user32")

local hwnd = user32.GetActiveWindow()

local GWL_EXSTYLE = -20
local WS_EX_LAYERED = 0x00080000
local LWA_COLORKEY = 0x1

local style = user32.GetWindowLongPtrA(hwnd, GWL_EXSTYLE)
user32.SetWindowLongPtrA(hwnd, GWL_EXSTYLE, bit.bor(style, WS_EX_LAYERED))

user32.SetLayeredWindowAttributes(hwnd, 0x00FF00FF, 0, LWA_COLORKEY)

ditherShader = love.graphics.newShader([[
    const float bayer[16] = float[](
        0.0/16.0,  8.0/16.0,  2.0/16.0, 10.0/16.0,
       12.0/16.0,  4.0/16.0, 14.0/16.0,  6.0/16.0,
        3.0/16.0, 11.0/16.0,  1.0/16.0,  9.0/16.0,
       15.0/16.0,  7.0/16.0, 13.0/16.0,  5.0/16.0
    );

    vec4 effect(vec4 color, Image texture, vec2 texCoord, vec2 screenCoord)
    {
        vec4 pixel = Texel(texture, texCoord) * color;

        if (pixel.a <= 0.0)
            discard;

        int x = int(mod(screenCoord.x, 4.0));
        int y = int(mod(screenCoord.y, 4.0));
        int index = y * 4 + x;

        if (pixel.a < bayer[index])
            discard;

        return vec4(pixel.rgb, 1.0);
    }
]])
glitchShader = love.graphics.newShader([[
extern float time;
extern float prob;
extern float intensityChromatic;

const int sampleCount = 50;
const float PI = 3.14159265359;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

const float glitchScale = .4;

vec2 glitchCoord(vec2 p, vec2 gridSize) {
    vec2 coord = floor(p / gridSize) * gridSize;
    coord += (gridSize / 2.0);
    return coord;
}

struct GlitchSeed {
    vec2 seed;
    float prob;
};

GlitchSeed glitchSeed(vec2 p, float speed) {
    float seedTime = floor(time * speed);
    vec2 seed = vec2(
        1.0 + mod(seedTime / 100.0, 100.0),
        1.0 + mod(seedTime, 100.0)
    ) / 100.0;
    seed += p;
    return GlitchSeed(seed, prob);
}

float shouldApply(GlitchSeed seed) {
    return floor(
        mix(
            mix(rand(seed.seed), 1.0, seed.prob - .5),
            0.0,
            (1.0 - seed.prob) * .5
        ) + 0.5
    );
}

// ------------------------
// Swap blocks
// ------------------------

vec4 swapCoords(vec2 seed, vec2 groupSize, vec2 subGrid, vec2 blockSize) {
    vec2 rand2 = vec2(rand(seed), rand(seed + .1));
    vec2 range = subGrid - (blockSize - 1.0);
    vec2 coord = floor(rand2 * range) / subGrid;
    vec2 bottomLeft = coord * groupSize;
    vec2 realBlockSize = (groupSize / subGrid) * blockSize;
    vec2 topRight = bottomLeft + realBlockSize;
    topRight -= groupSize / 2.0;
    bottomLeft -= groupSize / 2.0;
    return vec4(bottomLeft, topRight);
}

float isInBlock(vec2 pos, vec4 block) {
    vec2 a = sign(pos - block.xy);
    vec2 b = sign(block.zw - pos);
    return min(sign(a.x + a.y + b.x + b.y - 3.0), 0.0);
}

vec2 moveDiff(vec2 pos, vec4 swapA, vec4 swapB) {
    vec2 diff = swapB.xy - swapA.xy;
    return diff * isInBlock(pos, swapA);
}

void swapBlocks(inout vec2 xy, vec2 groupSize, vec2 subGrid, vec2 blockSize, vec2 seed, float apply) {
    vec2 groupOffset = glitchCoord(xy, groupSize);
    vec2 pos = xy - groupOffset;

    vec2 seedA = seed * groupOffset;
    vec2 seedB = seed * (groupOffset + .1);

    vec4 swapA = swapCoords(seedA, groupSize, subGrid, blockSize);
    vec4 swapB = swapCoords(seedB, groupSize, subGrid, blockSize);

    vec2 newPos = pos;
    newPos += moveDiff(pos, swapA, swapB) * apply;
    newPos += moveDiff(pos, swapB, swapA) * apply;

    xy = newPos + groupOffset;
}

// ------------------------
// Static noise
// ------------------------

void staticNoise(inout vec2 p, vec2 groupSize, float grainSize, float contrast) {
    GlitchSeed seedA = glitchSeed(glitchCoord(p, groupSize), 5.0);
    seedA.prob *= .5;

    if (shouldApply(seedA) == 1.0) {
        GlitchSeed seedB = glitchSeed(glitchCoord(p, vec2(grainSize)), 5.0);
        vec2 offset = vec2(rand(seedB.seed), rand(seedB.seed + .1));
        offset = floor(offset * 2.0 - 1.0 + 0.5);
        offset *= contrast;
        p += offset;
    }
}

// ------------------------
// Chromatic aberration
// ------------------------

vec4 transverseChromatic(Image tex, vec2 p) {
    vec2 direction = normalize(p - 0.5);
    vec2 velocity = direction * intensityChromatic * pow(length(p - 0.5), 3.0);
    float invSamples = 1.0 / float(sampleCount);

    vec3 acc = vec3(0.0);
    vec2 offR = vec2(0.0);
    vec2 offG = vec2(0.0);
    vec2 offB = vec2(0.0);

    vec2 incR = velocity * 1.0 * invSamples;
    vec2 incG = velocity * 2.0 * invSamples;
    vec2 incB = velocity * 4.0 * invSamples;

    for (int i = 0; i < sampleCount; i++) {
        acc.r += Texel(tex, p + offR).r;
        acc.g += Texel(tex, p + offG).g;
        acc.b += Texel(tex, p + offB).b;

        offR -= incR;
        offG -= incG;
        offB -= incB;
    }

    return vec4(acc / float(sampleCount), 1.0);
}

// ------------------------
// Main effect
// ------------------------

vec4 effect(vec4 color, Image texture, vec2 tc, vec2 sc) {
    vec2 p = tc;

    // Apply glitches
    swapBlocks(p, vec2(.6) * glitchScale, vec2(2.0), vec2(1.0), vec2(1.0), 1.0);
    staticNoise(p, vec2(.5, .125) * glitchScale, .2 * glitchScale, 2.0);

    vec3 col = transverseChromatic(texture, p).rgb;

    return vec4(col, 1.0) * color;
}
]])
glitchShader:send("prob", 0.5)
glitchShader:send("intensityChromatic", 0.05)
love.graphics.setShader(ditherShader)

return