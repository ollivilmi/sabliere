require 'src/states/play/level/tilemap/Tilemap'

Level = Class{}

function Level:init(playState)
    self.tilemap = Tilemap()
    self.entities = { Player(self) }
    gCamera = Camera(0.01, self.entities[1], 150)
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
    self.tilemap:render()

    for k, entity in pairs(self.entities) do
        entity:render()
    end
end