local module = {}
module.enabled = false
module.winX = nil
module.winY = nil

local oldTranlateX, oldTranslateY = 0, 0
local shakeX, shakeY = 0, 0

local oldX, oldY
function module.update()
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
    oldX, oldY = module.winX + shakeX, module.winY + shakeY
    love.window.setPosition(oldX, oldY)
end

function module.shakeWin(intensityX, intensityY)
    shakeX = love.math.random(-intensityX, intensityX)
    shakeY = love.math.random(-intensityY, intensityY)
end

return module