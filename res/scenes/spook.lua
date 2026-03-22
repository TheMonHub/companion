local game = {}

function game:load(args)
    breakEmForthWall()
end

function game:draw()
    love.graphics.setColor(1,0,1,1)
    love.graphics.rectangle("fill", -(screenSizeX - 1) / 2, -(screenSizeY - 1) / 2, screenSizeX - 1, screenSizeY - 1)
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle("fill", -400, -300, 800, 600)
end

function game:update(dt)
end

return game