gameSourceDirMntPoint = "gameSourceDir"
gameResourceDir = gameSourceDirMntPoint .. "/res/"

windowWidth, windowHeight = 800, 600
windowCenterX, windowCenterY = windowWidth / 2, windowHeight / 2
screenSizeX, screenSizeY = love.window.getDesktopDimensions()

local gameLog = require("log.main")
if gameLog == nil then
    return
end
gameLog.info("Initializing...")
function love.quit()
    gameLog.info("Exiting...")
end

if (love.filesystem.isFused() == false) then -- Unsupported
    gameLog.error("Game must be in fused mode!")
    love.event.quit(1)
    return
else
    local dir = love.filesystem.getSourceBaseDirectory()
    local success = love.filesystem.mount(dir, gameSourceDirMntPoint)

    if not success then
        gameLog.error("Failed to mount parent directory!")
        love.event.quit(2)
        return
    end
end

do
    local canIhavC, _ = love.filesystem.newFile(gameResourceDir .. "theultimatec.png", "r")
    if not canIhavC then
        love.event.quit(3) -- We CANNOT live without C
        return
    end
    canIhavC:release()
end

-- INIT END

local sceneryInit = require("extern.scenery")
local scenery = sceneryInit("start", "scenes")
local render = require("render.main")

-- MODULE INIT END

function love.load()
    gameLog.info("Initialized!")
    gameLog.info("Game Root: " .. love.filesystem.getRealDirectory(gameSourceDirMntPoint))
    gameLog.info("Game Resources: " .. love.filesystem.getRealDirectory(gameSourceDirMntPoint) .. gameResourceDir)

    render.update()
    scenery:load()
end

function love.update(dt)
    render.update()
    scenery:update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(1,0,1,1)
    love.graphics.translate(windowCenterX, windowCenterY)
    scenery:draw()
end