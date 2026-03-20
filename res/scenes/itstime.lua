local game = {}

local ease = require("render.ease")
local haru = require("render.haru")

function game:load(args)

end

function game:draw()
    haru.draw()
end

function game:update(dt)
    haru.update(dt)
end

return game