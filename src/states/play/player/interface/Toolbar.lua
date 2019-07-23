require 'src/states/play/player/interface/Frames'

Toolbar = Class{}

TOOLBAR_SCALE = 1
TOOLBAR_SIZE = 50 * TOOLBAR_SCALE
TOOL_SIZE = 40 * TOOLBAR_SCALE

function Toolbar:init(playState)
    self.fps = Frames()
    self.tools = {
        gTools.destroy.circle,
        gTools.build.tile,
        gTools.build.rectangle
    }
    self.current = self.tools[1]
    self.toolCount = table.getn(gKeymap.tools.main)
    self.x = VIRTUAL_WIDTH / 2 - ((self.toolCount * TOOLBAR_SIZE)/2)
    self.y = VIRTUAL_HEIGHT - TOOLBAR_SIZE - 10
end

function Toolbar:switch(tool)
	assert(self.tools[tool])
    self.current = self.tools[tool]
end

function Toolbar:update(dt)
    for i = 1, self.toolCount do
        if love.keyboard.wasPressed(gKeymap.tools.main[i]) then
            self:switch(i)
        end
    end
end

function Toolbar:render()
    self.fps:render()
    local x = gCamera.x + self.x
    local y = gCamera.y + self.y

    love.graphics.setColor(1,1,1)
    for i = 1,self.toolCount do
        love.graphics.draw(gTextures.ui.toolbar, x, y, 0, TOOLBAR_SCALE, TOOLBAR_SCALE)

        if self.tools[i] ~= nil then
            if self.tools[i] == self.current then
                love.graphics.setColor(0,0,0,0.3)
                love.graphics.rectangle('fill', x+5, y+5, TOOL_SIZE, TOOL_SIZE)
                love.graphics.setColor(1,1,1)            
            end
            self.tools[i]:render(x+TOOLBAR_SIZE/2,y+TOOLBAR_SIZE/2)
            --love.graphics.draw(gTextures.ui.tools, self.toolImages[i], x+TOOLBAR_SIZE/2, y+TOOLBAR_SIZE/2, 0, TOOLBAR_SCALE, TOOLBAR_SCALE, TOOL_SIZE/2, TOOL_SIZE/2)
        end
        x = x + TOOLBAR_SIZE
    end

    love.graphics.setColor(0,0,0)
end

