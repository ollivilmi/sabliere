require 'lib/interface/cursor/Cursor'

SquareCursor = Class{__includes = Cursor}

function SquareCursor:init(def)
    def.snap = true
    Cursor:init(self, def)

    self.length = def.length
    self.increment = def.increment or 1
end

-- for square cursor, we will snap to nearest block divisible by MINIMUM_TILE_SIZE
function SquareCursor:getPosition()
    return Tile(self.world.x, self.world.y, self.length)
end

function SquareCursor:update(dt)
    Cursor:update(self)
end

function SquareCursor:input()
    -- to properly split squares, the area must be in binary increments
    if love.mouse.wheelmoved ~= 0 then
        self.increment = math.max(0, love.mouse.wheelmoved > 0 and self.increment + 1 
        or self.increment - 1)
        self.length = TILE_SIZE * (2 ^ self.increment)
    end

    if self.inRange and love.mouse.wasPressed(1) then
        self.action(self:getPosition())
    end
end

function SquareCursor:render()
    Cursor:render(self, function()
        love.graphics.rectangle('line', self.ui.x, self.ui.y, self.length, self.length)
    end)
end