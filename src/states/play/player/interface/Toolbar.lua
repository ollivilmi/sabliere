require 'src/states/play/player/interface/Frames'
require 'src/states/play/player/cursor/RectangleCursor'

Toolbar = Class{}

function Toolbar:init(playState)
    self.fps = Frames()
    self.toolImages = GenerateQuads(gTextures.ui.tools, 40, 40)
    self.tools = {
        CircleCursor(
            TILE_SIZE, 2, function()
                playState.level.tilemap:removeTiles(self.current:getPosition())
            end
        ),
        SquareCursor(
            TILE_SIZE, function()
                playState.level.tilemap:overwrite(self.current:getPosition())
            end
        ),
        RectangleCursor(
            function()
                playState.level.tilemap:addTiles(self.current:getPosition())
            end
        )
    }
    self.current = self.tools[1]
    self.toolCount = table.getn(gKeymap.tools.main)
end

function Toolbar:switch(tool)
	assert(self.tools[tool])
    self.current = self.tools[tool]
end

function Toolbar:update(dt)
    self.current:update(dt)
    for i = 1, self.toolCount do
        if love.keyboard.wasPressed(gKeymap.tools.main[i]) then
            self:switch(i)
        end
    end
end

function Toolbar:render()
    self.fps:render()
    local x = gCamera.x + VIRTUAL_WIDTH / 2 - 187.5
    local y = gCamera.y + VIRTUAL_HEIGHT - 50

    love.graphics.setColor(0,0,0,0.9)
    love.graphics.rectangle('fill', x-6.75, y-5, 390, 45)
    love.graphics.setColor(0.5,0.7,0.7)

    for i = 1,10 do
        love.graphics.draw(gTextures.ui.toolbar, x,y, 0, 0.75, 0.75)
        x = x + 37.5
    end

    love.graphics.setColor(0,0,0)
    self.current:render()
end

