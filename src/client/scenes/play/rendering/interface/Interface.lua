require 'src/client/scenes/play/rendering/interface/Toolbar'
require 'src/client/scenes/play/rendering/interface/Stats'
require 'src/client/scenes/play/rendering/interface/Cursor'
require 'src/client/scenes/play/rendering/interface/Healthbar'

Interface = Class{}

function Interface:init()
    self.gui = Gui()
    self.gui.style.unit = math.max(40, love.graphics.getWidth() / 25)

    self.stats = Stats(self.gui)
    self.healthbar = Healthbar(self.gui, {health = 100, resources = 0})

    self.abilities = AbilityRendering()
    self.toolbar = Toolbar(self.gui, self.abilities.icons)
    self.cursor = Cursor(self.abilities.cursors)
end

function Interface:toggle()
    for __, element in pairs(self.gui.elements) do
        element.display = not element.display
    end
end

function Interface:render()
    self.healthbar:update()
    self.stats:update()
    self.gui:draw()
    self.cursor:render()
end