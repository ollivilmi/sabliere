require 'src/states/play/player/interface/toolbar/Toolbar'

Interface = Class{__includes = AnimatedKinematic}

function Interface:init(playState)
    gTools.load(playState)
    self.toolbar = Toolbar()
    self:switchTool(1)
end

function Interface:switchTool(toolId)
    self.toolbar:switch(toolId)
    self.cursor = self.toolbar.current.cursor
    self.cursor.action = self.toolbar.current.action
end

function Interface:update(dt)
    self.cursor:update(dt)
    for i = 1, self.toolbar.toolCount do
        if love.keyboard.wasPressed(gKeymap.tools.main[i]) then
            self:switchTool(i)
        end
    end
end

function Interface:render()
    self.toolbar:render()
    self.cursor:render()
end