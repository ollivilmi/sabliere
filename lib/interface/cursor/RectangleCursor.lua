require 'lib/interface/cursor/Cursor'
require 'lib/physics/BoxCollider'

RectangleCursor = Class{__includes = Cursor, Rectangle}

function RectangleCursor:init(def)
    def.snap = true
    Cursor:init(self, def)

    self:reset()
    -- used to handle camera movement while mouse is held down
    self.camera = Coordinates()
    self.start = Coordinates()
end

function RectangleCursor:reset()
    self.width = 2
    self.height = 2
end

function RectangleCursor:getPosition()
    -- translate x,y to the top left corner of the rectangle
    local x = self.width < 0 and self.world.x + self.width or self.world.x
    local y = self.height < 0 and self.world.y + self.height or self.world.y
    return BoxCollider(x, y, math.abs(self.width), math.abs(self.height))
end

function RectangleCursor:update(dt)
    Cursor:update(self)
end

function RectangleCursor:input()
    -- take snapshot of initial coordinates for mouse & camera
    if love.mouse.wasPressed(1) then
        self.ignoringUi = true
        self.start = self:worldCoordinates(true)
        self.camera = gCamera:coordinate()
    end

    if love.mouse.wasReleased(1) then
        self.ignoringUi = false
        self.action(self:getPosition())
    end

    if love.mouse.isDown(1) then
        self.width = math.floor(self.start.x - self.world.x)
        self.height = math.floor(self.start.y - self.world.y)
    else
        Cursor:updateCoordinates(self)
        self.camera = gCamera:coordinate()
        self:reset()
    end
end

function RectangleCursor:render()
    Cursor:render(self, function()
        -- vector is used to move the drawn rectangle if the camera moves while mouse(1) is down
        local x, y = gCamera:vector(self.camera.x, self.camera.y)
        love.graphics.rectangle('line', self.ui.x + x, self.ui.y + y, self.width, self.height)
    end)
end