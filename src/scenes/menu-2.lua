local game = {}

local gameLog = require("log.main")
local render = require("render.main")
local text
local ease = require("render.ease")
local start = 0
local newStart = 0
local uptime = -1
local show = false
local setEvent = false
local moveOn = false
local waitTime = 0

function game:load(args)
    text = require("text.main")
end

function game:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("fill", -400, -300, 800, 600)
    love.graphics.setColor(0,0,0,start)
    text.print("COMPANION", 0, 0, 7.5)
    if show == true then
        text.print("PRESS ANY KEY TO START", 0, 250, 2.5)
    end

    love.graphics.setColor(0,0,0,newStart)
    love.graphics.rectangle("fill", -400, -300, 800, 600)
end

function game:update(dt)
    if start >= 0.95 then -- ugly ass logic
        if moveOn == true then
            if newStart >= 0.95 then
                if waitTime >= 1 then
                    self.setScene("pre-intro")
                    return
                end
                waitTime = waitTime + dt
            end
            newStart = ease.circleEaseOut(1, newStart, 3, dt)
        end
        if setEvent == false then
            love.handlers["keypressed"] = function()
                moveOn = true
                love.handlers["keypressed"] = function() end
                gameLog.info("Entering the main game...")
            end
            setEvent = true
        end
        uptime = uptime + dt
        if uptime >= 0.5 then
            show = true
            uptime = -0.5
            return
        end
        show = false
        if uptime < 0 then
            show = true
        end
        if uptime < -0.5 then
            show = false
        end
        return
    end
    start = ease.circleEaseOut(1, start, 10, dt)
end

return game