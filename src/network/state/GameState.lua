require 'src/network/Data'

require 'src/network/state/Level'
require 'src/network/state/tilemap/Tilemap'
require 'src/network/state/abilities/Abilities'
require 'src/network/state/Players'

-- State holds the current server state for everything necessary
-- Can be compared to redux index

-- Is a class because this will have some functionality such as loading
-- previous state from database etc.
GameState = Class{}

-- physics Library
local bump = require '/lib/game/physics/bump'

function GameState:init()
    self.world = bump.newWorld(80)

    self.level = Level(self.world)
    self.players = Players(self.world, self.level)
    self.abilities = Abilities:init(self.level)
end

function GameState:update(dt)
    self.players:update(dt)
end

-- For periodic synchronization, level may get corrupted
function GameState:getLevelChunk(clientId)
    return self.level:getChunk(self.players.chunkHistory[clientId].current)
end

-- When connecting to server, get all state
function GameState:getSnapshot(clientId)
    local levelChunk = self:getLevelChunk(clientId)

    return {
        players = self.players:getSnapshot(),
        tilemap = levelChunk.tilemap,
        resources = levelChunk.resources
    }
end

function GameState:setSnapshot(segment, snapshot)
    if segment == 'players' then
        self.players:setSnapshot(snapshot)
    else
        self.level:setChunk(segment, snapshot)
    end
end