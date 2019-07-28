require 'lib/interface/cursor/Cursor'

SquareCursor = Class{__includes = Cursor}

function SquareCursor:init(length, action)
    Cursor:init(self)
    self.length = length
    self.increment = 1
    self.action = action
    self.cursor = function()
        love.graphics.rectangle('line', self.ui.x, self.ui.y, self.length, self.length)
    end
end

-- for square cursor, we will snap to nearest block divisible by MINIMUM_TILE_SIZE
function SquareCursor:getPosition()
    return Tile(self.world.x, self.world.y, self.length)
end

function SquareCursor:update(dt)
    self:updateCoordinates(true)

    -- to properly split squares, the area must be in binary increments
    if love.mouse.wheelmoved ~= 0 then
        self.increment = math.max(0, love.mouse.wheelmoved > 0 and self.increment + 1 
        or self.increment - 1)
        self.length = TILE_SIZE * (2 ^ self.increment)
    end

    if love.mouse.wasPressed(1) then
        self.action(self:getPosition())
    end
end