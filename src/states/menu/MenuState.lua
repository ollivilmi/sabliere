MenuState = Class{__includes = BaseState}

function MenuState:enter(params)
    self.options = Menubar()
end

function MenuState:update(dt)

end

function MenuState:render()
    love.graphics.clear(1,1,1)
end