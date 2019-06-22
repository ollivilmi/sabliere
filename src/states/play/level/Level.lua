require 'src/states/play/level/Tile'

Level = Class{}

function Level:init(playState)
    self.mapWidth = VIRTUAL_WIDTH / TILE_SIZE
    self.mapHeight = VIRTUAL_HEIGHT / TILE_SIZE
    self.tiles = {}

    for y = 1, self.mapHeight do
        table.insert(self.tiles, {})
        for x = 1, self.mapWidth do
            table.insert(self.tiles[y], {
                {}
            })
        end
    end

    self.kinematicObjects = { 
        player = playState.player 
    }

    -- test brick
    self:addTile(Tile(0, VIRTUAL_HEIGHT - 130, 80, 80))

    -- ground
    for k,tile in pairs(Tile:rectangle(0, VIRTUAL_HEIGHT-TILE_SIZE, VIRTUAL_WIDTH, TILE_SIZE)) do
        self:addTile(tile)
    end
end

function Level:addTile(tile)
    for y = tile.map.y, tile.map.y + tile.map.count do
        for x = tile.map.x, tile.map.x + tile.map.count do
            self.tiles[y][x] = tile   
        end
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

        self:toAllTiles(function(tile)
            if tile.x ~= nil and object:collides(tile) then
                object:applyCollision(tile)
            end
        end)
    end
end

function Level:toAllTiles(action)
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            action(self.tiles[y][x])
        end
    end
end

function Level:toTile(tile, action)
    for y = tile.map.y, tile.map.y + tile.map.count do
        for x = tile.map.x, tile.map.x + tile.map.count do
            action(self.tiles[y][x])            
        end
    end
end

function Level:destroyTiles(pos)
    local toDestroy = {}
    local toAdd = {}

    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            if self.tiles[y][x].x ~= nil and pos:collides(self.tiles[y][x]) then
                table.insert(toDestroy, self.tiles[y][x])
                self.tiles[y][x] = {}
            end
        end
    end

    for k, tile in pairs(toDestroy) do
        for i, t in pairs(tile:destroy(pos)) do
            table.insert(toAdd, t)
        end
    end

    for k, tile in pairs(toAdd) do
        self:addTile(tile)
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

    self:toAllTiles(function(tile) 
        if tile.x ~= nil then
            tile:render()
        end
    end)
end