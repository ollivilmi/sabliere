local types = require 'src/network/state/tilemap/TileTypes'

Tile = Class{}

function Tile:init(type)
    self.isTile = true
    self.type = type
end