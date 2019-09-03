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
    if self.inRange and love.mouse.wasPressed(1) then
        self.ignoringUi = true
        -- stop updating coordinates for a snapshot of initial coordinates
        -- (point where rectangle is dragged from + camera location)
        self.updatingCoordinates = false
        self.camera = gCamera:coordinates()
    end

    if love.mouse.wasReleased(1) then
        self.ignoringUi = false
        self.updatingCoordinates = true
        self.action(self:getPosition())
        self:reset()
    end

    if love.mouse.isDown(1) then
        local coords = self:worldCoordinates(true)

        self.width = math.floor(coords.x - self.world.x)
        self.height = math.floor(coords.y - self.world.y)
    else
        self.camera = gCamera:coordinates()
    end
end

function RectangleCursor:render()
    Cursor:render(self, function()
        -- vector is used to move the drawn rectangle if the camera moves while mouse(1) is down
        local x, y = math.vector(gCamera.x, gCamera.y, self.camera.x, self.camera.y)
        love.graphics.rectangle('line', self.ui.x + x, self.ui.y + y, self.width, self.height)
    end)
end