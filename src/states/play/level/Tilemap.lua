require 'src/states/play/lib/physics/Rectangle'

Tilemap = Class{}

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

    self:addTiles(Rectangle(0, MAP_HEIGHT-TILE_SIZE, MAP_WIDTH, TILE_SIZE))
end

function Tilemap:addTiles(rectangle)
    for k,tile in pairs(Tile:rectangle(rectangle)) do
        self:addTile(tile, true)
    end
end

function Tilemap:addTile(tile, destroy)
    if tile.x < 0 or tile.y < 0 then
        return
    end

    log("added tile " .. tile:toString())

    -- furthest x and y (tilemap) in tile to be added
    local fx = tile.map.x + tile.map.size
    local fy = tile.map.y + tile.map.size

    if not self:inBounds(fy, fx) then
        self:expand(fy, fx)
        log("map expanded, new dimensions: [" .. self.mapWidth .. "," .. self.mapHeight .. "]")
    end

    -- breaks existing tiles before placing new one (tile:destroy(area))
    --
    -- conditional is used to avoid recursion hell from tiles that are 
    -- returned from tile:destroy(area)
    if destroy then
        self:removeTiles(tile:collider())
    end

    for y = tile.map.y, fy do
        for x = tile.map.x, fx do
            self.tiles[y][x] = tile   
        end
    end
    self:combineAdjacent(tile)
end

function Tilemap:inBounds(y,x)
    return y > 0 and x > 0 and y <= self.mapHeight and x <= self.mapWidth
end

function Tilemap:hasTile(y,x)
    return self:inBounds(y,x) and self.tiles[y][x].x ~= nil
end

function Tilemap:expand(y,x)
    if y > self.mapHeight then
        for y = self.mapHeight + 1, y do
            table.insert(self.tiles, {})
            for x = 1, self.mapWidth do
                table.insert(self.tiles[y], {
                    {}
                })
            end
        end
        self.mapHeight = y
    end

    if x > self.mapWidth then
        for y = 1, self.mapHeight do
            for x = self.mapWidth + 1, x do
                table.insert(self.tiles[y], {
                    {}
                })
            end
        end
        self.mapWidth = x
    end
end

function Tilemap:toTile(tile, action)
    for y = tile.map.y, tile.map.y + tile.map.size do
        for x = tile.map.x, tile.map.x + tile.map.size do
            action(self.tiles[y][x])            
        end
    end
end

function Tilemap:toAllTiles(action)
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            action(self.tiles[y][x])
        end
    end
end

function Tilemap:removeTiles(area)
    local toDestroy = {}
    local toAdd = {}

    self:toTilesNear(area, function(y,x)
        if self.tiles[y][x].x ~= nil and area:collides(self.tiles[y][x]) then
            -- toString provides us a unique key to avoid duplicates
            local tilekey = self.tiles[y][x]:toString()

            toDestroy[tilekey] = self.tiles[y][x]
            self.tiles[y][x] = {}
        end
    end)

    for k, tile in pairs(toDestroy) do
        table.addTable(toAdd, tile:destroy(area))
    end

    for k, tile in pairs(toAdd) do
        self:addTile(tile)
    end
end

-- Used to only check adjacent tiles for performance
function Tilemap:toTilesNear(area, action)
    -- turn circle to rectangle for the convenience of checking adjacent tiles
    area = area.width ~= nil and area or area:toRectangle()

    left_tile = math.floor(area.x / TILE_SIZE) + 1
    right_tile = math.floor((area.x + area.width) / TILE_SIZE) + 1
    top_tile = math.floor(area.y / TILE_SIZE) + 1
    bottom_tile = math.floor((area.y + area.height) / TILE_SIZE) + 1

    for y = top_tile, bottom_tile do
        for x = left_tile, right_tile do
            if x <= self.mapWidth and y <= self.mapHeight then
                action(y,x)
            end
        end
    end
end

function Tilemap:combineAdjacent(tile)
    local size = tile.map.size + 1
    -- check adjacent corners only
    for y = tile.map.y - size, tile.map.y + size, size*2 do
        for x = tile.map.x - size, tile.map.x + size, size*2 do
            if self:hasTile(y,x) then
                corner = self.tiles[y][x]
                if corner:equals(tile) then
                    tiles = self:adjacentTiles(tile, corner)
                    if table.getn(tiles) == 4 then 
                        self:combine(tiles)
                        return
                    end
                end
            end
        end
    end
end

-- Get tiles that are adjacent to both origin AND tile
function Tilemap:adjacentTiles(tile1, tile2)
    local tiles = { tile1, tile2 }
    if self:hasTile(tile1.map.y, tile2.map.x) then
        tile = self.tiles[tile1.map.y][tile2.map.x]
        if tile:equals(tile1) then
            table.insert(tiles, tile)
        end
    end
    if self:hasTile(tile2.map.y, tile1.map.x) then
        tile = self.tiles[tile2.map.y][tile1.map.x]
        if tile:equals(tile1) then
            table.insert(tiles, tile)
        end
    end

    return tiles
end

function Tilemap:combine(tiles)
    local x = tiles[1].x
    local y = tiles[1].y
    for k,t in pairs(tiles) do
        x = math.min(t.x, x)
        y = math.min(t.y, y)
    end

    -- true removes existing tiles
    self:addTile(Tile(x, y, tiles[1].width*2, tiles[1].image), true)
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