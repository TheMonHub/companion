local nativefs = require("extern.nativefs")
local gameText = require("text.main")


function love.load()
    windowWidth, windowHeight = love.graphics.getDimensions()
    windowCenterX, windowCenterY = windowWidth / 2, windowHeight / 2
end

function love.update(dt)

end

function love.draw()
    love.graphics.translate(windowCenterX, windowCenterY)
    gameText.print("Hello World!", 0, 0)
end