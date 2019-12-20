local Tilemap = {}
local json = require 'lib/language/json'

function Tilemap.snapshot(data, host)
    host.state.level.tilemap.tiles = data.parameters
end

return Tilemap