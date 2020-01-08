require 'lib/language/Listener'

require 'src/network/state/entity/Entity'
require 'src/client/scenes/play/entity/AnimatedEntity'

local models = require 'src/client/scenes/play/entity/models/playerModels'
local json = require 'lib/language/json'

Players = Class{__includes = Listener}

function Players:init(world)
    Listener:init(self)
    self.players = {}
    self.world = world
end

function Players:createEntity(id, state)
    local entity = Entity(state, self.world)
    self.players[id] = entity
    self.world:add(entity, entity.x, entity.y, entity.w, entity.h)
    
    self:broadcastEvent('NEW PLAYER', id)

    return self.players[id]
end

function Players:getEntity(id)
    return self.players[id]
end

function Players:removeEntity(id)
    self.world:remove(self.players[id])
    self.players[id] = nil
    self:broadcastEvent('PLAYER REMOVED', id)
end

function Players:getSnapshot()
    local players = {}

    for id, player in pairs(self.players) do
        players[id] = player:getState()
    end

    return players
end

function Players:setSnapshot(players)
    for id, playerState in pairs(players) do
        self:createEntity(id, playerState)
    end
end

function Players:getUpdates()
    local players = {}

    for id, player in pairs(self.players) do
        players[id] = player:getUpdates()
    end

    return players
end

function Players:update(dt)
    for id, player in pairs(self.players) do
        player:update(dt)
    end
end

function Players:print()
    for id, player in pairs(self.players) do
        print(id, json.encode(player:getState()))
    end
end