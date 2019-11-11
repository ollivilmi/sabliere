local WorldCommands = {}

function WorldCommands.update(data)
    local x, y = data.parameters.x, data.parameters.y
    assert(x and y)

    x, y = tonumber(x), tonumber(y)

    gWorld[data.client] = { x = x, y = y }
end

return WorldCommands