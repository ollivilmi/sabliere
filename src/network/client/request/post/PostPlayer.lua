require 'src/network/state/entity/Entity'
require 'src/client/states/play/entity/AnimatedEntity'

local models = require 'src/client/states/play/entity/models/playerModels'

local PostPlayer = {}

function PostPlayer.connect(data, client)
    if (data.client ~= client.id) then
        client.state.level.players:setAnimatedEntity(data.client, data.parameters)
    end
end

function PostPlayer.update(data, client)
    if (data.client ~= client.id) then
        client.state.level.players:updateState(data.client, data.parameters)
    end
end

function PostPlayer.disconnect(data, client)
    client.state.level.players:disconnect(data.client)
end

return PostPlayer