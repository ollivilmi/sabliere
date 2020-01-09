local Tilemap = {}

function Tilemap.chunk(data, host)
    host.state.level.tilemap:setChunk(data.payload)
end

return Tilemap