local module = {}

local defaultFont do
    defaultFont = love.graphics.newFont(gameResourceDir .. "fonts/determination.ttf", 12)
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

function module.printn(content, positionX, positionY, scale) -- How tf did I mess that up
    love.graphics.print(
            content,
            positionX,
            positionY - (defaultFont:getHeight() * (scale or 1)) / 2,
            0,
            (scale or 1)
    )
end

function module.printb(content, positionX, positionY, scale, borderScale)
    love.graphics.setColor(0,0,0,1)
    module.print(content, positionX - borderScale, positionY - borderScale, scale)
    module.print(content, positionX + borderScale, positionY + borderScale, scale)
    module.print(content, positionX + borderScale, positionY - borderScale, scale)
    module.print(content, positionX - borderScale, positionY + borderScale, scale)
    module.print(content, positionX, positionY + borderScale, scale)
    module.print(content, positionX, positionY - borderScale, scale)
    module.print(content, positionX + borderScale, positionY, scale)
    module.print(content, positionX - borderScale, positionY, scale)

    love.graphics.setColor(1,1,1,1)
    module.print(content, positionX, positionY, scale)
end

return module