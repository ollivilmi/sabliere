local Tilemap = {}

function Tilemap.snapshot(data, host)
    host.state.level.tilemap.tiles = data.parameters
end

return Tilemap