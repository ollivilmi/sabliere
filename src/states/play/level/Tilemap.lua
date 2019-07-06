Tilemap = Class{}

function Tilemap:init()
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

    -- ground
    for k,tile in pairs(Tile:rectangle(0, MAP_HEIGHT-TILE_SIZE, MAP_WIDTH, TILE_SIZE)) do
        self:addTile(tile)
    end
end

function Tilemap:addTile(tile)
    if tile.x < 0 or tile.y < 0 then
        return
    end

    -- check furthest possible x and y in tile
    local fx = tile.map.x + tile.map.count
    local fy = tile.map.y + tile.map.count

    if not self:inBounds(fy, fx) then
        self:expand(fy, fx)
        log("map expanded, new dimensions: [" .. self.mapWidth .. "," .. self.mapHeight .. "]")
    end

    for y = tile.map.y, tile.map.y + tile.map.count do
        for x = tile.map.x, tile.map.x + tile.map.count do
            self.tiles[y][x] = tile   
        end
    end
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
    for y = tile.map.y, tile.map.y + tile.map.count do
        for x = tile.map.x, tile.map.x + tile.map.count do
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

function Tilemap:removeTiles(pos)
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

-- Used for eg. collision detection
function Tilemap:toTilesNearObject(object, action)
    left_tile = math.floor(object.x / TILE_SIZE) + 1
    right_tile = math.floor((object.x + object.width) / TILE_SIZE) + 1
    top_tile = math.floor(object.y / TILE_SIZE) + 1
    bottom_tile = math.floor((object.y + object.height) / TILE_SIZE) + 1

    for y = top_tile, bottom_tile do
        for x = left_tile, right_tile do
            action(y,x)
        end
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
end