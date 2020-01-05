require 'src/client/scenes/play/entity/AnimatedEntity'

require 'src/client/scenes/play/player/input/EntityControls'
require 'src/client/scenes/play/player/input/AbilityControls'
require 'src/client/scenes/play/player/input/InterfaceControls'
require 'src/client/scenes/play/player/input/RenderControls'

Controls = Class{}

function Controls:init(keymap, rendering)
    self.controls = {
        rendering = RenderControls(keymap.rendering, rendering),
        interface = InterfaceControls(keymap.interface, rendering.interface)
    }

    self.active = true
    self.keymap = keymap
    self.rendering = rendering
end

function Controls:controlEntity(entity)
    self.controls.entity = EntityControls(self.keymap.move, entity)
    self.controls.ability = AbilityControls(self.keymap.ability, self.rendering.interface)
end

function Controls:update(dt)
    -- controls may be disabled for typing etc.
    if self.active then
        for __, controls in pairs(self.controls) do
            controls:update(dt)
        end
    end
end