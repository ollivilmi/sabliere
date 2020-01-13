require 'src/network/state/entity/Entity'
require 'src/client/scenes/play/entity/AnimatedEntity'

local models = require 'src/client/scenes/play/entity/models/playerModels'

PlayerRendering = Class{}

function PlayerRendering:init(players)
    self.players = players

    players:addListener('NEW PLAYER', function(id)
        self:animatePlayer(id)
    end)

    players:addListener('PLAYER REMOVED', function(id)
        self:removePlayer(id)
    end)

    self.animatedPlayers = {}
end

function PlayerRendering:update(dt)
    for id, animation in pairs(self.animatedPlayers) do
        animation:update(dt)
    end
end

function PlayerRendering:animatePlayer(id)
    local entity = self.players:getEntity(id)

    self.animatedPlayers[id] = AnimatedEntity(entity, models[entity.model]())
end

function PlayerRendering:removePlayer(id)
    self.animatedPlayers[id] = nil
end

function PlayerRendering:render()
    for id, animatedPlayer in pairs(self.animatedPlayers) do
        animatedPlayer:render()
    end
end
