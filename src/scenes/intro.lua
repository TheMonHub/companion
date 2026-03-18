local game = {}

local gameLog = require("log.main")
local ease = require("render.ease")
local start = 0

function game:load(args)
end

function game:draw()
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle("fill", -400, -300, 800, 600)
    love.graphics.setColor(1,1,1,start)
    love.graphics.rectangle("fill", -400, -300, 800, 600)
end

function game:update(dt)
    if start >= 0.95 then
        self.setScene("main-game")
        return
    end
    start = ease.circleEaseOut(1, start, 5, dt)
end

return game