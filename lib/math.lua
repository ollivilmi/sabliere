function math.clamp(val, lower, upper)
    if lower > upper then lower, upper = upper, lower end
    return math.max(lower, math.min(upper, val))
end

function math.snap(snap, ...)
    newValues = {...}

    for i, value in ipairs(newValues) do
        newValues[i] = value - math.fmod(value, snap)
    end
    return unpack(newValues)
end

-- Debugging
function math.testSnap(oldValues, newValues)
    if DEBUG_MODE then
        changed = false
        for i,v in ipairs(oldValues) do
            if oldValues[i] ~= newValues[i] then
                changed = true
            end
        end
        if changed then
            print("Snapped from " .. table.concat(oldValues,", ") .. " -> " .. table.concat(newValues,", "))
        end
    end
end