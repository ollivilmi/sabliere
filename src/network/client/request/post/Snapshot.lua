require 'src/client/states/play/entity/player/PlayerEntity'

local Snapshot = {}

function Snapshot.set(data, client)
    client.state:setSnapshot(data.parameters)

    -- To periodically send updates to server
    client.entityUpdates[client.id] = client.state.level.players[client.id]
    
    client.state.level:animatePlayers()

    -- overwrite entity with controllable "PlayerEntity"
    local entity = client.state.level.players[client.id]

    -- keymap could be loaded from server, that's why it's a constructor parameter
    local keymap = require 'src/client/states/play/entity/player/settings/Keymap'
    client.state.level.players[client.id] = PlayerEntity(entity, keymap)
end

return Snapshot