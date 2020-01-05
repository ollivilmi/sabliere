require 'src/client/scenes/play/rendering/interface/Toolbar'

Interface = Class{}

function Interface:init(gameState)
    self.gui = Gui()
    self.gui.style.unit = math.max(40, love.graphics.getWidth() / 25)

    self.components = {
        ping = {
            render = function()
                local ping = math.floor(10 * gameState.connectionStatus.ping) / 10
                love.graphics.print(ping, 10, 10)
            end
        },
    }

    self.toolbar = Toolbar(self.gui)

    self.active = true
end

function Interface:toggle()
    for __, element in pairs(self.gui.elements) do
        element.display = not element.display
    end
end

function Interface:render()
    for __, component in pairs(self.components) do
        component:render()
    end

    self.gui:draw()
end