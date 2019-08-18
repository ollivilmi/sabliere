TilemapLogic = Class{}

function TilemapLogic:inBounds(x,y)
    return y > 0 and x > 0 and y <= self.mapHeight and x <= self.mapWidth
end

function TilemapLogic:hasTile(x,y)
    return self:inBounds(x,y) and self.tiles[y][x].x ~= nil
end

function TilemapLogic:toMapCoordinates(x,y)
    return math.floor(x / TILE_SIZE) + 1, math.floor(y / TILE_SIZE) + 1
end

function TilemapLogic:pointToTile(x,y)
    x,y = self:toMapCoordinates(x,y)
    if not self:inBounds(x,y) then
        return nil
    end
    
    return self.tiles[y][x]
end

function TilemapLogic:toTile(tile, action)
    for y = tile.map.y, tile.map.y + tile.map.size do
        for x = tile.map.x, tile.map.x + tile.map.size do
            action(self.tiles[y][x])            
        end
    end
end

function TilemapLogic:toAllTiles(action)
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            action(self.tiles[y][x])
        end
    end
end

-- Used to only check adjacent tiles for performance
function TilemapLogic:toTilesNear(area, action)
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

function TilemapLogic:expand(y,x)
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

function TilemapLogic:combineAdjacent(tile)
    local size = tile.map.size + 1

    -- check adjacent corners only
    --
    --     c x c     (from origin o, checks tiles c for equality)
    --     x o x
    --     c x c
    --
    for y = tile.map.y - size, tile.map.y + size, size*2 do
        for x = tile.map.x - size, tile.map.x + size, size*2 do
            if self:hasTile(x,y) then
                corner = self.tiles[y][x]
                -- validate y,x to make sure it is aligned (y,x are top left corner of tile)
                if corner.map.y == y and corner.map.x == x and corner:equals(tile) then
                    tiles = self:adjacentTiles(tile, corner)
                    -- found 4 aligned, equal tiles
                    if table.getn(tiles) == 4 then
                        self:combine(tiles)
                        return
                    end
                end
            end
        end
    end
end

-- Get tiles that are adjacent to both tiles (0-2 tiles)
-- eg.
--            o c        (o = tile1, tile2)
--            c o        (tiles c are checked for matches)
--
function TilemapLogic:adjacentTiles(tile1, tile2)
    local tiles = { tile1, tile2 }
    if self:hasTile(tile2.map.x, tile1.map.y) then
        tile = self.tiles[tile1.map.y][tile2.map.x]
        if tile:equals(tile1) then
            table.insert(tiles, tile)
        end
    end
    if self:hasTile(tile1.map.x, tile2.map.y) then
        tile = self.tiles[tile2.map.y][tile1.map.x]
        if tile:equals(tile1) then
            table.insert(tiles, tile)
        end
    end

    return tiles
end

function TilemapLogic:combine(tiles)
    local x = tiles[1].x
    local y = tiles[1].y
    -- find top left corner x,y
    for k,t in pairs(tiles) do
        x = math.min(t.x, x)
        y = math.min(t.y, y)
    end

    tile = Tile(x, y, tiles[1].width*2, tiles[1].image)
    -- overwrite may also trigger recursive calls of this function
    -- resulting in multiple layers of combinations occurring
    self:overwrite(tile)
end