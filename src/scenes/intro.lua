local game = {}

local tail
local limbs
local torso
local legs
local head

function game:load(args)
    tail = love.graphics.newImage(gameResourceDir .. "haru/tail.png")
    limbs = love.graphics.newImage(gameResourceDir .. "haru/limbs.png")
    torso = love.graphics.newImage(gameResourceDir .. "haru/torso.png")
    legs = love.graphics.newImage(gameResourceDir .. "haru/legs.png")
    head = love.graphics.newImage(gameResourceDir .. "haru/head.png")
end

function game:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("fill", -400, -300, 800, 600)
    love.graphics.draw(tail, -400, -300)
    love.graphics.draw(limbs, -400, -300)
    love.graphics.draw(torso, -400, -300)
    love.graphics.draw(legs, -400, -300)
    love.graphics.draw(head, -400, -300)
end

function game:update(dt)
end

return game