local game = {}

local gameLog = require("log.main")
local ease = require("render.ease")
local start = 0
local wait = 0

local glitch = {
    "<PSLD<@#$$>?S?",
    "@!:{LONELYF>L",
    "AJA#@HELP^",
    "HAHAHAHAHAHAHAHAHA",
    "HARURURURURURURUR",
    "YOUR BEST COMPANION FOREVER",
    "WITH YOU FOREVER"
}

function game:load(args)
end

function game:draw()
    love.graphics.setColor(1,1,1,start)
    love.graphics.rectangle("fill", -400, -300, 800, 600)
end

function game:update(dt)
    if start >= 0.95 then
        if wait < 1 then
            wait = wait + dt
            return
        end
        self.setScene("main-game")
        return
    end
    start = ease.circleEaseOut(1, start, 3, dt)
end

return game