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
    self.x = (def.x - 1) * def.size
    self.y = (def.y - 1) * def.size
    self.width = def.size
    self.height = def.size

    self.type = def.type
    self.health = def.health or def.type.maxHealth
end

function Tile:render()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.type.texture, self.x, self.y, 0, self.type.scale, self.type.scale)
    love.graphics.setColor(0,0,0)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end