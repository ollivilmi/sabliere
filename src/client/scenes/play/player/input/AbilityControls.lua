AbilityControls = Class{__includes = Listener}

-- Manages current, active player ability
--
-- Takes in keymap for keybindings
--
-- Interface is needed to check if mouse if hovering over GUI,
-- and to load Toolbar
--
function AbilityControls:init(keymap, interface)
    Listener:init(self)
    self.keys = keymap.toolbar
    
    self.abilities = {
        [self.keys[1]] = {
            name = "Build sand",
            icon = love.graphics.newImage('src/client/assets/textures/sand.png'),
            onclick = function() print ("build") end
        },
        [self.keys[2]] = {
            name = "Shoot",
            icon = love.graphics.newImage('src/client/assets/textures/sand.png'),
            onclick = function() print ("pew") end
        }
    }
    self.currentAbility = self.abilities[self.keys[1]]

    interface.toolbar:load(self)

    self.interface = interface
end

function AbilityControls:update()
    if love.mouse.wasPressed(1) and not self.interface.gui.mousein then
        self.currentAbility.onclick()
    end

    for key, __ in pairs(love.keyboard.keysPressed) do
        self:switchAbility(key)
    end
end

function AbilityControls:switchAbility(key)
    local ability = self.abilities[key]
    
    if ability and ability ~= self.currentAbility then 
        self.currentAbility = ability
        self:broadcastEvent('ABILITY CHANGED', key, ability)
    end
end