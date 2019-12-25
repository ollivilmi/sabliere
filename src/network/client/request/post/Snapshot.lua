require 'src/client/states/play/entity/player/PlayerEntity'

local Snapshot = {}

function Snapshot.set(data, client)
    client.state:setSnapshot(data.parameters)

    local players = client.state.level.players

    players:animate()
    
    local player = players:get(client.id)

    -- To periodically send updates to server
    client.entityUpdates[client.id] = player.entity

    -- keymap could be loaded from server, that's why it's a constructor parameter
    local keymap = require 'src/client/states/play/entity/player/settings/Keymap'

    -- overwrite entity with controllable "PlayerEntity"
    players:set(client.id, PlayerEntity(player, keymap))
end

return Snapshot