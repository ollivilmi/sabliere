InterfaceController = Class{}

function InterfaceController:init(rendering, keymap)
    self.keymap = keymap.interface
    self.rendering = rendering

    self.inputs = {
        [self.keymap.hud.toggle] = self.toggleInterface,
        [self.keymap.camera.zoomIn] = function() self:zoom(0.1) end,
        [self.keymap.camera.zoomOut] = function() self:zoom(-0.1) end
    }
end

function InterfaceController:update()
    for key, __ in pairs(love.keyboard.keysPressed) do
        if self.inputs[key] then 
            self.inputs[key](self)
        end
    end
end

function InterfaceController:toggleInterface()
    self.rendering.interface:toggle()
end

function InterfaceController:zoom(amount)
    local camera = self.rendering.camera
    camera:setZoom(camera.zoom + amount)
end
