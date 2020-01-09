require 'src/network/Data'

require 'src/network/state/Level'
require 'src/network/state/tilemap/Tilemap'

-- State holds the current server state for everything necessary
-- Can be compared to redux index

-- Is a class because this will have some functionality such as loading
-- previous state from database etc.
GameState = Class{}

function GameState:init()
    self.level = Level()
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