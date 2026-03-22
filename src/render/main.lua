local module = {}

local ease = require("render.ease")

module.enabled = false
module.winX = 0
module.winY = 0

local oldTranlateX, oldTranslateY = 0, 0
local shakeX, shakeY = 0, 0

local oldX, oldY
local oldEasedX, oldEasedY = 0, 0

function module.update(dt)
    local winPosX, winPosY = love.window.getPosition()
    if winPosX ~= oldX and module.enabled == false then
        module.winX = winPosX
    end
    if winPosY ~= oldY and module.enabled == false then
        module.winY = winPosY
    end

    if module.winX == nil or module.winY == nil then
        return
    end
    oldEasedX, oldEasedY = ease.circleEaseOut(module.winX, oldEasedX, 5, dt), ease.circleEaseOut(module.winY, oldEasedY, 5, dt)
    if module.enabled == false then
        oldEasedX, oldEasedY = module.winX, module.winY
    end
    oldX, oldY = oldEasedX + shakeX, oldEasedY + shakeY
    love.window.setPosition(oldX, oldY)
end

function module.shakeWin(intensityX, intensityY)
    shakeX = love.math.random(-intensityX, intensityX)
    shakeY = love.math.random(-intensityY, intensityY)
end

return module