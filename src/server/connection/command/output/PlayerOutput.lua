local Player = {}

function Player.update(data, ip, port)
    for k, v in pairs(gState.level) do
        gConnection.send(Data(k, "at", {v.x, v.y}), ip, port)
        -- gConnection.udp:sendto(string.format("%s %s %d %d", k, 'at', v.x, v.y), msg_or_ip,  port_or_nil)
    end
end

function Player.quit(data)
    gState.level[data.client] = nil
end

return Player