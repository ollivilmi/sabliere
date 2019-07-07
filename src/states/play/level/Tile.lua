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