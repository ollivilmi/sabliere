Tile = Class{__includes = Collision}

-- Tiles are squares with min length TILE_SIZE
function Tile:init(x, y, length, image)
    self.x, self.y, length = math.snap(x, y, length)
    self.map = {
        x = self.x / TILE_SIZE + 1,
        y = self.y / TILE_SIZE + 1,
        count = length / TILE_SIZE - 1
    }
    self.width = length
    self.height = length

    self.health = 1
    self.image = image or "sand"
end

function Tile:destroy(circle)
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
            if circle:collides(brick) then
                for i,v in pairs(brick:destroy(circle)) do
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

-- From rectangle to squares (tiles) - return as table
function Tile:rectangle(x, y, width, height, image)
    local rectangle = {}
    local remainder = 0
    local wider = width > height

    if wider then
        remainder = width % height
        -- looping rectangle by:    width / (width/height)
        -- which equals width incremented by height for each iteration
        for x = x, x + width, height do
            table.insert(rectangle, Tile(x,y,height,image))
        end
    else
        remainder = height % width
        for y = y, y + height, width do
            table.insert(rectangle, Tile(x,y,width,image))
        end
    end
    
    -- handle leftovers recursively (while width/height has a remainder)
    if remainder ~= 0 then
        for k, brick in pairs(Tile:rectangle(
            wider and x + width - remainder or x, 
            wider and y or y + height - remainder, 
            wider and remainder or width, 
            wider and height or remainder
        ))
        do
            table.insert(rectangle, brick)
        end
    end

    return rectangle
end