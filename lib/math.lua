function math.clamp(val, lower, upper)
    if lower > upper then lower, upper = upper, lower end
    return math.max(lower, math.min(upper, val))
end