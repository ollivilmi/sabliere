require 'lib/interface/Bar'

Menubar = Class{__includes = Bar}

function Menubar:init(def)
    Bar:init(self, def)
    def.columns = 1
    def.rows = table.getn(def.components)
end