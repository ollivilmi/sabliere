require 'lib/interface/cursor/Cursor'
require 'lib/physics/BoxCollider'

RectangleCursor = Class{__includes = Cursor, Rectangle}

function RectangleCursor:init(def)
    def.snap = true
    Cursor:init(self, def)

    self:reset()
    self.camera = { x = 0, y = 0 }
end

function RectangleCursor:reset()
    self.width = 0
    self.height = 0
end

function RectangleCursor:getPosition()
    local x = self.width < 0 and self.world.x + self.width or self.world.x
    local y = self.height < 0 and self.world.y + self.height or self.world.y
    return BoxCollider(x, y, math.abs(self.width), math.abs(self.height))
end

function RectangleCursor:update(dt)
    -- take snapshot of initial coordinates for mouse & camera
    if love.mouse.wasPressed(1) then
        Cursor:update(self)
        self.camera.x, self.camera.y = gCamera:coordinates()
    end

    if love.mouse.wasReleased(1) then
        self.action(self:getPosition())
    end

    if love.mouse.isDown(1) then
        local x, y = self:worldCoordinates(true)

        self.width = math.floor(x - self.world.x)
        self.height = math.floor(y - self.world.y)
    else
        Cursor:update(self)
        self.camera.x, self.camera.y = gCamera:coordinates()
        self.width = 2
        self.height = 2
    end
end

function RectangleCursor:render()
    Cursor:render(self, function()
        -- vector is used to move the drawn rectangle if the camera moves while mouse(1) is down
        local x, y = gCamera:vector(self.camera.x, self.camera.y)
        love.graphics.rectangle('line', self.ui.x + x, self.ui.y + y, self.width, self.height)
    end)
end