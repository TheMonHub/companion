local module = {}

local ease = require("render.ease")

local init = false

local tail
local limbs
local torso
local legs
local head

local face
local faceFollow
local faceMouthClose
local faceMouthOpen
local faceBlink

local mouthSadOpen
local mouthSadClose

local lemon = {}

local shadow

local isBlink = false
local blinkTime = 0
local blinkPause = 0

local mouthStage = "neutral"

local faceStage = "neutral"
local beforeBlinkStage = "neutral"

local bodyStage = "neutral"

local time = 0
local amplitude = 2
local frequency = 1.5

local mouseX, mouseY = 400, 300

local look = false
local up = false

haruOffsetX = 0

haruSpeed = 1

function module.getFaceStage()
    return faceStage
end

function module.setFaceStage(string)
    faceStage = string
end

function module.getMouthStage()
    return mouthStage
end

function module.setMouthStage(string)
    mouthStage = string
end

function module.getBodyStage()
    return bodyStage
end

function module.setBodyStage(string)
    bodyStage = string
end

function module.setLookAtYOU(isit)
    look = isit
end

function module.isLookAtYOU()
    return look
end

function module.lookUp(realorfakeorcakeidfk)
    up = realorfakeorcakeidfk
end

function module.blink()
    isBlink = true
    beforeBlinkStage = faceStage
    blinkPause = 0
    faceStage = "blink"
end

function module.load(args)

    if init == true then
        return
    end
    tail = love.graphics.newImage(gameResourceDir .. "haru/tail.png")
    limbs = love.graphics.newImage(gameResourceDir .. "haru/limbs.png")
    torso = love.graphics.newImage(gameResourceDir .. "haru/torso.png")
    legs = love.graphics.newImage(gameResourceDir .. "haru/legs.png")
    head = love.graphics.newImage(gameResourceDir .. "haru/head.png")
    face = love.graphics.newImage(gameResourceDir .. "haru/face-1.png")
    faceFollow = love.graphics.newImage(gameResourceDir .. "haru/face-follow-1.png")
    faceMouthClose = love.graphics.newImage(gameResourceDir .. "haru/face-mouth-close.png")
    faceMouthOpen = love.graphics.newImage(gameResourceDir .. "haru/face-mouth-open.png")
    faceBlink = love.graphics.newImage(gameResourceDir .. "haru/face-3.png")
    shadow = love.graphics.newImage(gameResourceDir .. "haru/shadow.png")
    mouthSadClose = love.graphics.newImage(gameResourceDir .. "haru/face-mouth-sad.png")
    mouthSadOpen = love.graphics.newImage(gameResourceDir .. "haru/face-mouth-sad-open.png")

    lemon[1] = love.graphics.newImage(gameResourceDir .. "haru/lemon-1.png")
    lemon[2] = love.graphics.newImage(gameResourceDir .. "haru/lemon-2.png")
    init = true
end

function module.draw()
    if bodyStage == "lemon-1" then
        love.graphics.draw(lemon[1], -400 + haruOffsetX, -300)
        return
    end
    if bodyStage == "lemon-2" then
        love.graphics.draw(lemon[2], -400 + haruOffsetX, -300)
        return
    end

    local y = amplitude * math.sin(frequency * time * haruSpeed)
    love.graphics.draw(shadow, -400, -300)
    love.graphics.draw(tail, (-y * 15 - 400 + mouseX * 0.005) + mouseY * 0.05, y * 25 - 300 - mouseY * 0.05, -y * 0.05 + mouseY * 0.0001)
    love.graphics.draw(limbs, -400, y * 1.5 - 300)
    love.graphics.draw(torso, -400 - mouseX * 0.0025, y - 300 - mouseY * 0.0025)
    love.graphics.draw(legs, -400 , -300)
    love.graphics.draw(head, -400 - mouseX * 0.001, y - 300 - mouseY * 0.001)

    if mouthStage == "open" then
        love.graphics.draw(faceMouthOpen, -400 + mouseX * 0.005, y * 1.5 - 295 + mouseY * 0.005)
    elseif mouthStage == "neutral" then
        love.graphics.draw(faceMouthClose, -400 + mouseX * 0.005, y * 1.5 - 295 + mouseY * 0.005)
    elseif mouthStage == "sad" then
        love.graphics.draw(mouthSadClose, -400 + mouseX * 0.005, y * 1.5 - 295 + mouseY * 0.005)
    elseif mouthStage == "sad-open" then
        love.graphics.draw(mouthSadOpen, -400 + mouseX * 0.005, y * 1.5 - 295 + mouseY * 0.005)
    end
    if faceStage == "neutral" then
        love.graphics.draw(faceFollow, -400 + mouseX * 0.0125, y - 295 + mouseY * 0.0125)
        love.graphics.draw(face, -400 + mouseX * 0.001, y * 2 - 295 + mouseY * 0.001)
    elseif faceStage == "blink" then
        love.graphics.draw(faceBlink, -400 + mouseX * 0.01, y * 2 - 295 + mouseY * 0.01)
    end
end

function module.update(dt)
    local newMouseX, newMouseY = love.mouse.getPosition()
    newMouseX = newMouseX * love.graphics.getDPIScale()
    newMouseY = newMouseY * love.graphics.getDPIScale()

    if up == true then
        newMouseX, newMouseY = 400, -300
    end
    if isBlink == true then
        blinkPause = blinkPause + dt
        if blinkPause >= 0.1 then
            isBlink = false
            blinkTime = love.math.random(3, 7.5)
            blinkPause = 0
        end
    else
        if blinkTime <= 0 then
            isBlink = true
            beforeBlinkStage = faceStage
            blinkPause = 0
            faceStage = "blink"
        else
            isBlink = false
            faceStage = beforeBlinkStage
            blinkTime = blinkTime - dt
        end
    end
    time = time + dt
    if look then
        mouseX = ease.circleEaseOut(0, mouseX, 1, dt)
        mouseY = ease.circleEaseOut(0, mouseY, 1, dt)
        return
    end
    mouseX = ease.circleEaseOut(newMouseX - 400, mouseX, 7.5, dt)
    mouseY = ease.circleEaseOut(newMouseY - 300, mouseY, 7.5, dt)

end

return module