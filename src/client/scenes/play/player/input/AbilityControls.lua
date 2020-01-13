AbilityControls = Class{__includes = Listener}

-- Manages current, active player ability
--
-- Takes in keymap for keybindings -> abilityId
--
-- Interface is needed to check if mouse if hovering over GUI
--
function AbilityControls:init(hotkeys, interface)
    Listener:init(self)

    self.hotkeys = {}
    
    self.abilities = Game.state.abilities
    self.interface = interface

    for i, key in pairs(hotkeys) do
        self.hotkeys[key] = i
    end

    self.current = 1

    self.interface.toolbar:load(self)
    self.interface.cursor:load(self)
end

function AbilityControls:update()
    if love.mouse.wasPressed(1) and not self.interface.gui.mousein then
        local x, y = Camera:worldCoordinates(love.mouse.getX(), love.mouse.getY())
        
        Game.client.updates:pushEvent(Data(
            {request = 'ability', abilityId = self.current},
            {coords = Coordinates(x, y)})
        )
    end

    for key, __ in pairs(love.keyboard.keysPressed) do
        self:switchAbility(key)
    end
end

function AbilityControls:switchAbility(key)
    local ability = self.abilities[self.hotkeys[key]]
    
    if ability and self.hotkeys[key] ~= self.current then 
        self.current = self.hotkeys[key]
        self:broadcastEvent('ABILITY CHANGED', self.current)
    end
end