require 'lib/language/Listener'

require 'src/network/state/entity/Entity'
require 'src/client/scenes/play/entity/AnimatedEntity'

local models = require 'src/client/scenes/play/entity/models/playerModels'
local json = require 'lib/language/json'

Players = Class{__includes = Listener}

function Players:init(world, level)
    Listener:init(self)
    self.players = {}
    self.disconnectedPlayers = {}

    self.chunkHistory = require 'src/network/state/entity/ChunkHistory'
    self.world = world
    self.level = level
end

function Players:createEntity(id, state)
    if self.players[id] then return self.players[id] end

    local entity = self.disconnectedPlayers[id] or Entity(state, self.world)
    entity.isPlayer = true

    self.players[id] = entity
    self.chunkHistory[id] = {}
    self.chunkHistory:update(id, self.level:getEntityChunk(entity))

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
    self.chunkHistory[id] = nil
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
        local cols = player:update(dt)
        self:collisions(id, cols)
        self:updateChunk(id, player)
    end
end

function Players:collisions(player, cols)
    local resources = {}

    for __, col in pairs(cols) do
        if col.other.isResource then
            table.insert(resources, col.other)
        elseif col.other.isProjectile then
            self:broadcastEvent('PROJECTILE COLLISION', player, col.other)
        end
    end

    if #resources > 0 then
        self:broadcastEvent('RESOURCE COLLISION', player, resources)
    end
end

function Players:updateChunk(id, player)
    local chunk = self.level:getEntityChunk(player)
    local current = self.chunkHistory[id].current

    if chunk.x ~= current.x or chunk.y ~= current.y then
        local timeElapsed = self.chunkHistory:timeElapsed(id, chunk)
        self.chunkHistory:update(id, chunk)
        self:broadcastEvent('PLAYER CHUNK', id, timeElapsed)
    end
end

function Players:getActiveChunks()
    local chunkSet = {}

    for id, __ in pairs(self.players) do
        local chunk = self.chunkHistory[id].current
        if chunk then
            chunkSet[chunk.x .. chunk.y] = chunk
        end
    end

    return chunkSet
end

function Players:print()
    for id, player in pairs(self.players) do
        print(id, json.encode(player:getState()))
    end
end