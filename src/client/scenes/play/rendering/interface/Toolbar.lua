Toolbar = Class{}

-- Toolbar is the main HUD component that displays current
-- active tool/ability for the player.
--
function Toolbar:init(gui, abilityDetails, group)
    self.gui = gui
    self.unit = gui.style.unit
    self.abilityDetails = abilityDetails
    
    local abilityCount = 10

    self.group = group or self.gui:group('Toolbar',
        {
            x = love.graphics.getWidth() / 2 - ((abilityCount / 2) * self.gui.style.unit),
            y = love.graphics.getHeight() - self.gui.style.unit,
            w = abilityCount * self.gui.style.unit,
            h = self.gui.style.unit
        }
    )

    self:setStyle()
end

-- Create buttons, assign abilities
function Toolbar:load(abilityControls)
    local hotkeys = abilityControls.hotkeys

    for key, id in pairs(hotkeys) do
        self:createButton(id, key, self.abilityDetails[id])
    end

    self.group.value = 1

    abilityControls:addListener('ABILITY CHANGED', function(id)
        self.group.value = id
    end)
end

function Toolbar:clear()
    while #self.group.children > 0 do
        self.gui:rem(self.group.children[1])
    end
end

function Toolbar:createButton(index, key, ability)
    local button = self.gui:option(key, {(index - 1) * self.unit, 0, self.unit, self.unit}, self.group, index)

    if ability then
        -- todo tooltip : name, description
        -- probably have to customize it quite heavily
        local icon = self.gui:image(nil, {5, 5, 0, 0}, button, ability.icon)
    end

    -- Handle clicks as keypresses
    button.click = function(this)
        love.keyboard.keysPressed[key] = true
    end
end

function Toolbar:setStyle()
    self.group.style.default = {0.1,0.1,0.1}
    self.group.style.hilite = {0.15,0.15,0.15}
    self.group.style.focus = {0.15,0.15,0.15}
end