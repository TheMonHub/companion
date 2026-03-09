local game = {}

local ease = require("render.ease")
local haru = require("render.haru")
local background = require("render.background")

local fadein = 1

function game:load(args)
    haru.load()
    background.load()
end

function game:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("fill", -400, -300, 800, 600)
    background.draw()
    haru.draw()

    love.graphics.setColor(1,1,1,fadein)
    love.graphics.rectangle("fill", -400, -300, 800, 600)
end

function game:update(dt)
    haru.update(dt)
    background.update(dt)

    if fadein == 0 then
        return
    end
    if fadein <= 0.05 then
        fadein = 0
    else
        fadein = ease.circleEaseOut(0, fadein, 5, dt)
    end
end

return game