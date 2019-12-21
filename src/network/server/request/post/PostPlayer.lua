require 'src/network/state/entity/Entity'

local PostPlayer = {}

-- todo: validate that the move is not too far away from previous location
function PostPlayer.move(data, host)
	host.state.level.players[data.client]:updateLocation(data.parameters)
end

function PostPlayer.connect(data, host, ip, port)
    print("New player connected: " .. data.client)

    host.state.client[data.client] = {ip = ip, port = port}

    -- Send verification that the user has connected and can construct
    -- a Player entity
    host:sendToClient(Data(data.client, 'connect', data.parameters), data.client)
    
    -- Send update of new entity to all clients
    host:pushUpdate(Data(data.client, 'entity', data.parameters))
    host:pushUpdate(Data(data.client, 'tilemap', host.state.level.tilemap.tiles))

    host.state.level:addPlayer(data.client, data.parameters)
end

function PostPlayer.quit(data, host)
    print("Player disconnected: " .. data.client)

    host.state.client[data.client] = nil

    host.state.level.players[data.client] = nil

    -- Push update to all users to remove entity
    host:pushUpdate('disconnected', data.client, nil)
end

return PostPlayer