Tool = Class{}
require 'src/states/play/player/cursor/CircleCursor'
require 'src/states/play/player/cursor/SquareCursor'

function Tool:init(playState)
    self.playState = playState
    self.tools = {
        destroy = CircleCursor(
            TILE_SIZE, 2, function()
                playState.level.tilemap:removeTiles(self.current:getPosition())
            end
        ),
        build = SquareCursor(
            TILE_SIZE, function()
                playState.level.tilemap:addTile(self.current:getPosition(), true)
            end
        )
    }
    self.current = self.tools.destroy
end

function Tool:switch(tool)
	assert(self.tools[tool])
    self.current = self.tools[tool]
end

function Tool:update(dt)
    self.current:update(dt)
    if love.keyboard.wasPressed('1') then
        self:switch("destroy")
    elseif love.keyboard.wasPressed('2') then
        self:switch("build")
    end
end

function Tool:render()
    love.graphics.setColor(0,0,0)
    self.current:render()
end