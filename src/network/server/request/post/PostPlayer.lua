require 'src/network/state/entity/Entity'

local PostPlayer = {}

function PostPlayer.update(data, host)
    host.state.level.players:updateState(data.client, data.parameters)
end

function PostPlayer.connect(data, host, ip, port)
    print("New player connected: " .. data.client)
    host:addPlayer(data.client, {x = 700, y = 0, height = 100, width = 50}, ip, port)
    
    -- Send state snapshot to connected player
    host:sendToClient(Data(data.client, 'snapshot', host.state:getSnapshot()), data.client)
end

function PostPlayer.quit(data, host)
    print("Player disconnected: " .. data.client)
    host:removePlayer(data.client)
end

return PostPlayer