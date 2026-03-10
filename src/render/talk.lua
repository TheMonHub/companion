local module = {}

local init = false

function module.load(args)
    if init == true then
        return
    end



    init = true
end

function module.draw()
end

function module.update(dt)
end

return module