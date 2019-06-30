require 'src/states/play/player/cursor/Cursor'

SquareCursor = Class{__includes = Cursor}

function SquareCursor:init(length, action)
    self.length = length
    self.increment = 1
    self.x = 0
    self.y = 0
    self.action = action
end

-- for square cursor, we will snap to nearest block divisible by MINIMUM_TILE_SIZE
function SquareCursor:getPosition()
    return Tile(self.x, self.y, self.length)
end

function SquareCursor:update(dt)
    self:updateCoordinates()
    self.x, self.y = math.snap(self.x, self.y)

    -- to properly split squares, the area must be in binary increments
    if love.mouse.wheelmoved ~= 0 then
        self.increment = math.max(0, love.mouse.wheelmoved > 0 and self.increment + 1 
        or self.increment - 1)
        self.length = TILE_SIZE * (2 ^ self.increment)
    end

    if love.mouse.wasPressed(1) then
        self.action()
    end
end

function SquareCursor:render()
    love.graphics.rectangle('line', self.x, self.y, self.length, self.length)
end