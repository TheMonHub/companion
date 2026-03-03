local game = {}

local log = require("log.main")
local text = require("text.main")

function game:load(args)
    
end

function game:draw()
    if love.mouse.isDown(1) then
        text.print("Mouse is down!", 0, 0)
    else
        text.print("Mouse is not down!", 0, 0)
    end
end

function game:update(dt)

end

return game