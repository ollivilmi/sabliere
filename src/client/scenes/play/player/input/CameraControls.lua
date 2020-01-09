CameraControls = Class{}

function CameraControls:init(hotkeys)
    self.inputs = {
        [hotkeys.zoomIn] = function() Camera:setZoom(Camera.zoom + 0.05) end,
        [hotkeys.zoomOut] = function() Camera:setZoom(Camera.zoom - 0.05) end
    }
end

function CameraControls:update()
    for key, __ in pairs(love.keyboard.keysPressed) do
        if self.inputs[key] then
            self.inputs[key]()
        end
    end
end