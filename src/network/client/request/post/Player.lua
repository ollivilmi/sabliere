local Player = {}

function Player.connect(data, host)
    host.state.level:addEntity(data.client, Entity(
        data.parameters
    ))
end

function Player.move(data, host)
    host.state.level.entities[data.client]:updateLocation(data.parameters)
end

return Player