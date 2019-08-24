require 'lib/interface/Component'
require 'src/assets/settings/Toolmap'
require 'src/states/play/interface/toolbar/Toolbar'

Interface = Class{__includes = AnimatedEntity}

function Interface:init()
    self.components = { 
        toolbar = Toolbar({
            components = gToolmap.main,
            -- centering
            x = VIRTUAL_WIDTH / 2 - ((table.getn(gToolmap.main) * BAR_SIZE)/2),
            -- 10 pixels from top
            y = 10,
            interface = self
        })
    }
    self.visibleComponents = self:getVisibleComponents()
end

function Interface:update(dt)
    for i = 1, table.getn(gToolmap.main) do
        if love.keyboard.wasPressed(gKeymap.tools.main[i]) then
            self.components.toolbar:switch(i)
        end
    end

    if love.keyboard.wasPressed(gKeymap.interface.toggle) then
        self:toggle()
    end

    self.cursor:update(dt)
    self.cursor:mouseover(self.visibleComponents)
end

function Interface:toggle()
    if table.getn(self.visibleComponents) > 0 then
        self.visibleComponents = {}
    else
        self.visibleComponents = self:getVisibleComponents()
    end
end

function Interface:getVisibleComponents()
    local components = {}

    for k,component in pairs(self.components) do
        if component.visible then
            table.insert(components, component)
        end
    end

    return components
end

function Interface:render()
    -- using ui coordinates for interface - reverse the effect of camera
    gCamera:reverse()

    for k,component in pairs(self.visibleComponents) do
        component:render()
    end

    self.cursor:render()
end