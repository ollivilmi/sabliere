require 'src/client/scenes/play/rendering/interface/Toolbar'

Stats = Class{}

function Stats:init(gui, group)
    self.gui = gui
    
    self.group = group or self.gui:group(nil,
        {
            x = 10,
            y = 10,
            w = 50,
            h = 50
        }
    )

    self.stats = {}

    self:setStyle()
end

function Stats:add(name, object)
    table.insert(self.stats, {name = name, object = object})
    local y = table.getn(self.stats) * self.group.style.unit

    self.gui:text(name, {5, y, 50, self.group.style.unit}, self.group)
end

function Stats:setStyle()
    self.group.style.fg = {0,0,0}
    self.group.style.bg = {1,1,1,0}
    self.group.style.unit = 10
end

function Stats:update()
    for i, stat in pairs(self.group.children) do
        local s = self.stats[i]
        stat.label = string.format("%s %s", s.name, math.floor(10 * s.object[s.name]) / 10)
    end
end