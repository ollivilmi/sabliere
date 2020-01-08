require 'src/network/state/tilemap/Tile'

TilemapRendering = Class{}

local TILE_TEXTURE_SIZE = 20

function TilemapRendering:init(tilemap)
    self.tilemap = tilemap

    self.tileScale = self.tilemap.tileSize / TILE_TEXTURE_SIZE

    self.textures = {
        s = love.graphics.newImage('src/client/assets/textures/tile/sand.png'),
        r = love.graphics.newImage('src/client/assets/textures/tile/rock.png'),
        g = love.graphics.newImage('src/client/assets/textures/tile/grass.png'),
    }
end

function TilemapRendering:renderTile(tile, x, y)
    if not tile.type then
        return
    end

    local texture = self.textures[tile.type.id] or self.textures['r']

    love.graphics.setColor(1,1,1)

    local x, y = self.tilemap:toCoordinates(x, y)
    love.graphics.draw(texture, x, y, 0, self.tileScale, self.tileScale)
end

function TilemapRendering:render()
    love.graphics.setColor(0,0,0)

    for y = 1, self.tilemap.height do
        for x = 1, self.tilemap.width do
            self:renderTile(self.tilemap.tiles[y][x], x, y)
        end
    end
end