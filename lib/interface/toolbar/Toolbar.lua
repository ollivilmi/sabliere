require 'lib/interface/Buttonbar'

Toolbar = Class{__includes = Buttonbar}

function Toolbar:init(def)
    Buttonbar:init(self, def)
    self.current = self.components[1]
end

function Toolbar:switch(tool)
	assert(self.components[tool])
    self.current = self.components[tool]
end

function Toolbar:render()
    Buttonbar:render(self)

    -- highlight active tool
    self.current:renderMask(0.2)
end

