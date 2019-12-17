local Player = {}

-- todo: validate that the move is not too far away from previous location
function Player.move(data, host)
    host.state:push('player', data.client, data.parameters)
end

function Player.connect(data, host, ip, port)
    host.state:update('client', data.client, {
        ip = ip,
        port = port
    })

    host.state:push('player', data.client, data.parameters)
end

function Player.quit(data, host)
    host.state:update('client', data.client, nil)
    host.state:push('player', data.client, nil)
end

return Player