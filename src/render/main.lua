local module = {}
module.enabled = false
module.winX = nil
module.winY = nil

local oldTranlateX, oldTranslateY = 0, 0
local shakeX, shakeY = 0, 0

function module.update()
    if not (module.enabled == true) then
        return
    end
    if module.winX == nil or module.winY == nil then
        return
    end
    love.window.setPosition(module.winX + shakeX, module.winY + shakeY)
    shakeX, shakeY = 0, 0
end

function module.shakeWin(intensityX, intensityY)
    shakeX = love.math.random(-intensityX, intensityX)
    shakeY = love.math.random(-intensityY, intensityY)
end

return module