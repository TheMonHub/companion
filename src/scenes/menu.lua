local game = {}

local render = require("render.main")

function game:load(args)
end

function game:draw()
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle("fill", -400, -300, 800, 600)
end

function game:update(dt)
end

return game