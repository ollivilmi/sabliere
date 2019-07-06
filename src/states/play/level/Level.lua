require 'src/states/play/level/Tile'
require 'src/states/play/level/Tilemap'

Level = Class{}

function Level:init(playState)
    self.tilemap = Tilemap()

    self.kinematicObjects = { 
        player = playState.player 
    }
end

function Level:update(dt)
    self:gravity()
end

function Level:gravity()
    for i, object in pairs(self.kinematicObjects) do
        -- should have conditional to check whether or not object is colliding
        -- with ground
        object.grounded = false

        self.tilemap:toTilesNearObject(object, function(y,x)
            if self.tilemap:hasTile(y,x) and object:collides(self.tilemap.tiles[y][x]) then
                object:applyCollision(self.tilemap.tiles[y][x])   
            end
        end)
    end
end

function Level:render()
    love.graphics.clear(0.5, 0.4, 0.3, 255)
    love.graphics.draw(gTextures.background, 0, 0)
    self.tilemap:render()
end