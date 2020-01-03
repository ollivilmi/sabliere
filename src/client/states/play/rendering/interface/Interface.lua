Interface = Class{}

function Interface:init(gameState)
    self.components = {}

    self.components.ping = {
        render = function()
            love.graphics.print(gameState.connectionStatus.ping, 10, 10)
        end
    }

    self.active = true
end

function Interface:update(dt)
end

function Interface:toggle()
    self.active = not self.active
end

function Interface:render()
    if self.active then
        for __, component in pairs(self.components) do
            component:render()
        end
    end
end