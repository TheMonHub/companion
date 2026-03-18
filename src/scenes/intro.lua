local game = {}

local gameLog = require("log.main")
local ease = require("render.ease")
local text
local start = 0
local wait = 0

function game:load(args)
    text = require("text.main")
end

function game:draw()
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle("fill", -400, -300, 800, 600)
    love.graphics.setColor(1,1,1,start)
    love.graphics.rectangle("fill", -400, -300, 800, 600)
    love.graphics.setColor(0,0,0,start)
    text.print("COMPANION", 0, 0, 7.5, 7.5)
end

function game:update(dt)
    if start >= 0.95 then
        if wait < 0.25 then
            wait = wait + dt
            return
        end
        self.setScene("main-game")
        return
    end
    start = ease.circleEaseOut(1, start, 5, dt)
end

return game