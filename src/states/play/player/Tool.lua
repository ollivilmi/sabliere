Tool = Class{}
require 'src/states/play/player/cursor/CircleCursor'
require 'src/states/play/player/cursor/SquareCursor'
require 'src/states/play/player/cursor/RectangleCursor'

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
                tile = self.current:getPosition()
                playState.level.tilemap:removeTiles(tile:mapCollider())
                playState.level.tilemap:addTile(tile)
            end
        ),
        buildRectangle = RectangleCursor(
            function()
                playState.level.tilemap:addTiles(self.current:getPosition())
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
    elseif love.keyboard.wasPressed('3') then
        self:switch("buildRectangle")
    end
end

function Tool:render()
    love.graphics.setColor(0,0,0)
    self.current:render()
end