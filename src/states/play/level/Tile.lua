Tile = Class{__includes = Collision}

-- Tiles are squares with min length TILE_SIZE
function Tile:init(x, y, length)
    self.x, self.y, length = math.snap(x, y, length)

    self.width = length
    self.height = length

    self.health = 1
    self.color = {0.6, 0.4, 0.2, 1}
end

function Tile:render()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
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
                table.insert(bricks, Tile(x, y, width, height))
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
function Tile:rectangle(x, y, width, height)
    local rectangle = {}
    local remainder = 0
    local wider = width > height

    if wider then
        remainder = math.fmod(height, width)
        -- looping rectangle by:    width / (width/height)
        -- which equals width incremented by height for each iteration
        for i = x, x + width, height do
            table.insert(rectangle, Tile(i,y,height,height))
        end
    else
        remainder = math.fmod(width, height)
        for j = y, y + height, width do
            table.insert(rectangle, Tile(x,j,width,width))
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