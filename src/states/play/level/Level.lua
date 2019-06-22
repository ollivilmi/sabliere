require 'src/states/play/level/Tile'

Level = Class{}

function Level:init(playState)
    self.tiles = {}
    self.kinematicObjects = { 
        player = playState.player 
    }

    -- test brick
    table.insert(self.tiles, Tile(0, VIRTUAL_HEIGHT - 130, 80, 80))

    -- ground
    for k,brick in pairs(Tile:rectangle(0, VIRTUAL_HEIGHT-30, 700, 30)) do
        table.insert(self.tiles, brick)
    end
end

function Level:update(dt)
    self:gravity()
end

function Level:gravity()
    for i, object in pairs(self.kinematicObjects) do
        -- should have conditional to check whether or not object is colliding
        -- with ground
        object.grounded = false

        for k, brick in pairs(self.tiles) do
            if brick ~= nil and object:collides(brick) then
                object:applyCollision(brick)
            end
        end
    end
end

function Level:createTile(brick)
    table.insert(self.tiles, brick)
end

function Level:destroyTiles(pos)
    local toDestroy = {}
    local toAdd = {}

    for k, brick in pairs(self.tiles) do
        if brick ~= nil and pos:collides(brick) then
            table.insert(toDestroy, k)
        end
    end

    for k, brick in pairs(toDestroy) do
        for i, b in pairs(self.tiles[brick]:destroy(pos)) do
            table.insert(toAdd, b)
        end
        self.tiles[brick] = nil
    end

    for k, brick in pairs(toAdd) do
        table.insert(self.tiles, brick)
    end
end

function Level:render()
    local backgroundWidth = gTextures.background:getWidth()
    local backgroundHeight = gTextures.background:getHeight()

    love.graphics.draw(gTextures.background, 
        0, 0, 
        0,
        -- scale factors on X and Y axis so it fills the screen
        VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))
    
    for k, brick in pairs(self.tiles) do
        if brick ~= nil then
            brick:render()
        end
    end
end