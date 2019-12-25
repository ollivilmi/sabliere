require 'src/network/state/entity/Entity'

local PostPlayer = {}

function PostPlayer.update(data, host)
    local player = host.state.level.players[data.client]

    if player then
        player:updateState(data.parameters)
    end
end

function PostPlayer.connect(data, host, ip, port)
    print("New player connected: " .. data.client)
    
    local player = Entity({x = 100, y = 100, height = 100, width = 50}, host.state.level)

    host:addPlayer(data.client, player, ip, port)

    -- Send update of new player to all clients
    host:pushUpdate(Data(data.client, 'connect', player:getState()))
    
    -- Send state snapshot to connected player
    host:sendToClient(Data(data.client, 'snapshot', host.state:getSnapshot()), data.client)
end

function PostPlayer.quit(data, host)
    print("Player disconnected: " .. data.client)

    host:removePlayer(data.client)

    -- Push update to all users to remove entity
    host:pushUpdate(Data(data.client, 'disconnect', nil))
end

return PostPlayer