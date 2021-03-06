require 'src/network/state/tilemap/Tilemap'
require 'src/network/state/props/Resources'
require 'src/network/state/props/Projectiles'

Level = Class{}

-- placing tiles in correct coordinates
local tilemath = require 'lib/game/math/tilemath'

-- Contains level state, handled in chunks
-- -> tilemap, resources..
--
-- CHUNK
-- =====
-- Only send a chunk of the level state that is visible to the player
-- Chunk = (screen width * 2) * (screen height * 2)
-- ======
-- 
-- SCREEN
-- ======
-- Width / height is always the same, max zoom is scaled on client side
-- based on resolution
-- ======
function Level:init(world)
    self.world = world
    self.tileSize = (world.cellSize / 2^2)

    local zoom = 1.3

    self.screen = {
        w = tilemath.snap(self.tileSize, 1280 * zoom),
        h = tilemath.snap(self.tileSize, 720 * zoom)
    }

    self.chunk = {
        w = self.screen.w * 2, 
        h = self.screen.h * 2
    }

    self.tilemap = Tilemap(self)
    self.resources = Resources(self)
    self.projectiles = Projectiles(self.world)
end

function Level:addTestTiles()
	self.tilemap:addRectangle({x=0,y=500,w=8000,h=4000}, 'g')
    self.tilemap:addRectangle({x=0,y=600,w=8000,h=4000}, 'r')
    self.tilemap:addRectangle({x=1000,y=450,w=200,h=60}, 'r')
    self.tilemap:addRectangle({x=1000,y=275,w=200,h=20}, 'r')
end

function Level:getChunk(rectangle)
    local x, y = math.rectangleCenter(rectangle)

    local x = x - math.fmod(x, self.screen.w)
    local y = y - math.fmod(y, self.screen.h)

    return {
        x = x,
        y = y,
    }
end

function Level:getItems(chunk)
    return self.world:queryRect(chunk.x, chunk.y, self.chunk.w, self.chunk.h)
end

function Level:getSnapshot(chunk)
    return {
        tilemap = self.tilemap:getChunk(chunk),
        resources = self.resources:getChunk(chunk)
    }
end

function Level:setSnapshot(segment, snapshot)
    if segment == 'tilemap' then
        self.tilemap:setChunk(snapshot)
    elseif segment == 'resources' then
        self.resources:setResources(snapshot)
    end
end

function Level:update(dt)
    self.projectiles:update(dt)
end