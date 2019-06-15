Cursor = Class{}
require 'src/states/play/lib/physics/Circle'

function Cursor:init(radius, playState)
    self.radius = radius
    self.minRadius = radius
    self.x = 0
    self.y = 0
    self.playState = playState
end

function Cursor:getPosition()
    return Circle(self.x, self.y, self.radius)
end

function Cursor:update(dt)
    self.x, self.y = push:toGame(love.mouse.getX(), love.mouse.getY())

    if love.mouse.wheelmoved ~= 0 then
        self.radius = math.max(self.minRadius, love.mouse.wheelmoved > 0 and self.radius + 2 or self.radius - 2)
    end

    -- mouse click checks for colliding bricks, which are then destroyed
    -- each destroyed brick should be added to your "ammo" for building
    if love.mouse.wasPressed(1) then
        self.playState.level:destroyBricks(self:getPosition())
    end
end

-- TODO: switch mode between destroy to build
function Cursor:switchMode()
end

function Cursor:render()
    love.graphics.circle('line', self.x, self.y, self.radius)
end