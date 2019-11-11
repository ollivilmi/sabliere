local Player = {}

function Player.move(data)
    local x, y = data.x, data.y
    assert(x and y)

    x, y = tonumber(x), tonumber(y)

    local ent = gState.level[data.client] or { x = 0, y = 0 }
    gState.level[data.client] = { x = ent.x + x, y = ent.y + y }
end

function Player.connect(data)
    local x, y = data.parameters.x, data.parameters.y
    assert(x and y)
    x, y = tonumber(x), tonumber(y)
    gState.level[data.client] = {x=x, y=y}
end

return Player