local MathUtils = {}

-- Basic helpers

function MathUtils.clamp(value, min, max)
    if value < min then return min end
    if value > max then return max end
    return value
end

function MathUtils.sign(n)
    if n > 0 then return 1 end
    if n < 0 then return -1 end
    return 0
end

function MathUtils.round(value, precision)
    precision = precision or 0
    local mult = 10 ^ precision
    return math.floor(value * mult + 0.5) / mult
end

function MathUtils.wrap(value, limit)
    return (value % limit + limit) % limit
end

-- Input helpers

function MathUtils.deadzone(value, size)
    if math.abs(value) < size then
        return 0
    end
    return value
end

function MathUtils.threshold(value, threshold)
    return math.abs(value) >= threshold
end

function MathUtils.tolerance(value, threshold)
    return math.abs(value) <= threshold
end

-- Interpolation

function MathUtils.lerp(a, b, t)
    return a + (b - a) * t
end

function MathUtils.map(value, inMin, inMax, outMin, outMax)
    return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
end

function MathUtils.smoothstep(t, edge0, edge1)
    t = MathUtils.clamp((t - edge0) / (edge1 - edge0), 0, 1)
    return t * t * (3 - 2 * t)
end

function MathUtils.decay(current, target, rate, dt)
    return MathUtils.lerp(current, target, 1 - math.exp(-rate * dt))
end

return MathUtils
