require 'src/client/scenes/play/entity/AnimatedEntity'

require 'src/client/scenes/play/player/input/EntityControls'
require 'src/client/scenes/play/player/input/AbilityControls'
require 'src/client/scenes/play/player/input/InterfaceControls'
require 'src/client/scenes/play/player/input/CameraControls'

Controls = Class{}

function Controls:init(hotkeys, interface)
    self.hotkeys = hotkeys
    self.interface = interface

    self.controls = {
        camera = CameraControls(hotkeys.camera),
        interface = InterfaceControls(hotkeys.interface, interface)
    }

    Game.client:addListener('PLAYER CONNECTED', function(player)
        self:controlEntity(player)
    end)

    self.active = true
end

function Controls:controlEntity(entity)
    self.player = entity

    -- Movement
    self.controls.entity = EntityControls(self.hotkeys.movement, self.player)

    -- Interface: Toolbar and cursor listen to Ability changed
    self.controls.ability = AbilityControls(self.hotkeys.toolbar, self.interface)
end

function Controls:update(dt)
    -- controls may be disabled for typing etc.
    if self.active then
        for __, controls in pairs(self.controls) do
            controls:update(dt)
        end
    end
end