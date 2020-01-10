require 'lib/language/Listener'

require 'src/network/state/entity/Entity'
require 'src/client/scenes/play/entity/AnimatedEntity'

local models = require 'src/client/scenes/play/entity/models/playerModels'
local json = require 'lib/language/json'

Players = Class{__includes = Listener}

function Players:init(world)
    Listener:init(self)
    self.players = {}
    self.disconnectedPlayers = {}
    self.world = world
end

function Players:createEntity(id, state)
    if self.players[id] then return self.players[id] end

    local entity = self.disconnectedPlayers[id] or Entity(state, self.world)
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
    self.disconnectedPlayers[id] = self.players[id]
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
    for id, newState in pairs(players) do
        local player = self.players[id]
        if not player then
            self:createEntity(id, newState)
        else
            -- only update player x, y if player is too far from previous location
            -- this is to prevent hitches in the game
            if math.distance(player.x, player.y, newState.x, newState.y) > 300 then
                player.x = newState.x
                player.y = newState.y
            end
        end
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