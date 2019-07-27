require 'src/states/play/player/interface/cursor/Cursor'
require 'src/states/play/lib/physics/Collision'

RectangleCursor = Class{__includes = Cursor, Rectangle}

function RectangleCursor:init(action)
    Cursor:init(self)
    self:reset()
    self.action = action
    self.cursor = function()
        love.graphics.rectangle('line', self.ui.x, self.ui.y, self.width, self.height)
    end
end

function RectangleCursor:reset()
    self.width = 0
    self.height = 0
end

function RectangleCursor:getPosition()
    local x = self.width < 0 and self.world.x + self.width or self.world.x
    local y = self.height < 0 and self.world.y + self.height or self.world.y
    return Collision(x, y, math.abs(self.width), math.abs(self.height))
end

function RectangleCursor:update(dt)
    if love.mouse.wasPressed(1) then
        self:updateCoordinates(true)
    end

    if love.mouse.wasReleased(1) then
        self.action(self:getPosition())
    end

    if love.mouse.isDown(1) then
        local x, y = self:worldCoordinates(true)

        self.width = math.floor(x - self.world.x)
        self.height = math.floor(y - self.world.y)
    else
        self:updateCoordinates(true)
        self.width = 2
        self.height = 2
    end
end