require 'src/states/play/lib/physics/Rectangle'
require 'src/states/play/level/Tile'

TileRectangle = Class{__includes = Tile}

-- sadly there is no function overloading in lua
function TileRectangle:fromRectangle(x,y,width,height)
    return self:toTiles(Rectangle(x,y,width,height))
end

-- From rectangle to tiles - return as table
function TileRectangle:toTiles(rectangle)
    local TileRectangles = {}
    if rectangle.width == 0 or rectangle.height == 0 then
        return TileRectangles
    end

    if rectangle.width == rectangle.height then
        table.addTable(TileRectangles, self:squareToTiles(rectangle))
        return TileRectangles
    end

    table.addTable(TileRectangles, self:rectangleToTiles(rectangle))

    return TileRectangles
end

-- Translates squares to fit TileRectangles
-- TileRectangles sizes are in binary increments (TileRectangle_SIZE * 2^n) to ensure
-- that they can be divided into 4 segments
function TileRectangle:squareToTiles(rectangle)
    local TileRectangles = {}

    if tilemath.isTile(rectangle.width) then
        table.insert(TileRectangles, TileRectangle(rectangle.x,rectangle.y,rectangle.width))
    else
        local xRemainder = rectangle.width - tilemath.nearestTile(rectangle.width)
        local yRemainder = rectangle.height - tilemath.nearestTile(rectangle.height)

        table.insert(TileRectangles, TileRectangle(
            rectangle.x,
            rectangle.y,
            rectangle.width - xRemainder
        ))
        table.addTable(TileRectangles, TileRectangle:fromRectangle(
            rectangle.x + rectangle.width - xRemainder,
            rectangle.y,
            xRemainder,
            rectangle.height - yRemainder
        ))
        table.addTable(TileRectangles, TileRectangle:fromRectangle(
            rectangle.x,
            rectangle.y + rectangle.height - yRemainder,
            rectangle.width,
            yRemainder
        ))
    end

    return TileRectangles
end

function TileRectangle:rectangleToTiles(rectangle)
    local TileRectangles = {}
    local yRemainder = 0
    local xRemainder = 0
    local TileRectangleSize = 10

    if rectangle.width > rectangle.height then
        -- get largest possible TileRectangle that fits by height
        TileRectangleSize = tilemath.nearestTile(rectangle.height)
        -- use as many of the largest possible TileRectangle as we can fit
        yRemainder = rectangle.height % TileRectangleSize
        xRemainder = rectangle.width % (rectangle.height - yRemainder)
    
        -- remainder is removed to make sure TileRectangles fit, -1 is subtracted
        -- because for loop needs to be exclusive
        local width = rectangle.x + rectangle.width - xRemainder - 1
    
        for x = rectangle.x, width, TileRectangleSize do
            table.insert(TileRectangles, TileRectangle(
                x,
                rectangle.y,
                TileRectangleSize
            ))
        end
    else 
        -- exactly the same idea as above but in reverse
        -- largest possible TileRectangle that fits by width etc.
        TileRectangleSize = tilemath.nearestTile(rectangle.width)
        xRemainder = rectangle.width % TileRectangleSize
        yRemainder = rectangle.height % (rectangle.width - xRemainder)
    
        local height = rectangle.y + rectangle.height - yRemainder - 1
    
        for y = rectangle.y, height, TileRectangleSize do
            table.insert(TileRectangles, TileRectangle(
                rectangle.x,
                y,
                TileRectangleSize
            ))
        end
    end

    -- remainders are handled recursively
    table.addTable(TileRectangles, TileRectangle:fromRectangle(
        rectangle.x + rectangle.width - xRemainder,
        rectangle.y,
        xRemainder,
        rectangle.height - yRemainder
    ))
    table.addTable(TileRectangles, TileRectangle:fromRectangle(
        rectangle.x,
        rectangle.y + rectangle.height - yRemainder,
        rectangle.width,
        yRemainder
    ))

    return TileRectangles;
end
