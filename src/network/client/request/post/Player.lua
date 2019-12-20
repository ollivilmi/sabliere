local Player = {}

function Player.connect(data, host)
    host.state.level:addPlayer(data.client, Entity(
        data.parameters
    ))
end

function Player.move(data, host)
    host.state.level.players[data.client]:updateLocation(data.parameters)
end

return Player