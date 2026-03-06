local game = {}

local text
local render = require("render.main")

function game:load(args)
    local winSuccess = love.window.setMode( windowWidth, windowHeight, {borderless=false, resizable=false, x=screenSizeX / 2 - windowCenterX, y=screenSizeY / 2 - windowCenterY} )
    if winSuccess == false then
        gameLog.error("Failed to open the window!")
        love.event.quit(4)
        return
    end
    require("render.setup")
    render.winX = screenSizeX / 2 - windowCenterX
    render.winY = screenSizeY / 2 - windowCenterY
    love.window.setIcon(love.image.newImageData(gameResourceDir .. "icon.png"))
    self.setScene("menu-1")
end

function game:draw()

end

function game:update(dt)

end

return game