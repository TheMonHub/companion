local module = {}

local defaultFont

function module.init()
    defaultFont = love.graphics.newFont("fonts/edit-undo.brk.ttf", 20, "mono")
    module.defaultFont = defaultFont

    module.defaultFont:setFilter("nearest")
    love.graphics.setFont(module.defaultFont)
end

function module.print(content, positionX, positionY)
    function module.print(content, positionX, positionY)
        love.graphics.print(
                content,
                positionX - defaultFont:getWidth(content) / 2,
                positionY - defaultFont:getHeight() / 2
        )
    end
end

module.init()

return module