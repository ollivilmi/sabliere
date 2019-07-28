require 'lib/interface/Component'
require 'src/assets/settings/Toolmap'
require 'lib/interface/toolbar/Toolbar'

Interface = Class{__includes = AnimatedKinematic}

function Interface:init(playState)
    gTools.load(playState)
    gToolmap.load()

    self.components = { 
        toolbar = Toolbar({
            components = gToolmap.main,
            -- centering
            x = VIRTUAL_WIDTH / 2 - ((table.getn(gToolmap.main) * BAR_SIZE)/2),
            -- 10 pixels from bottom
            y = VIRTUAL_HEIGHT - BAR_SIZE - 10
        })
    }
    self:switchTool(1)
end

function Interface:switchTool(toolId)
    self.components.toolbar:switch(toolId)
    self.cursor = self.components.toolbar.current.cursor
    self.cursor.action = self.components.toolbar.current.action
end

function Interface:update(dt)
    for i = 1, table.getn(gToolmap.main) do
        if love.keyboard.wasPressed(gKeymap.tools.main[i]) then
            self:switchTool(i)
        end
    end

    self.cursor:update(dt)
    self.cursor:hoversComponent(self:visibleComponents())
end

function Interface:visibleComponents()
    local components = {}

    for k,component in pairs(self.components) do
        if component.visible then
            table.insert(components, component)
        end
    end

    return components
end

function Interface:render()
    for k,component in pairs(self:visibleComponents()) do
        component:render()
    end

    self.cursor:render()
end