require 'src/network/state/entity/Entity'

local PostPlayer = {}

-- todo: validate that the move is not too far away from previous location
function PostPlayer.move(data, host)
	host.state.level.entities[data.client]:updateLocation(data.parameters)
end

function PostPlayer.connect(data, host, ip, port)
    host.state:set('client', data.client, {
        ip = ip,
        port = port
    })

    host:pushUpdate('connect', data.client, data.parameters)

    host.state.level:addEntity(data.client, Entity(
        data.parameters
    ))
end

function PostPlayer.quit(data, host)
    host.state:set('client', data.client, nil)
    host.state.level.entities[data.client] = nil

    host:pushUpdate('disconnected', data.client, nil)
end

return PostPlayer