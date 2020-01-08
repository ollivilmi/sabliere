local types = require 'src/network/state/tilemap/TileTypes'

Tile = Class{}

function Tile:init(def)
    self:setState(def)
end

function Tile:getState()
 return {
    h = self.health,
    t = self.type.id
 }
end

function Tile:setState(def)
    self.isTile = true
    self.type = def.type
    self.health = def.health or def.type.maxHealth
end