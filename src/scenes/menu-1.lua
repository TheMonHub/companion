local game = {}

local render = require("render.main")
local ease = require("render.ease")
local start = 0

function game:load(args)
end

function game:draw()
    love.graphics.setColor(1,1,1,start)
    love.graphics.rectangle("fill", -400, -300, 800, 600)
end

function game:update(dt)
    if start >= 0.95 then
        self.setScene("menu-2")
        return
    end
    start = ease.circleEaseOut(1, start, 3, dt)
end

return game