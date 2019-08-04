require 'lib/physics/Rectangle'
require 'src/states/play/level/Tile'

TileRectangle = Class{__includes = Tile}

-- sadly there is no function overloading in lua
function TileRectangle:fromRectangle(x,y,width,height)
    return self:toTiles(Rectangle(x,y,width,height))
end

-- From rectangle to tiles - return as table
function TileRectangle:toTiles(rectangle)
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

-- Translates squares to fit tiles
-- Tile sizes are in binary increments (TILE_SIZE * 2^n) to ensure
-- that they can be divided into 4 segments
function TileRectangle:squareToTiles(rectangle)
    local tiles = {}

    if tilemath.isTile(rectangle.width) then
        table.insert(tiles, Tile(rectangle.x,rectangle.y,rectangle.width))
    else
        local xRemainder = rectangle.width - tilemath.nearestTile(rectangle.width)
        local yRemainder = rectangle.height - tilemath.nearestTile(rectangle.height)

        table.insert(tiles, Tile(
            rectangle.x,
            rectangle.y,
            rectangle.width - xRemainder
        ))
        table.addTable(tiles, TileRectangle:fromRectangle(
            rectangle.x + rectangle.width - xRemainder,
            rectangle.y,
            xRemainder,
            rectangle.height - yRemainder
        ))
        table.addTable(tiles, TileRectangle:fromRectangle(
            rectangle.x,
            rectangle.y + rectangle.height - yRemainder,
            rectangle.width,
            yRemainder
        ))
    end

    return tiles
end

function TileRectangle:rectangleToTiles(rectangle)
    local tiles = {}
    local yRemainder = 0
    local xRemainder = 0
    local tileSize = 10

    if rectangle.width > rectangle.height then
        -- get largest possible tile that fits by height
        tileSize = tilemath.nearestTile(rectangle.height)
        -- use as many of the largest possible tile as we can fit
        yRemainder = rectangle.height % tileSize
        xRemainder = rectangle.width % (rectangle.height - yRemainder)
    
        -- remainder is removed to make sure tiles fit, -1 is subtracted
        -- because for loop needs to be exclusive
        local width = rectangle.x + rectangle.width - xRemainder - 1
    
        for x = rectangle.x, width, tileSize do
            table.insert(tiles, TileRectangle(
                x,
                rectangle.y,
                tileSize
            ))
        end
    else 
        -- exactly the same idea as above but in reverse
        -- largest possible tile that fits by width etc.
        tileSize = tilemath.nearestTile(rectangle.width)
        xRemainder = rectangle.width % tileSize
        yRemainder = rectangle.height % (rectangle.width - xRemainder)
    
        local height = rectangle.y + rectangle.height - yRemainder - 1
    
        for y = rectangle.y, height, tileSize do
            table.insert(tiles, TileRectangle(
                rectangle.x,
                y,
                tileSize
            ))
        end
    end

    -- remainders are handled recursively
    table.addTable(tiles, TileRectangle:fromRectangle(
        rectangle.x + rectangle.width - xRemainder,
        rectangle.y,
        xRemainder,
        rectangle.height - yRemainder
    ))
    table.addTable(tiles, TileRectangle:fromRectangle(
        rectangle.x,
        rectangle.y + rectangle.height - yRemainder,
        rectangle.width,
        yRemainder
    ))

    return tiles;
end
