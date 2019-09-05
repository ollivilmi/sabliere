require 'src/states/play/level/tilemap/Tile'
require 'src/states/play/level/tilemap/TileRectangle'
require 'src/states/play/level/tilemap/TilemapLogic'

Tilemap = Class{__includes = TilemapLogic}

function Tilemap:init()
    self.mapWidth = MAP_WIDTH / TILE_SIZE
    self.mapHeight = MAP_HEIGHT / TILE_SIZE
    self.tiles = {}

    for y = 1, self.mapHeight do
        table.insert(self.tiles, {})
        for x = 1, self.mapWidth do
            table.insert(self.tiles[y], {
                {}
            })
        end
    end
end

function Tilemap:addRectangle(rectangle)
    -- remove existing tiles to avoid side effects of combining new tiles
    if self:inBounds(rectangle.map.x, rectangle.map.y) then
        self:removeTiles(rectangle:mapCollider())
    end
    self:addTiles(TileRectangle:toTiles(rectangle))
end

function Tilemap:addSquareInRange(square, circle)
    local tile = TileRectangle:fromSquare(square)
    local tiles = tile:destroyNotInArea(circle)
    self:overwriteTiles(tiles)  
end

function Tilemap:addRectangleInRange(rectangle, circle)
    local beforeRange = TileRectangle:toTiles(rectangle)
    local afterRange = {}

    for k,tile in pairs(beforeRange) do
        table.addTable(afterRange, tile:destroyNotInArea(circle))
    end
    self:overwriteTiles(afterRange)
end

function Tilemap:addTiles(tiles)
    for k, tile in ipairs(tiles) do
        self:addTile(tile, ignoreEntities)
        self:combineAdjacent(tile)
    end
end

function Tilemap:overwriteTiles(tiles)
    for k, tile in ipairs(tiles) do
        if self:inBounds(tile.map.x, tile.map.y) then
            self:removeTiles(tile:mapCollider())
        end
    end
    self:addTiles(tiles)
end

function Tilemap:addTile(tile)
    if tile.x < 0 or tile.y < 0 then
        return
    end
    local entity = gLevel:entityCollision(tile)
    if entity then
        self:addTiles(tile:destroy(entity.collider))
        return
    end

    -- furthest x and y (tilemap) in tile to be added
    local fx = tile.map.x + tile.map.size
    local fy = tile.map.y + tile.map.size

    if not self:inBounds(fx, fy) then
        self:expand(fy, fx)
        log("map expanded, new dimensions: [" .. self.mapWidth .. "," .. self.mapHeight .. "]")
    end

    for y = tile.map.y, fy do
        for x = tile.map.x, fx do
            self.tiles[y][x] = tile   
        end
    end
end

function Tilemap:overwrite(tile)
    self:removeTiles(tile:mapCollider())
    self:addTile(tile)
    self:combineAdjacent(tile)
end

function Tilemap:removeTiles(area)
    local toDestroy = {}
    local toAdd = {}

    self:toTilesNear(area, function(y,x)
        if self.tiles[y][x].x and area:collides(self.tiles[y][x]) then
            -- toString provides us a unique key to avoid duplicates
            local tile = self.tiles[y][x]
            local tilekey = tile:toString()

            toDestroy[tilekey] = tile
        end
    end)

    for k, tile in pairs(toDestroy) do
        local fx = tile.map.x + tile.map.size
        local fy = tile.map.y + tile.map.size

        for y = tile.map.y, fy do
            for x = tile.map.x, fx do
                self.tiles[y][x] = {}
            end
        end
        -- tiles had to be removed before calling destroy to avoid side effects
        table.addTable(toAdd, tile:destroy(area))
    end

    self:addTiles(toAdd)
end

-- TODO: refactor for readability
function Tilemap:render()
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            if self.tiles[y][x].image then
                love.graphics.draw(gTextures.tiles[self.tiles[y][x].image], (x-1)*TILE_SIZE, (y-1)*TILE_SIZE)
            end
        end
    end

    if DEBUG_MODE then
        self:toAllTiles(function(tile)
            if tile.x then
                tile:render()
            end
        end)
    end
end