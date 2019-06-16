require 'src/states/play/player/cursor/Cursor'

SquareCursor = Class{__includes = BaseState}

function SquareCursor:init(length, increment, action)
    self.length = length
    self.minlength = length
    self.increment = increment
    self.x = 0
    self.y = 0
    self.action = action
end

-- for square cursor, we will snap to nearest block divisible by MINIMUM_BRICK_SIZE
function SquareCursor:getPosition()
    return Brick(self.x, self.y, self.length)
end

function SquareCursor:update(dt)
    self.x, self.y = push:toGame(love.mouse.getX(), love.mouse.getY())

    if love.mouse.wheelmoved ~= 0 then
        self.length = math.max(self.minlength, love.mouse.wheelmoved > 0 and self.length + self.increment 
        or self.length - self.increment)
    end

    if love.mouse.wasPressed(1) then
        self.action()
    end
end

function SquareCursor:render()
    love.graphics.rectangle('line', self.x, self.y, self.length, self.length)
end