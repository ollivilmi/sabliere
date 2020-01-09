require 'src/network/state/tilemap/Tile'

Tilemap = Class{}

function Tilemap:init(width, height, world)
    self.tileSize = (world.cellSize / 2) / 2
    self.world = world

    self.width = width
    self.height = height

    self.tiles = {}
    self.types = require 'src/network/state/tilemap/TileTypes'

    for y = 1, self.height do
        table.insert(self.tiles, {})
        for x = 1, self.width do
            table.insert(self.tiles[y], {
                {}
            })
        end
    end
end

function Tilemap:toCoordinates(x, y)
    return (x - 1) * self.tileSize, (y - 1) * self.tileSize
end

function Tilemap:addRectangle(rectangle, type)
    -- translate rectangle to tilemap coordinates, add tiles there
    -- expand if necessary
    local type = type or 'r'

    local x, y = self:toMapCoordinates(rectangle.x, rectangle.y)

    local fy = (y - 1) + (rectangle.h / self.tileSize)
    local fx = (x - 1) + (rectangle.w / self.tileSize)

    if not self:inBounds(fx, fy) then
        self:expand(fx, fy)
    end

    for y = y, fy do
        for x = x, fx do
            self:setTile(x, y, {t = type})
        end
    end
end

function Tilemap:removeTile(x, y)
    if self:hasTile(x, y) then
        self.world:remove(self.tiles[y][x])
        self.tiles[y][x] = {}
    end
end

function Tilemap:setTile(x, y, state)
    self:removeTile(x, y)

    self.tiles[y][x] = Tile{
        type = self.types[state.t],
        health = self.types[state.h]
    }
    local cx, cy = self:toCoordinates(x,y)
    self.world:add(self.tiles[y][x], 
        cx,
        cy,
        self.tileSize,
        self.tileSize
    )
end

function Tilemap:getChunk(entity)
    -- todo: use entity to defer active chunk
    local chunk = {
        x = 1,
        y = 1,
        width = self.width,
        height = self.height,
        tiles = {}
    }

    for y = chunk.y, chunk.height do
        chunk.tiles[y] = {}

        for x = chunk.x, chunk.width do
            if self:hasTile(x, y) then
                table.insert(chunk.tiles[y], 
                    self.tiles[y][x]:getState()
                )
            else
                table.insert(chunk.tiles[y], {})
            end
        end
    end

    return chunk
end

function Tilemap:setChunk(chunk)
    for y = chunk.y, chunk.height do
        for x = chunk.x, chunk.width do
            local state = chunk.tiles[y][x]

            if state.t ~= nil then
                self:setTile(x, y, state)
            else
                self:removeTile(x, y)
            end
        end
    end
end

function Tilemap:inBounds(x, y)
    return y > 0 and x > 0 and y <= self.height and x <= self.width
end

function Tilemap:hasTile(x, y)
    return self:inBounds(x,y) and self.tiles[y][x].type
end

function Tilemap:toMapCoordinates(x, y)
    return math.floor(x / self.tileSize) + 1, math.floor(y / self.tileSize) + 1
end

function Tilemap:pointToTile(x, y)
    x,y = self:toMapCoordinates(x,y)

    if not self:hasTile(x,y) then
        return nil
    end

    return self.tiles[y][x]
end

function Tilemap:expand(x,y)
    if y > self.height then
        for y = self.height + 1, y do
            table.insert(self.tiles, {})
            for x = 1, self.width do
                table.insert(self.tiles[y], {
                    {}
                })
            end
        end
        self.height = y
    end

    if x > self.width then
        for y = 1, self.height do
            for x = self.width + 1, x do
                table.insert(self.tiles[y], {
                    {}
                })
            end
        end
        self.width = x
    end
end