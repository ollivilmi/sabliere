require 'src/states/play/player/interface/Frames'

Button = Class{}

function Button:init(image, action)
    self.fps = Frames()
end

function Button:update(dt)
-- on mouse click
    self:action()
end

function Button:press()
    self:action()
end

function Button:render()
    self.fps:render()
end

