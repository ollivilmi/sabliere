require 'src/client/states/play/rendering/interface/Toolbar'

Interface = Class{}

function Interface:init(gameState)
    self.gui = Gui()
    self.gui.style.fg = {1,1,1}
    self.gui.style.default = {0.15, 0.15, 0.15}
    self.gui.style.hilite = {0.3, 0.3, 0.3}
    self.gui.style.unit = love.graphics.getWidth() / 25

    local center = {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
    }

    self.toolbar = Toolbar(self.gui, center.x, love.graphics.getHeight() - self.gui.style.unit, 10)
    
    self.components = {
        ping = {
            render = function()
                local ping = math.floor(10 * gameState.connectionStatus.ping) / 10
                love.graphics.print(ping, 10, 10)
            end
        },
    }

    self.active = true
end

function Interface:toggle()
    self.active = not self.active
end

function Interface:render()
    if self.active then
        for __, component in pairs(self.components) do
            component:render()
        end

        self.gui:draw()
    end
end