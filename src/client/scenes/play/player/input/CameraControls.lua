CameraControls = Class{}

function CameraControls:init(hotkeys, camera)
    self.inputs = {
        [hotkeys.zoomIn] = function() camera:setZoom(camera.zoom + 0.05) end,
        [hotkeys.zoomOut] = function() camera:setZoom(camera.zoom - 0.05) end
    }
end

function CameraControls:update()
    for key, __ in pairs(love.keyboard.keysPressed) do
        if self.inputs[key] then
            self.inputs[key]()
        end
    end
end