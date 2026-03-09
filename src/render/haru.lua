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
    init = true
end

function module.draw()
    local y = amplitude * math.sin(frequency * time)
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
    end
    if faceStage == "neutral" then
        love.graphics.draw(faceFollow, -400 + mouseX * 0.0125, y - 295 + mouseY * 0.0125)
        love.graphics.draw(face, -400 + mouseX * 0.001, y * 2 - 295 + mouseY * 0.001)
    elseif faceStage == "blink" then
        love.graphics.draw(faceBlink, -400 + mouseX * 0.01, y * 2 - 295 + mouseY * 0.01)
    end
end

function module.update(dt)
    local newMouseX, newMouseY = 400, 300
    if look == false then
        newMouseX, newMouseY = love.mouse.getPosition()
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
    mouseX = ease.circleEaseOut(newMouseX - 400, mouseX, 7.5, dt)
    mouseY = ease.circleEaseOut(newMouseY - 300, mouseY, 7.5, dt)
    time = time + dt
end

return module