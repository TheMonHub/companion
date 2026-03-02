gameSourceDirMntPoint = "gameSourceDir"
gameResourceDir = "/res/"

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
    local canIhavC, _ = love.filesystem.newFile(gameSourceDirMntPoint .. gameResourceDir .. "theultimatec.png", "r")
    if not canIhavC then
        love.event.quit(67) -- I'm sorry
        return
    end
    canIhavC:release()
end

-- INIT END

local nativefs = require("extern.nativefs")
local gameWindow = require("window.main")
local sceneryInit = require("extern.scenery")
local scenery = sceneryInit("start", "scenes")

-- MODULE INIT END

function love.load()
    windowWidth, windowHeight = love.graphics.getDimensions()
    windowCenterX, windowCenterY = windowWidth / 2, windowHeight / 2
    gameLog.info("Initialized!")
    gameLog.info("Game Root: " .. love.filesystem.getRealDirectory(gameSourceDirMntPoint))
    gameLog.info("Game Resources: " .. love.filesystem.getRealDirectory(gameSourceDirMntPoint) .. gameResourceDir)
    scenery:load()
end

function love.update(dt)
    scenery:update(dt)
    love.window.setPosition(gameWindow.positionX, gameWindow.positionY)
end

function love.draw()
    love.graphics.translate(windowCenterX, windowCenterY)
    scenery:draw()
end