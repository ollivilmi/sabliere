require 'src/network/Data'

require 'src/network/state/Level'
require 'src/network/state/tilemap/Tilemap'
require 'src/network/state/physics/BoxCollider'

-- State holds the current server state for everything necessary
-- Can be compared to redux index

-- Is a class because this will have some functionality such as loading
-- previous state from database etc.
GameState = Class{}

function GameState:init()
    self.level = Level()
    self.client = {}

    self.level.tilemap:addRectangle(BoxCollider(0, 500, 3000, 500))
end

function GameState:update(dt)
    self.level:update(dt)
end

-- Returns snapshot of gamestate, tiles are limited to player
-- location
function GameState:getSnapshot(player)
    return self.level:getSnapshot()
end

function GameState:setSnapshot(snapshot)
    self.level:setSnapshot(snapshot)
end