local module = {}

local init = false

local bgImage
local floorImage
local quad

local frame = 0

function module.load(args)
    if init == true then
        return
    end

    bgImage = love.graphics.newImage(gameResourceDir .. "background.png")
    floorImage = love.graphics.newImage(gameResourceDir .. "floor.png")
    bgImage:setWrap("repeat", "repeat")

    quad = love.graphics.newQuad(0, 0, 800, 600, bgImage)

    init = true
end

function module.draw()
    quad:setViewport(frame, frame, bgImage:getWidth(), bgImage:getHeight())
    love.graphics.draw(bgImage, quad, -400, -300, 0, 800/500, 600/500)
    love.graphics.draw(floorImage, -400, -300)
end

function module.update(dt)
    frame = (frame + (dt / (1 / 60)) * 0.125) % 60
end

return module