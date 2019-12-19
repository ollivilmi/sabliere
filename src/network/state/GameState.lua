require 'src/network/Data'

require 'src/network/state/Level'
require 'src/network/state/tilemap/Tilemap'
require 'src/network/state/physics/BoxCollider'

-- State holds the current server state for everything necessary
-- Can be compared to redux index

-- Is a class because this will have some functionality such as loading
-- previous state from database etc.
GameState = Class{}

Timer = require 'lib/game/love-utils/knife/timer'

function GameState:init()
    self.level = Level()
    self.client = {}
    self.player = {}

    self.level.tilemap:addRectangle(BoxCollider(0, 0, 60, 90))
end

function GameState:set(substate, key, value)
    self[substate][key] = value
end

function GameState:update(dt)
end