require 'src/states/play/interface/cursor/Cursor'
require 'lib/game/physics/Circle'

CircleCursor = Class{__includes = Cursor}

function CircleCursor:init(def)
    Cursor:init(self, def)
    self.radius = def.radius
    self.minRadius = def.radius
    self.increment = def.increment
end

function CircleCursor:getPosition()
    return Circle(self.world.x, self.world.y, self.radius)
end

function CircleCursor:update(dt)
    Cursor:update(self)
end

function CircleCursor:input()
    if love.mouse.wheelmoved ~= 0 then
        self.radius = math.max(self.minRadius, love.mouse.wheelmoved > 0 and self.radius + self.increment 
        or self.radius - self.increment)
    end

    -- mouse click checks for colliding bricks, which are then destroyed
    -- each destroyed brick should be added to your "ammo" for building
    if self.inRange and love.mouse.wasPressed(1) then
        self.action(self:getPosition())
    end
end

function CircleCursor:render()
    Cursor:render(self, function()
        love.graphics.circle('line', self.ui.x, self.ui.y, self.radius)
    end)
end