require 'src/network/state/entity/Entity'

local PostPlayer = {}

function PostPlayer.update(data, host)
    host.state.level.players:updateState(data.headers.entityId, data.payload)
end

function PostPlayer.connect(data, host, ip, port)
    local clientId = data.headers.clientId
    print("New player connected: " .. clientId)

    local player = host.state.level.players:createEntity(clientId, {x = 700, y = 0, height = 100, width = 50})

    host:addClient(clientId, ip, port)
    host.updates:pushEntity(clientId, player)
    
    -- Add update of new player for all clients
    host.updates:pushEvent(Data({
        clientId = clientId,
        request = 'connect'
    }, player:getState()))

    -- Send state snapshot to connected player
    host.updates:pushDuplex(clientId, Data({request = 'snapshot'}, host.state:getSnapshot()))
end

function PostPlayer.quit(data, host)
    local clientId = data.headers.clientId
    print("Player disconnected: " .. clientId)

    host.state.level.players:removeEntity(clientId)
    host:removeClient(clientId)

    -- Push update to all users to remove entity
	host.updates:pushEvent(Data({
		clientId = clientId,
		request = 'disconnect'
	}))
end

return PostPlayer