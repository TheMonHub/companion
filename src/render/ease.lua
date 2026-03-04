local module = {}

function module.circleEaseOut(target, value, speed, dt)
    return value + (target - value) * (1 - math.exp(-speed * dt))
end

return module