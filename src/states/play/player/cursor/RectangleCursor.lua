require 'src/states/play/player/cursor/Cursor'
require 'src/states/play/lib/physics/Rectangle'

RectangleCursor = Class{__includes = Cursor, Rectangle}

function RectangleCursor:init(action)
    self:reset()
    self.action = action
end

function RectangleCursor:reset()
    self.x = 0
    self.y = 0
    self.width = 0
    self.height = 0
end

-- for square cursor, we will snap to nearest block divisible by MINIMUM_TILE_SIZE
-- needs to be updated for other directions
function RectangleCursor:getPosition()
    return Rectangle(self.x, self.y, self.width, self.height)
end

function RectangleCursor:update(dt)
    if love.mouse.wasPressed(1) then
        self:updateCoordinates()
        self.x, self.y = math.snap(self.x, self.y)
    end

    if love.mouse.wasReleased(1) then
        self.action()
    end

    if love.mouse.isDown(1) then
        local x, y = self:currentCoordinates()
        x, y = math.snap(x, y)

        self.width = math.floor(x - self.x)
        self.height = math.floor(y - self.y)
    else
        self:updateCoordinates()
        self.x, self.y = math.snap(self.x, self.y)
        self.width = 2
        self.height = 2
    end
end

function RectangleCursor:render()
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end