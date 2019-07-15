require 'src/states/play/level/TileRectangle'
require 'src/states/play/level/TilemapLogic'

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

    self:addTiles(Collision(0, MAP_HEIGHT-TILE_SIZE, MAP_WIDTH, TILE_SIZE))
end

function Tilemap:addTiles(rectangle)
    -- remove existing tiles to avoid side effects of combining new tiles
    if self:inBounds(rectangle.map.y, rectangle.map.x) then
        self:removeTiles(rectangle:mapCollider())
    end
    for k,tile in pairs(TileRectangle:toTiles(rectangle)) do
        self:addTile(tile, false)
        self:combineAdjacent(tile)
    end
end

function Tilemap:addTile(tile)
    if tile.x < 0 or tile.y < 0 then
        return
    end

    -- furthest x and y (tilemap) in tile to be added
    local fx = tile.map.x + tile.map.size
    local fy = tile.map.y + tile.map.size

    if not self:inBounds(fy, fx) then
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
        if self.tiles[y][x].x ~= nil and area:collides(self.tiles[y][x]) then
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

    for k, tile in pairs(toAdd) do
        self:addTile(tile)
        self:combineAdjacent(tile)
    end
end

-- TODO: refactor for readability
function Tilemap:render()
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            if self.tiles[y][x].image ~= nil then
                love.graphics.draw(gTextures[self.tiles[y][x].image], (x-1)*TILE_SIZE, (y-1)*TILE_SIZE)
            end
        end
    end

    if DEBUG_MODE then
        self:toAllTiles(function(tile)
            if tile.x ~= nil then
                tile:render()
            end
        end)
    end
end