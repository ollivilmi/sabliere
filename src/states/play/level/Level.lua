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
    local backgroundWidth = gTextures.background:getWidth()
    local backgroundHeight = gTextures.background:getHeight()

    love.graphics.draw(gTextures.background, 
        0, 0, 
        0,
        -- scale factors on X and Y axis so it fills the screen
        VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1)
    )

    self.tilemap:render()
end