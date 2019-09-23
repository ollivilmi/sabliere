Command = Class{}

function Command:init(def)
    self.spec = def.spec
    self.execute = def.execute
end