require 'lib/interface/Buttonbar'

Menubar = Class{__includes = Buttonbar}

function Menubar:init(def)
    Buttonbar:init(self, def)
    self.current = self.components[1]
end

function Menubar:switch(tool)
	assert(self.components[tool])
    self.current = self.components[tool]
end

function Menubar:render()
    Buttonbar:render(self)

    -- highlight active tool
    self.current:renderMask(0.2)
end

