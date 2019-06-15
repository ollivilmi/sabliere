Brick = Class{__includes = Collision}

-- Assumes that bricks are at least 10x10 pixels and divisible by 10
MINIMUM_BRICK_SIZE = 10

function Brick:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.health = 1
    self.color = {1, 1, 1, 1}
end

function Brick:update(dt)
end

function Brick:render()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Brick:destroy(circle)
    local segments = {}

    -- break into 4x4 smaller segments
    if self.width > MINIMUM_BRICK_SIZE then
        for x = self.x, self.x + self.width, self.width / 2 do
            for y = self.y, self.y + self.height, self.height / 2 do
                brick = Brick(x, y, self.width/2, self.height/2)

                if circle:collides(brick) then
                    segs = brick:destroy(circle)
                    for i,v in pairs(segs) do
                        table.insert(segments, v)
                    end
                else
                    table.insert(segments, brick)
                end
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