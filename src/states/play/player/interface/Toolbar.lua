require 'src/states/play/player/interface/Frames'

Toolbar = Class{}

function Toolbar:init(def)
    self.fps = Frames()
end

function Toolbar:update(dt)

end

function Toolbar:render()
    self.fps:render()
end

