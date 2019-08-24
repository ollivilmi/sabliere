require 'lib/interface/Bar'

Toolbar = Class{__includes = Bar}

function Toolbar:init(def)
    def.columns = table.getn(def.components)
    self.interface = def.interface

    local x = def.x
    local y = def.y

    -- map tools on toolbar
    for k,tool in pairs(def.components) do
        tool.area = BoxCollider(
                x+5,
                y+5,
                BUTTON_SIZE,
                BUTTON_SIZE
            )
        x = x + BAR_SIZE
    
        tool.onClick = function()
            self:switch(k)
        end
    end

    def.rows = 1
    def.scale = BUTTON_SCALE
    Bar:init(self, def)
    self:switch(1)
end

function Toolbar:switch(tool)
    self.current = self.components[tool]
    self.interface.cursor = self.current.cursor
    self.interface.cursor.action = self.current.action
end

function Toolbar:render()
    Bar:render(self)

    -- highlight active tool
    self.current:renderMask(0.2)
end

