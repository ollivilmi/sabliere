require 'src/states/play/player/interface/cursor/Cursor'
require 'src/states/play/lib/physics/Circle'

CircleCursor = Class{__includes = Cursor}

function CircleCursor:init(radius, increment, action)
    self.radius = radius
    self.minRadius = radius
    self.increment = increment
    self.x = 0
    self.y = 0
    self.action = action
end

function CircleCursor:getPosition()
    return Circle(self.x, self.y, self.radius)
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

function CircleCursor:render()
    love.graphics.setColor(0,0,0)
    if self.hoveringComponent ~= nil then
        self.hoveringComponent:renderEdges(0,0,0)
    else
        love.graphics.circle('line', self.x, self.y, self.radius)
    end
end