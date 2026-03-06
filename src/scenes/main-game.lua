local game = {}

local ease = require("render.ease")

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

local isBlink = false
local blinkTime = 0
local blinkPause = 0

local isMouthOpen = false

local time = 0
local amplitude = 2
local frequency = 1.5

local mouseX, mouseY = 400, 300

function game:load(args)
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
end

function game:draw()
    local y = amplitude * math.sin(frequency * time)
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("fill", -400, -300, 800, 600)
    love.graphics.draw(tail, (-y * 15 - 400 + mouseX * 0.005) + mouseY * 0.05, y * 25 - 300 - mouseY * 0.05, -y * 0.05 + mouseY * 0.0001)
    love.graphics.draw(limbs, -400, y * 1.5 - 300)
    love.graphics.draw(torso, -400 - mouseX * 0.0025, y - 300 - mouseY * 0.0025)
    love.graphics.draw(legs, -400 , -300)
    love.graphics.draw(head, -400 - mouseX * 0.001, y - 300 - mouseY * 0.001)
    if isMouthOpen == true then
        love.graphics.draw(faceMouthOpen, -400 + mouseX * 0.005, y * 1.5 - 295 + mouseY * 0.005)
    else
        love.graphics.draw(faceMouthClose, -400 + mouseX * 0.005, y * 1.5 - 295 + mouseY * 0.005)
    end
    if isBlink == false then
        love.graphics.draw(faceFollow, -400 + mouseX * 0.0125, y - 295 + mouseY * 0.0125)
        love.graphics.draw(face, -400 + mouseX * 0.001, y * 2 - 295 + mouseY * 0.001)
    else
        love.graphics.draw(faceBlink, -400 + mouseX * 0.01, y * 2 - 295 + mouseY * 0.01)
    end
end

function game:update(dt)
    local newMouseX, newMouseY = love.mouse.getPosition()
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
        else
            isBlink = false
            blinkTime = blinkTime - dt
        end
    end
    mouseX = ease.circleEaseOut(newMouseX - 400, mouseX, 7.5, dt)
    mouseY = ease.circleEaseOut(newMouseY - 300, mouseY, 7.5, dt)
    time = time + dt
end

return game