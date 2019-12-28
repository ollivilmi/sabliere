require 'src/client/states/play/entity/player/PlayerEntity'

local Snapshot = {}

function Snapshot.set(data, client)
    client.state:setSnapshot(data.payload)

    local players = client.state.level.players

    players:animate()
    
    local player = players:getEntity(client.id)

    -- keymap could be loaded from server, that's why it's a constructor parameter
    local keymap = require 'src/client/states/play/entity/player/settings/Keymap'

    -- overwrite entity with controllable "PlayerEntity"
    players:setEntity(client.id, PlayerEntity(player, keymap))

    -- To periodically send updates to server
    client.updates:pushEntity(client.id, player.entity)
end

return Snapshot