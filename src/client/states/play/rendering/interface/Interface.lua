Interface = Class{}

function Interface:init(gameState)
    self.components = {}

    self.components.ping = {
        render = function()
            love.graphics.print(gameState.connectionStatus.ping, 10, 10)
        end
    }
end

function Interface:update(dt)
end

function Interface:render()
    for __, component in pairs(self.components) do
        component:render()
    end
end