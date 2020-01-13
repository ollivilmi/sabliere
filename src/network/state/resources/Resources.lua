Resources = Class{}

function Resources:init(level)
    self.world = level.world
    self.chunk = level.chunk

    self.types = {
        t = {
            id = 't',
            size = 10
        }
    }
end

function Resources:addResource(x, y, id)
    local type = self.types[id]
    if not type then return end

    local resource = {id = id, x = x, y = y, isResource = true}

    self.world:add(resource, x, y, type.size, type.size)
end

function Resources:setResource(x, y, id)
    local type = self.types[id]

    if type then
        self:removeIfExists(x, y)
        self:addResource(x, y, id)
    end
end

function Resources:getResource(x, y, id)
    local items, len = self.world:queryPoint(x, y, function(item)
        return item.isResource
    end)

    return items[0]
end

function Resources:removeResource(resource)
    self.world:remove(resource)
end

function Resources:removeIfExists(x, y)
    local resource = self:getResource(x, y)
    if resource then
        self:removeResource(resource)
    end
end

function Resources:getChunk(chunk)
    local resourceChunk = {}

    local resources, len = self.world:queryRect(
        chunk.x, chunk.y, self.chunk.w, self.chunk.h, function(item)
            return item.isResource
        end
    )

    for __, resource in pairs(resources) do
        table.insert(resourceChunk, {id = resource.id, x = resource.x, y = resource.y})
    end

    return resourceChunk
end

function Resources:setResources(resources)
    for id, resource in pairs(resources) do
        self:setResource(resource.x, resource.y, resource.id)
    end
end