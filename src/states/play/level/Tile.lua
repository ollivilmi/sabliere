require 'src/states/play/lib/physics/Rectangle'

Tile = Class{__includes = Collision}

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

-- From rectangle to squares (tiles) - return as table
function Tile:rectangle(rectangle)
    local tiles = {}

    if rectangle.width == rectangle.height then
        table.addTable(tiles, self:squareToTiles(rectangle))
        return tiles
    end

    local tileSize = math.nearestTile(rectangle.height)
    local yRemainder = rectangle.height % tileSize
    print(yRemainder)
    local xRemainder = rectangle.width % (rectangle.height - yRemainder)
    print(xRemainder)

    table.insert(tiles, Tile(
        rectangle.x,
        rectangle.y,
        tileSize
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

    -- if wider then
    --     remainder = rectangle.width % rectangle.height
    --     -- -1 because for loop is inclusive
    --     area = rectangle.x + rectangle.width - remainder - 1
    --     -- looping rectangle by:    width / (width/height)
    --     -- which equals width incremented by height for each iteration
    --     for x = rectangle.x, area, rectangle.height do
    --         table.insert(tiles, Tile(x,rectangle.y,rectangle.height))
    --     end
    -- else
    --     remainder = rectangle.height % rectangle.width
    --     area = rectangle.y + rectangle.height - remainder - 1

    --     for y = rectangle.y, area, rectangle.width do
    --         table.insert(tiles, Tile(rectangle.x,y,rectangle.width))
    --     end
    -- end
    
    -- -- handle leftovers recursively (while width/height has a remainder)
    -- if remainder ~= 0 then
    --     for k, brick in pairs(Tile:fromRectangle(
    --         wider and rectangle.x + rectangle.width - remainder or rectangle.x, 
    --         wider and rectangle.y or rectangle.y + rectangle.height - remainder, 
    --         wider and remainder or rectangle.width, 
    --         wider and rectangle.height or remainder
    --     ))
    --     do
    --         table.insert(tiles, brick)
    --     end
    -- end

    return tiles
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