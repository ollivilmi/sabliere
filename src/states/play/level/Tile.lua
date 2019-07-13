require 'src/states/play/lib/physics/Rectangle'
require 'src/states/play/level/TileRectangle'

Tile = Class{__includes = Collision, TileRectangle}

-- Tiles are squares with min length TILE_SIZE
function Tile:init(x, y, length, image)
    self.x, self.y, length = math.snap(x, y, length)
    self.map = {
        x = self.x / TILE_SIZE + 1, -- addition because tables are 1 indexed
        y = self.y / TILE_SIZE + 1,
        count = length / TILE_SIZE -1 -- subtraction because coords are 0 indexed
    }
    self.width = length
    self.height = length

    self.health = 1
    self.image = image or "sand"
end

function Tile:destroy(area)
    local segments = {}
    local width = self.width/2
    local height = self.height/2
    local bricks = {}

    -- break into 4x4 smaller segments by dividing height & width by 2
    if width >= TILE_SIZE then
        for x = self.x, self.x + width, width do
            for y = self.y, self.y + height, height do
                table.insert(bricks, Tile(x, y, width, self.image))
            end
        end

        for k, brick in pairs(bricks) do 
            if area:collides(brick) then
                for i,v in pairs(brick:destroy(area)) do
                    table.insert(segments, v)
                end
                brick = nil
            else
                table.insert(segments, brick)
            end
        end
    end

    return segments 
end

-- sadly there is no function overloading in lua
function Tile:fromRectangle(x,y,width,height)
    return self:rectangle(Rectangle(x,y,width,height))
end

-- From rectangle to squares (tiles) - return as table
function Tile:rectangle(rectangle)
    local tiles = {}
    if rectangle.width == 0 or rectangle.height == 0 then
        return tiles
    end

    if rectangle.width == rectangle.height then
        table.addTable(tiles, self:squareToTiles(rectangle))
        return tiles
    end

    table.addTable(tiles, self:rectangleToTiles(rectangle))

    return tiles
end

--- Translates squares to fit tiles (eg. 30x30 pixels cannot be a tile)
function Tile:squareToTiles(rectangle)
    local tiles = {}

    if math.isTile(rectangle.width) then
        table.insert(tiles, Tile(rectangle.x,rectangle.y,rectangle.width))
    else
        local xRemainder = rectangle.width - math.nearestTile(rectangle.width)
        local yRemainder = rectangle.height - math.nearestTile(rectangle.height)

        table.insert(tiles, Tile(
            rectangle.x,
            rectangle.y,
            rectangle.width - xRemainder
        ))
        table.addTable(tiles, Tile:fromRectangle(
            rectangle.x + rectangle.width - xRemainder,
            rectangle.y,
            xRemainder,
            rectangle.height - yRemainder
        ))
        table.addTable(tiles, Tile:fromRectangle(
            rectangle.x,
            rectangle.y + rectangle.height - yRemainder,
            rectangle.width,
            yRemainder
        ))
    end

    return tiles
end

function Tile:rectangleToTiles(rectangle)
    local tiles = {}
    local yRemainder = 0
    local xRemainder = 0
    local tileSize = 10

    -- if wider
    if rectangle.width > rectangle.height then
        -- get largest possible tile that fits by height
        tileSize = math.nearestTile(rectangle.height)
        -- use as many of the largest possible tile as we can fit
        yRemainder = rectangle.height % tileSize
        xRemainder = rectangle.width % (rectangle.height - yRemainder)
    
        -- remainder is removed to make sure tiles fit, -1 is subtracted
        -- because for loop needs to be exclusive
        local width = rectangle.x + rectangle.width - xRemainder - 1
    
        for x = rectangle.x, width, tileSize do
            table.insert(tiles, Tile(
                x,
                rectangle.y,
                tileSize
            ))
        end
    else 
        -- exactly the same idea as above but in reverse
        -- largest possible tile that fits by width etc.
        tileSize = math.nearestTile(rectangle.width)
        xRemainder = rectangle.width % tileSize
        yRemainder = rectangle.height % (rectangle.width - xRemainder)
    
        local height = rectangle.y + rectangle.height - yRemainder - 1
    
        for y = rectangle.y, height, tileSize do
            table.insert(tiles, Tile(
                rectangle.x,
                y,
                tileSize
            ))
        end
    end

    -- remainders are handled recursively
    table.addTable(tiles, Tile:fromRectangle(
        rectangle.x + rectangle.width - xRemainder,
        rectangle.y,
        xRemainder,
        rectangle.height - yRemainder
    ))
    table.addTable(tiles, Tile:fromRectangle(
        rectangle.x,
        rectangle.y + rectangle.height - yRemainder,
        rectangle.width,
        yRemainder
    ))

    return tiles;
end

-- bandaid solution to change collision to reuse a method
function Tile:collider()
    return Collision(self.x+1, self.y+1, self.width-2, self.height-2)
end

function Tile:toString()
    return self.map.x .. "," .. self.map.y .. ";" .. self.map.count
end

function Tile:render()
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end