local Player = {}

function Player.connect(data, host)
    if (data.client ~= host.id) then
        host.state.level:addPlayer(data.client, data.parameters)
    end
end

function Player.move(data, host)
    host.state.level.players[data.client]:updateLocation(data.parameters)
end

return Player