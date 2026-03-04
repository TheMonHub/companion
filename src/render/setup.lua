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
love.graphics.setShader(ditherShader)

return