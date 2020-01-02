require 'src/network/state/entity/Entity'

local PlayerUpdates = {}

function PlayerUpdates.update(data, host)
    local player = host.state.level.players:getEntity(data.headers.clientId)

    if player then
        player:updateState(data.payload)
    end
end

function PlayerUpdates.connect(data, host, ip, port)
    local clientId = data.headers.clientId
    print("New player connected: " .. clientId)
    local player = host.state.level.players:createEntity(clientId, {x = 700, y = 0, height = 100, width = 50})

    host.updates:pushEntity(clientId, player)
    
    -- Send state snapshot to connecting player
    host.updates:pushDuplex(clientId, Data({request = 'snapshot'}, host.state:getSnapshot()))

    -- Add update of new player for all clients
    -- Todo: duplex
    host.updates:pushEvent(Data({
        entityId = clientId,
        request = 'connectPlayer'
    }, player:getState()))
end

function PlayerUpdates.quit(data, host)
    local clientId = data.headers.clientId
    if not clientId then
        return
    end
    print("Player disconnected: " .. clientId)

    host.state.level.players:removeEntity(clientId)
    host:removeClient(clientId)

    -- Push update to all users to remove entity
	host.updates:pushEvent(Data({
		entityId = clientId,
		request = 'quitPlayer'
	}))
end

return PlayerUpdates