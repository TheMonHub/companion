local module = {}

function module.circleEaseOut(target, value, speed, dt)
    return value + (target - value) * (1 - math.exp(-speed * dt))
end

function module.easeInBack(t, duration, overshoot)
    overshoot = overshoot or 1.70158
    local c3 = overshoot + 1
    t = t / duration
    return c3 * t * t * t - overshoot * t * t
end

return module