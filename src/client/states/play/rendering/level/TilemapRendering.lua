require 'src/network/state/tilemap/Tile'

TilemapRendering = Class{}

local TILE_TEXTURE_SIZE = 10

function TilemapRendering:init(tilemap)
    self.tilemap = tilemap

    self.tileScale = self.tilemap.tileSize / TILE_TEXTURE_SIZE

    -- textures instead of types here
    self.textures = {
        s = love.graphics.newImage('src/client/assets/textures/sand.png'),
    }
end

function TilemapRendering:renderTile(tile)
    if not tile.type then
        return
    end

    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.textures[tile.type.id], tile.x, tile.y, 0, self.tileScale, self.tileScale)
    love.graphics.setColor(0,0,0)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle('line', tile.x, tile.y, tile.width, tile.height)
end

function TilemapRendering:render()
    for y = 1, self.tilemap.height do
        for x = 1, self.tilemap.width do
            self:renderTile(self.tilemap.tiles[y][x])
        end
    end
end