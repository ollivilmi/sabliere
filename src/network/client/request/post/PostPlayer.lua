require 'src/network/state/entity/Entity'

local PostPlayer = {}

function PostPlayer.connect(data, client)
    if (data.client ~= client.id) then
        client.state.level.players[data.client] = Entity(data.parameters, client.state.level)
    end
end

function PostPlayer.move(data, client)
    -- todo interpolate
    client.state.level.players[data.client]:updateLocation(data.parameters)
end

function PostPlayer.update(data, client)
    if (data.client ~= client.id) then
        -- todo interpolate
        local player = client.state.level.players[data.client]

        if player then
            player:updateState(data.parameters)
        end
    end
end

function PostPlayer.disconnect(data, client)
    client.state.level.players[data.client] = nil
end

return PostPlayer