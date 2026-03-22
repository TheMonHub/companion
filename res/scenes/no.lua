local game = {}

local haru = require("render.haru")
local time = 0
local timeEnd = 0
local answered = false

function game:load(args)

end

function game:draw()
    haru.draw()
end

function game:update(dt)
    if time >= 2 and answered == false then
        love.window.showMessageBox("...", "You weren't meant to have a choice in the first place", "error")
        answered = true
        love.window.close()
        RenderIt = false
    end
    if answered == true then
        timeEnd = timeEnd + dt
    end
    if timeEnd >= 10 then
        self.setScene("spook")
    end
    time = time + dt
end

return game