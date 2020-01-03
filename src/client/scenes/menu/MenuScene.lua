require 'src/clients/states/State'

MenuState = Class{__includes = State}

function MenuState:enter(params)
    self.options = Menubar()
end

function MenuState:update(dt)

end

function MenuState:render()
    love.graphics.clear(1,1,1)
end