require 'src/states/play/player/interface/hud/Frames'
require 'src/states/play/lib/physics/Rectangle'

Toolbar = Class{__includes = Component}

function Toolbar:init(def)
    self.fps = Frames()

    self.visible = true
    self.components = def.tools
    self.current = self.components[1]
    self.toolCount = table.getn(self.components)

    self.area = Collision(
        def.x,
        def.y,
        self.toolCount * TOOLBAR_SIZE,
        TOOLBAR_SIZE
    )
end

function Toolbar:switch(tool)
	assert(self.components[tool])
    self.current = self.components[tool]
end

function Toolbar:render()
    self.fps:render()
    local x = gCamera.x + self.area.x
    local y = gCamera.y + self.area.y

    love.graphics.setColor(1,1,1)
    for i = 1, self.toolCount do
        love.graphics.draw(gTextures.ui.toolbar, x, y, 0, TOOLBAR_SCALE, TOOLBAR_SCALE)
        x = x + TOOLBAR_SIZE
    end

    for k,component in pairs(self.components) do
        component:render()
    end

    -- highlight active tool
    self.current:renderMask(0.2)

    love.graphics.setColor(0,0,0)
end

