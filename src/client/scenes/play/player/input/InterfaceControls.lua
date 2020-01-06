InterfaceControls = Class{}

-- Controller to handle interface:
-- open menu, hide...
function InterfaceControls:init(hotkeys, interface)
    self.interface = interface

    self.inputs = {
        [hotkeys.toggle] = interface.toggle,
    }
end

function InterfaceControls:update()
    for key, __ in pairs(love.keyboard.keysPressed) do
        if self.inputs[key] then 
            self.inputs[key](self.interface)
        end
    end
end