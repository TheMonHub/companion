local module = {}

local defaultFont do
    defaultFont = love.graphics.newFont("fonts/edit-undo.brk.ttf", 20, "mono")
    module.defaultFont = defaultFont

    module.defaultFont:setFilter("nearest")
    love.graphics.setFont(module.defaultFont)
end

function module.print(content, positionX, positionY, scale) -- How tf did I mess that up
    love.graphics.print(
            content,
            positionX - defaultFont:getWidth(content) / 2,
            positionY - defaultFont:getHeight() / 2,
            0,
            (scale or 1)
    )
end

return module