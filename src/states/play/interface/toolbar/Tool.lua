require 'lib/interface/Button'

Tool = Class{__includes = Button}

-- def
-- 
-- button
-- cursor type
-- range
function Tool:init(def)
    Button:init(self, def)
    self.cursor = def.cursor
end