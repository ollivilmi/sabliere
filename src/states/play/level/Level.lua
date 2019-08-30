require 'src/states/play/level/tilemap/Tilemap'
require 'src/states/play/entity/player/Player'

Level = Class{}

function Level:init(playState)
    gTilemap = Tilemap()
    gPlayer = Player(self)
    self.entities = { gPlayer }
    gCamera = Camera(0.01, gPlayer, 150)
end

function Level:addEntity(entity)
    table.insert(self.entities, entity)
end

function Level:update(dt)
    gCamera:update(dt)

    for k, entity in pairs(self.entities) do
        entity:update(dt)
        -- entity:collides()
    end
end

function Level:render()
    -- using world coordinates from camera
    gCamera:translate()
    love.graphics.setColor(0.6,0.6,0.6)
    love.graphics.clear(0.5, 0.4, 0.3, 255)
    love.graphics.draw(gTextures.background, 0, 0)
    gTilemap:render()

    for k, entity in pairs(self.entities) do
        entity:render()
    end

    if DEBUG_MODE then
        gPlayer.toolRange:render()
    end
end