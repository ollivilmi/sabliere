Brick = Class{__includes = Collision}
SNAP = 5

-- Bricks are squares with min length BRICK_SIZE
function Brick:init(x, y, length)
    self.x, self.y, length = math.snap(SNAP, x, y, length)

    self.width = length
    self.height = length

    self.health = 1
    self.color = {1, 1, 1, 1}
end

function Brick:render()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end

function Brick:destroy(circle)
    local segments = {}
    local width = self.width/2
    local height = self.height/2
    local bricks = {}

    -- break into 4x4 smaller segments by dividing height & width by 2
    if width >= BRICK_SIZE then
        for x = self.x, self.x + width, width do
            for y = self.y, self.y + height, height do
                table.insert(bricks, Brick(x, y, width, height))
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

-- From rectangle to squares (bricks) - return as table
function Brick:rectangle(x, y, width, height)
    local rectangle = {}
    local remainder = 0
    local wider = width > height

    if wider then
        remainder = math.fmod(height, width)
        -- looping rectangle by:    width / (width/height)
        -- which equals width incremented by height for each iteration
        for i = x, x + width, height do
            table.insert(rectangle, Brick(i,y,height,height))
        end
    else
        remainder = math.fmod(width, height)
        for j = y, y + height, width do
            table.insert(rectangle, Brick(x,j,width,width))
        end
    end
    
    -- handle leftovers recursively (while width/height has a remainder)
    if remainder ~= 0 then
        for k, brick in pairs(Brick:rectangle(
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