require 'src/network/state/tilemap/Tile'

Tilemap = Class{}

function Tilemap:init(width, height, tileSize)
    self.tileSize = tileSize

    self.width = width
    self.height = height

    self.tiles = {}
    self.tileTypes = require 'src/network/state/tilemap/TileTypes'

    for y = 1, self.height do
        table.insert(self.tiles, {})
        for x = 1, self.width do
            table.insert(self.tiles[y], {
                {}
            })
        end
    end
end

function Tilemap:addRectangle(rectangle, type)
    -- translate rectangle to tilemap coordinates, add tiles there
    -- expand if necessary

    local x, y = self:toMapCoordinates(rectangle.x, rectangle.y)

    local fy = (y - 1) + (rectangle.height / self.tileSize)
    local fx = (x - 1) + (rectangle.width / self.tileSize)

    if not self:inBounds(fx, fy) then
        self:expand(fx, fy)
    end

    for y = y, fy do
        for x = x, fx do
            self.tiles[y][x] = Tile(type)
        end
    end
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

function Tilemap:inBounds(x,y)
    return y > 0 and x > 0 and y <= self.height and x <= self.width
end

function Tilemap:hasTile(x,y)
    return self:inBounds(x,y) and self.tiles[y][x].x
end

function Tilemap:toMapCoordinates(x,y)
    return math.floor(x / self.tileSize) + 1, math.floor(y / self.tileSize) + 1
end

function Tilemap:pointToTile(x,y)
    x,y = self:toMapCoordinates(x,y)
    if not self:hasTile(x,y) then
        return nil
    end
    
    return self.tiles[y][x]
end

function Tilemap:toAllTiles(action)
    for y = 1, self.height do
        for x = 1, self.width do
            action(self.tiles[y][x])
        end
    end
end

-- Used to only check adjacent tiles for performance
function Tilemap:toTilesNear(area, action)
    -- turn circle to rectangle for the convenience of checking adjacent tiles
    area = area.width ~= nil and area or area:toRectangle()

    left_tile = math.floor(area.x / self.tileSize) + 1
    right_tile = math.floor((area.x + area.width) / self.tileSize) + 1
    top_tile = math.floor(area.y / self.tileSize) + 1
    bottom_tile = math.floor((area.y + area.height) / self.tileSize) + 1

    for y = top_tile, bottom_tile do
        for x = left_tile, right_tile do
            if x <= self.width and y <= self.height then
                action(y,x)
            end
        end
    end
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

-- TODO: refactor for readability
function Tilemap:render()
    for y = 1, self.height do
        for x = 1, self.width do

            local tile = self.tiles[y][x]

            if tile.t then
                love.graphics.setColor(1,1,1)
                local texture = love.graphics.newImage(self.tileTypes[tile.t].texture)
                love.graphics.draw(texture, (x-1)*self.tileSize, (y-1)*self.tileSize)
                love.graphics.setColor(0,0,0)
                love.graphics.setLineWidth(1)
                love.graphics.rectangle('line', (x-1)*self.tileSize, (y-1)*self.tileSize, self.tileSize, self.tileSize)
            end
        end
    end
end