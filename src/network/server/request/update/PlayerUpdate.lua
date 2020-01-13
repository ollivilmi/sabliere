require 'src/network/state/entity/Entity'

local PlayerUpdates = {}

function PlayerUpdates.update(data, host)
    local player = host.state.players:getEntity(data.headers.clientId)

    if player then
        player:updateState(data.payload)
    end
end

function PlayerUpdates.quit(data, host)
    local clientId = data.headers.clientId
    if not clientId then
        return
    end
    print("Player disconnected: " .. clientId)

    host.state.players:removeEntity(clientId)
    host:removeClient(clientId)

    -- Push update to all users to remove entity
	host.updates:pushEvent(Data({
		entityId = clientId,
		request = 'quitPlayer'
	}))
end

return PlayerUpdates