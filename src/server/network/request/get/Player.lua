local Player = {}

function Player.location(data, host, ip, port)
    for id, entity in pairs(host.state.level) do
        host:send(Data(id, "update", { entity.x, entity.y }), ip, port)
    end
end

return Player