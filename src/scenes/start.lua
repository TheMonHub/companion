local game = {}

local text
local render = require("render.main")
local ease = require("render.ease")

function game:load(args)
    local winSuccess = love.window.setMode( windowWidth, windowHeight, {borderless=false, resizable=false, x=screenSizeX / 2 - windowCenterX, y=screenSizeY / 2 - windowCenterY} )
    if winSuccess == false then
        gameLog.error("Failed to open the window!")
        love.event.quit(4)
        return
    end
    require("render.setup")
    if require("debug.skip_intro") == true then
        self.setScene("menu")
        return
    end

    text = require("text.main")
    render.winX = screenSizeX / 2 - windowCenterX
    render.winY = screenSizeY / 2 - windowCenterY
    render.update()
end

local frame = 0
function game:draw()
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle("fill", -400, -300, 800, 600)
    love.graphics.setColor(1,1,1,(frame - 0.9) * 10)
    if frame < 0.9 then
        return
    end
    text.print("Made By", 0, -40, 1.5 * frame)
    text.print("TheMonHub", 0, 20, 3.75 * frame)
end

local endTimer = 0
local oldFrame
function game:update(dt)
    oldFrame = frame
    if endTimer >= 3 and frame >= 0.9 then
        self.setScene("menu")
        return
    end
    endTimer = endTimer + dt
    frame = ease.circleEaseOut(1, oldFrame, 2, dt)
end

return game