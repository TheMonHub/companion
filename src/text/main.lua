local module = {}

local defaultFont do
    defaultFont = love.graphics.newFont("fonts/determination.ttf", 12)
    module.defaultFont = defaultFont

    module.defaultFont:setFilter("nearest")
    love.graphics.setFont(module.defaultFont)
end

function module.print(content, positionX, positionY, scale) -- How tf did I mess that up
    love.graphics.print(
            content,
            positionX - (defaultFont:getWidth(content) * (scale or 1)) / 2,
            positionY - (defaultFont:getHeight() * (scale or 1)) / 2,
            0,
            (scale or 1)
    )
end

return module