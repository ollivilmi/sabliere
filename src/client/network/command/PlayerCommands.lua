local PlayerCommands = {}

function PlayerCommands.update(data, connection)
    connection:send(Data(k, "move", {v.x, v.y}), ip, port)
    connection:send(Data(self.id, 'move', x, y))
end

function PlayerCommands.connect(data, connection)
    local datagram = string.format("%s %s %d %d", entity, 'at', 320, 240)
    connection:send(Data(k, "connect", {v.x, v.y}), ip, port)
end

function PlayerCommands.quit(data, connection)
    gState.level[data.client] = nil
end

return PlayerCommands