RenderControls = Class{}

-- Camera controls
function RenderControls:init(keymap, rendering)
    local camera = rendering.camera

    self.inputs = {
        [keymap.camera.zoomIn] = function() camera:setZoom(camera.zoom + 0.05) end,
        [keymap.camera.zoomOut] = function() camera:setZoom(camera.zoom - 0.05) end
    }
end

function RenderControls:update()
    for key, __ in pairs(love.keyboard.keysPressed) do
        if self.inputs[key] then
            self.inputs[key]()
        end
    end
end