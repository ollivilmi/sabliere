local Player = {}

-- todo: validate that the move is not too far away from previous location
function Player.update(data, host)
    host.state:update('player', data.client, data.parameters)
end

return Player