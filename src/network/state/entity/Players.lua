require 'src/network/state/entity/Entity'
require 'src/client/states/play/entity/AnimatedEntity'
local models = require 'src/client/states/play/entity/models/playerModels'
local json = require 'lib/language/json'

Players = Class{}

function Players:init(level)
    self.players = {}
    self.level = level
end

function Players:setEntity(id, state)
    self.players[id] = Entity(state, self.level)
end

function Players:setAnimatedEntity(id, state)
    local entity = Entity(state, self.level)
    self.players[id] = AnimatedEntity(entity, models[entity.model]())
end

function Players:updateState(id, state)
    -- todo interpolate
    local player = self.players[id]

    if player then
        if player.animated then
            player.entity:updateState(state)
        else
            player:updateState(state)
        end
    end
end

function Players:get(id)
    return self.players[id]
end

function Players:set(id, entity)
    self.players[id] = entity
end

function Players:disconnect(id)
    self.players[id] = nil
end

function Players:getSnapshot()
    local players = {}

    for id, player in pairs(self.players) do
        players[id] = player:getState()
    end

    return players
end

function Players:setSnapshot(players)
    for id, player in pairs(players) do
        self.players[id] = Entity(player, self.level)
    end
end

function Players:collision(collider)
    for id, player in pairs(self.players) do
        if collider:collides(player) then
            return player
        end
    end
end

function Players:update(dt)
    for id, player in pairs(self.players) do
        player:update(dt)
    end
end

function Players:animate()
    if not love then return end

    for id, entity in pairs(self.players) do
        -- Check to see that the Entity is not already animated
        if not entity.animated then
            self.players[id] = AnimatedEntity(entity, models[entity.model]())
        end
    end
end

function Players:render()
    for id, player in pairs(self.players) do
        player:render()
    end
end

function Players:print()
    for id, player in pairs(self.players) do
        print(id, json.encode(player:getState()))
    end
end