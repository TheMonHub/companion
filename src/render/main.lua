local module = {}

local oldTranlateX, oldTranslateY = 0, 0

local function ease(target, value, speed, dt)
    return value + (target - value) * (1 - math.exp(-speed * dt))
end

function module.update(dt)
    windowPositionX, windowPositionY = love.window.getPosition()
    if dt == nil then
        translateX, translateY = screenSizeX / 2 - windowPositionX - 400, screenSizeY / 2 - windowPositionY - 300
    else
        translateX, translateY = ease(screenSizeX / 2 - windowPositionX - 400, oldTranlateX, 5, dt), ease(screenSizeY / 2 - windowPositionY - 300, oldTranslateY, 5, dt)
    end
    oldTranlateX, oldTranslateY = translateX, translateY
end

return module