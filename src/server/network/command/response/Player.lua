local Player = {}

function Player.update(data, connection, ip, port)
    for id, entity in pairs(gState.level) do
        connection:send(Data(id, "update", {entity.x, entity.y}), ip, port)
    end
end

function Player.quit(data)
    gState.level[data.client] = nil
end

return Player