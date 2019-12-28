Updates = Class{}

function Updates:init(self)
    -- eg. bullet spawned
    self.events = {}

    -- entity:getUpdates()
    self.entities = {}
end

function Updates:pushEvent(data)
	table.insert(self.events, data)
end

function Updates:pushEntity(id, entity)
    self.entities[id] = entity
end

function Updates:entityData()
    local entityData = {}

    for entityId, entity in pairs(self.entities) do
        table.insert(entityData,
            Data({
                entityId = entityId,
                request = 'update'
            }, entity:getUpdates())
        )
    end

    return entityData
end

function Updates:getUpdates()
    local updates = {}

    table.addTable(updates, self:entityData())
    table.addTable(updates, self.events)

    return updates
end

function Updates:clearEvents()
    self.events = {}
end