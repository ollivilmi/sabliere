ResourceRendering = Class{}

local RESOURCE_TEXTURE_SIZE = 10

function ResourceRendering:init(resources)
    self.resources = resources.resources

    self.textures = {
        s = love.graphics.newImage('src/client/assets/textures/tile/sand.png'),
    }
end

function ResourceRendering:render(chunk)
    love.graphics.setColor(0,0,0)
    
    local resources = self.resources:getTiles(chunk)

    for __, resource in pairs(resources) do
        love.graphics.draw(self.textures[resource.id], resource.x, resource.y)
    end
end