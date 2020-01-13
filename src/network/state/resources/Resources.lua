Resources = Class{}

function Resources:init(level)
    self.resources = {{}}
    self.world = level.world
end

function Resources:add(x, y, type)
    local x, y = math.floor(x), math.floor(y)
    if not self.resources[y] then 
        self.resources[y] = {} 
    end
    self.resources[y][x] = {type = type, x = x, y = y, isResource = true}

    self.world:add(type, x, y, self.size, self.size)
end

function Resources:remove(x, y)
    local resource = self.resources[y][x]

    if resource then
        self.world:remove(resource)
        self.resources[y][x] = nil
    end
end

function Resources:getChunk(entity)
    local x, y = math.rectangleCenter(entity)

    local chunk = {
        x = math.max(0, x - 1920),
        y = math.max(0, y - 1080),
        w = 3840,
        h = 2160,
        resources = {}
    }

    local items, len = self.world:queryRect(
        chunk.x,
        chunk.y,
        chunk.w,
        chunk.h,
        function(item)
            return item.isResource
        end
    )

    for i, item in pairs(items) do
        chunk.resources[i] = item.type
    end

    return chunk
end

function Resources:setChunk(chunk)
    local x, y = math.rectangleCenter(entity)

    local chunk = {
        x = math.max(0, x - 1920),
        y = math.max(0, y - 1080),
        w = 3840,
        h = 2160,
        resources = {}
    }

    local items, len = self.world:queryRect(
        chunk.x,
        chunk.y,
        chunk.w,
        chunk.h,
        function(item)
            return item.isResource
        end
    )

    for i, item in pairs(items) do
        chunk.resources[i] = item.type
    end

    return chunk
end