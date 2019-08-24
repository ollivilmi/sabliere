require 'lib/interface/Bar'

Toolbar = Class{__includes = Bar}

function Toolbar:init(def)
    def.columns = table.getn(def.components)
    
    local x = def.x
    local y = def.y

    for k,button in pairs(def.components) do
            button.area = BoxCollider(
                x+5,
                y+5,
                BUTTON_SIZE,
                BUTTON_SIZE
            )
        x = x + BAR_SIZE
    end
    
    def.rows = 1
    def.scale = BUTTON_SCALE
    Bar:init(self, def)
    self.current = self.components[1]
end

function Toolbar:switch(tool)
	assert(self.components[tool])
    self.current = self.components[tool]
end

function Toolbar:render()
    Bar:render(self)

    -- highlight active tool
    self.current:renderMask(0.2)
end

