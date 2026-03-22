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
        love.window.showMessageBox("YOUR BEST FRIEND", "I will be there, ".. Username)
        answered = true
        love.window.close()
        RenderIt = false
    end
    if answered == true then
        timeEnd = timeEnd + dt
    end
    if timeEnd >= 1 then -- remove debug shii
        self.setScene("spook")
    end
    time = time + dt
end

return game