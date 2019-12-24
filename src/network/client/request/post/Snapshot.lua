require 'src/client/states/play/entity/player/PlayerEntity'

local Snapshot = {}

function Snapshot.set(data, client)
    client.state:setSnapshot(data.parameters)

    -- overwrite entity with controllable "PlayerEntity"
    local entity = client.state.level.players[client.id]

    -- keymap could be loaded from server, that's why it's a constructor parameter
    local keymap = require 'src/client/states/play/entity/player/settings/Keymap'
    local player = PlayerEntity(entity, keymap)

    client.state.level.players[client.id] = player
    client.entityUpdates[client.id] = player.entity
end

return Snapshot