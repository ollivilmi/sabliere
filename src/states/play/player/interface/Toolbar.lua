require 'src/states/play/player/interface/Frames'

Toolbar = Class{}

function Toolbar:init(def)
    self.fps = Frames()
    self.toolImages = GenerateQuads(gTextures.ui.tools, 40, 40)

    self.tools = {
        destroy = CircleCursor(
            TILE_SIZE, 2, function()
                playState.level.tilemap:removeTiles(self.current:getPosition())
            end
        ),
        build = SquareCursor(
            TILE_SIZE, function()
                playState.level.tilemap:overwrite(self.current:getPosition())
            end
        ),
        buildRectangle = RectangleCursor(
            function()
                playState.level.tilemap:addTiles(self.current:getPosition())
            end
        )
    }
end

function Toolbar:update(dt)

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
end

