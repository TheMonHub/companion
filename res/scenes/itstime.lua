local game = {}

local ease = require("render.ease")
local haru = require("render.haru")

-- love.system.openURL("file://" .. love.filesystem.getRealDirectory(gameResourceDir) .. "/res/theultimatec.png") NOTE

function game:load(args)
    haru.setFaceStage("now")
    haru.setBodyStage("neutral")
    canQuit = true
end

function game:draw()
    haru.draw()
end

local time = 0
function game:update(dt)
    haru.update(dt)
    time = time + dt

    if time > 3 then
        haru.setMouthStage("open")
    end
end

return game