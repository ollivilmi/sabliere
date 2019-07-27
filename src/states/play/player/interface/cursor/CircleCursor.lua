require 'src/states/play/player/interface/cursor/Cursor'
require 'src/states/play/lib/physics/Circle'

CircleCursor = Class{__includes = Cursor}

function CircleCursor:init(radius, increment, action)
    Cursor:init(self)
    self.radius = radius
    self.minRadius = radius
    self.increment = increment
    self.action = action
    self.cursor = function()
        love.graphics.circle('line', self.ui.x, self.ui.y, self.radius)
    end
end

function CircleCursor:getPosition()
    return Circle(self.world.x, self.world.y, self.radius)
end

function CircleCursor:update(dt)
    self:updateCoordinates()

    if love.mouse.wheelmoved ~= 0 then
        self.radius = math.max(self.minRadius, love.mouse.wheelmoved > 0 and self.radius + self.increment 
        or self.radius - self.increment)
    end

    -- mouse click checks for colliding bricks, which are then destroyed
    -- each destroyed brick should be added to your "ammo" for building
    if love.mouse.wasPressed(1) then
        self.action(self:getPosition())
    end
end