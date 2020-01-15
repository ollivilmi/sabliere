require 'src/network/state/tilemap/Tile'

LevelRendering = Class{}

function LevelRendering:init(level)
    self.level = level

    self.tileTextures = {
        s = love.graphics.newImage('src/client/assets/textures/tile/sand.png'),
        r = love.graphics.newImage('src/client/assets/textures/tile/rock.png'),
        g = love.graphics.newImage('src/client/assets/textures/tile/grass.png'),
    }

    self.resourceTextures = {
        t = love.graphics.newImage('src/client/assets/textures/tile/sand.png'),
    }
end

function LevelRendering:renderTile(tile)
    local texture = self.tileTextures[tile.type.id] or self.tileTextures['r']
    love.graphics.draw(texture, tile.x, tile.y)
end

function LevelRendering:renderResource(resource)
    local texture = self.resourceTextures[resource.id] or self.resourceTextures['t']
    local x, y = self.level.world:getRect(resource)
    love.graphics.draw(texture, x, y)
end

function LevelRendering:render()
    love.graphics.setColor(1,1,1)

    local assets = self.level.world:queryRect(
        Camera.x,
        Camera.y,
        love.graphics.getWidth() * Camera.zoom,
        love.graphics.getHeight() * Camera.zoom,
        function(item)
            return item.isTile or item.isResource
        end
    )

    for __, asset in pairs(assets) do
        if asset.isTile then
            self:renderTile(asset)
        elseif asset.isResource then
            self:renderResource(asset)
        end
    end
end