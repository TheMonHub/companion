gameSourceDirMntPoint = "gameSourceDir"
gameResourceDir = gameSourceDirMntPoint .. "/res/"

windowWidth, windowHeight = 800, 600
windowCenterX, windowCenterY = windowWidth / 2, windowHeight / 2
screenSizeX, screenSizeY = love.window.getDesktopDimensions()

Username = os.getenv("USERNAME")

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

if love.system.getOS() ~= "Windows" then
    gameLog.error("This game only supports Windows!")
    love.event.quit(2)
    return
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
local scenery = sceneryInit("intro", "scenes")
local render = require("render.main")

-- MODULE INIT END

local mainRender
function love.load()
    gameLog.info("Initialized!")
    gameLog.info("Game Root: " .. love.filesystem.getRealDirectory(gameSourceDirMntPoint))
    gameLog.info("Game Resources: " .. love.filesystem.getRealDirectory(gameResourceDir) .. "\\res")
    gameLog.info("Username: " .. Username)
    love.graphics.setBackgroundColor(0,0,0,1)
    local winSuccess = love.window.setMode( windowWidth, windowHeight, {borderless=false, resizable=false, x=screenSizeX / 2 - windowCenterX, y=screenSizeY / 2 - windowCenterY} )
    if winSuccess == false then
        gameLog.error("Failed to open the window!")
        love.event.quit(4)
        return
    end
    mainRender = love.graphics.newCanvas(800, 600)
    require("render.setup")
    render.winX = screenSizeX / 2 - windowCenterX
    render.winY = screenSizeY / 2 - windowCenterY
    love.window.setIcon(love.image.newImageData(gameResourceDir .. "icon.png"))
    love.window.setTitle("COMPANION")

    render.update()
    scenery:load()
end

function love.update(dt)
    render.update(dt)
    scenery:update(dt)
end

function love.draw()
    love.graphics.translate(windowCenterX, windowCenterY)

    love.graphics.setCanvas(mainRender)
    love.graphics.setBlendMode("alpha")
    love.graphics.clear(0,0,0,1)
    scenery:draw()
    love.graphics.setCanvas()

    love.graphics.origin()
    love.graphics.scale(1 / love.graphics.getDPIScale(), 1 / love.graphics.getDPIScale())
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(mainRender, 0,0)
end

canQuit = false
cleanupHandler = function()

end
quitHandler = function()
    return canQuit
end

function love.quit()
    cleanupHandler()
    return quitHandler()
end