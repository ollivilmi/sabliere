require 'src/client/scenes/play/rendering/interface/Toolbar'
require 'src/client/scenes/play/rendering/interface/Stats'

Interface = Class{}

function Interface:init(game)
    self.gui = Gui()
    self.gui.style.unit = math.max(40, love.graphics.getWidth() / 25)

    self.ping = self.gui:text('ping', {x = 5, y = 5, w = 128, h = 128})
    self.ping.style.fg = {0,0,0}

    self.stats = Stats(self.gui)
    self.toolbar = Toolbar(self.gui)

    self.active = true
end

function Interface:toggle()
    for __, element in pairs(self.gui.elements) do
        element.display = not element.display
    end
end

function Interface:render()
    self.stats:update()

    self.gui:draw()
end