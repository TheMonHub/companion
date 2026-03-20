local game = {}

local ease = require("render.ease")
local background = require("render.background")
local fadein = 1

function game:load(args)
    renderFloor = false
end

function game:draw()
    background.draw()

    love.graphics.setColor(1,1,1,fadein)
    love.graphics.rectangle("fill", -400, -300, 800, 600)
end

function game:update(dt)
    background.update(dt)

    if fadein ~= 0 then
        if fadein <= 0.05 then
            fadein = 0
        else
            fadein = ease.circleEaseOut(0, fadein, 3, dt)
        end
    end
end

return game