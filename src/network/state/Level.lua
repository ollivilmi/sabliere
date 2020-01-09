require 'src/network/state/tilemap/Tilemap'
require 'src/network/state/entity/Players'

require 'src/network/state/abilities/Abilities'

-- physics Library
local bump = require '/lib/game/physics/bump'

Level = Class{}

function Level:init()
    self.world = bump.newWorld(80)
    self.tilemap = Tilemap(100, 100, self.world)
    self.abilities = Abilities:init(self)

    self.players = Players(self.world)
end

function Level:addTestTiles()
	self.tilemap:addRectangle({x=0,y=500,w=3000,h=100}, 'g')
    self.tilemap:addRectangle({x=0,y=600,w=3000,h=500}, 'r')
    self.tilemap:addRectangle({x=1000,y=450,w=200,h=60}, 'r')
    self.tilemap:addRectangle({x=1000,y=275,w=200,h=20}, 'r')
end

function Level:update(dt)
    self.players:update(dt)
end

function Level:getSnapshot(entity)
    return {
        players = self.players:getSnapshot(),
        chunk =  self.tilemap:getChunk()
    }
end

function Level:setSnapshot(snapshot)
    self.players:setSnapshot(snapshot.players)
    self.tilemap:setChunk(snapshot.chunk)
end