require 'src/client/scenes/play/entity/AnimatedEntity'

require 'src/client/scenes/play/player/input/EntityControls'
require 'src/client/scenes/play/player/input/AbilityControls'
require 'src/client/scenes/play/player/input/InterfaceControls'
require 'src/client/scenes/play/player/input/CameraControls'

Controls = Class{}

function Controls:init(hotkeys, rendering)
    self.controls = {
        camera = CameraControls(hotkeys.camera, rendering.camera),
        interface = InterfaceControls(hotkeys.interface, rendering.interface)
    }

    self.active = true
    self.hotkeys = hotkeys
    self.rendering = rendering
end

function Controls:controlEntity(entity)
    self.controls.entity = EntityControls(self.hotkeys.movement, entity)
    self.controls.ability = AbilityControls(self.hotkeys.toolbar, self.rendering.interface)
end

function Controls:update(dt)
    -- controls may be disabled for typing etc.
    if self.active then
        for __, controls in pairs(self.controls) do
            controls:update(dt)
        end
    end
end