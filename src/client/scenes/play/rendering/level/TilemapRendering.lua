require 'src/network/state/tilemap/Tile'

TilemapRendering = Class{}

function TilemapRendering:init(level)
    self.level = level

    self.textures = {
        s = love.graphics.newImage('src/client/assets/textures/tile/sand.png'),
        r = love.graphics.newImage('src/client/assets/textures/tile/rock.png'),
        g = love.graphics.newImage('src/client/assets/textures/tile/grass.png'),
    }
end

function TilemapRendering:renderTile(tile)
    local texture = self.textures[tile.type.id] or self.textures['r']

    love.graphics.setColor(1,1,1)

    love.graphics.draw(texture, tile.x, tile.y)
end

function TilemapRendering:render()
    love.graphics.setColor(0,0,0)

    local tiles = self.level.world:queryRect(
        Camera.x,
        Camera.y,
        love.graphics.getWidth() * Camera.zoom,
        love.graphics.getHeight() * Camera.zoom,
        function(item)
            return item.isTile
        end
    )

    for __, tile in pairs(tiles) do
        self:renderTile(tile)
    end
end