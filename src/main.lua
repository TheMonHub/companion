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
    windowWidth, windowHeight = love.graphics.getDimensions()
    windowCenterX, windowCenterY = windowWidth / 2, windowHeight / 2
    translateX, translateY = 0, 0
    screenSizeX, screenSizeY = love.window.getDesktopDimensions()
    playAreaScale = math.min(
            screenSizeX  / windowWidth,
            screenSizeY / windowHeight
    )
    playAreaX, playAreaY = windowWidth * playAreaScale, windowHeight * playAreaScale
    playAreaHalfX, playAreaHalfY = playAreaX / 2, playAreaY / 2
    gameLog.info("Initialized!")
    gameLog.info("Game Root: " .. love.filesystem.getRealDirectory(gameSourceDirMntPoint))
    gameLog.info("Game Resources: " .. love.filesystem.getRealDirectory(gameSourceDirMntPoint) .. gameResourceDir)

    love.graphics.setBackgroundColor(1,1,1)

    render.update()
    scenery:load()
end

function love.update(dt)
    render.update(dt)
    scenery:update(dt)
end

function love.draw()
    love.graphics.translate(windowCenterX + translateX, windowCenterY + translateY)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill", 0 - playAreaHalfX, 0 - playAreaHalfY, playAreaX, playAreaY)
    love.graphics.setColor(1,1,1)
    scenery:draw()
end