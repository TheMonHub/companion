local game = {}

local ease = require("render.ease")
local back = require("render.back")
local text

function game:load(args)
    fadein = 1
    back.load()
    text = require("text.main")
end

function game:draw()
    love.graphics.setColor(0,0,0,1)
    text.print("Hello", 0, 0, 3)
    back.draw()
    love.graphics.setColor(1,1,1,fadein)
    love.graphics.rectangle("fill", -400, -300, 800, 600)
end

function game:update(dt)
    if fadein ~= 0 then
        if fadein <= 0.05 then
            fadein = 0
        else
            fadein = ease.circleEaseOut(0, fadein, 5, dt)
        end
    end
    if back.doChange() == true then
        self.setScene("main-game")
    end
    back.update(dt)
end

return game