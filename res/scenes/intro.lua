local game = {}

local gameLog = require("log.main")
local ease = require("render.ease")
local text
local start = 0
local wait = 0
local out = 1

function game:load(args)
    text = require("text.main")
end

function game:draw()
    love.graphics.setColor(1,1,1,start)
    love.graphics.rectangle("fill", -400, -300, 800, 600)
    love.graphics.setColor(0,0,0,out)
    text.print("COMPANION", 0, 0, 7.5)
    if love.graphics.getDPIScale() ~= 1 then
        text.print("High scaling may cause the game to be blury", 0, 75, 2.5)
    end
end

function game:update(dt)
    if start >= 0.95 then
        if wait < 0.5 then
            wait = wait + dt
            return
        end
        out = ease.circleEaseOut(0, out, 10, dt)
        if out > 0.05 then
            return
        end
        self.setScene("main-game")
        return
    end
    start = ease.circleEaseOut(1, start, 5, dt)
end

return game