local Player = {}

-- todo: validate that the move is not too far away from previous location
function Player.move(data, host)
    host:pushUpdate('player', data.client, data.parameters)
end

function Player.connect(data, host, ip, port)
    host.state:set('client', data.client, {
        ip = ip,
        port = port
    })

    host:pushUpdate('player', data.client, data.parameters)
end

function Player.quit(data, host)
    host.state:set('client', data.client, nil)
    host:pushUpdate('player', data.client, nil)
end

return Player