local Player = {}

function Player.move(data, host)
    local x, y = data.x, data.y
    assert(x and y)

    x, y = tonumber(x), tonumber(y)

    local ent = host.state.level[data.client] or { x = 0, y = 0 }
    host.state.player[data.client] = { x = ent.x + x, y = ent.y + y }
end

function Player.connect(data, host, ip, port)
    local x, y = data.parameters.x, data.parameters.y
    assert(x and y)
    x, y = tonumber(x), tonumber(y)

    host.state.client[data.client] = {
        ip = ip,
        port = port
    }

    host.state.player[data.client] = {
        x = x,
        y = y
    }

    print(ip, port)
end

function Player.quit(data, host)
    host.state.player[data.client] = nil
end

return Player