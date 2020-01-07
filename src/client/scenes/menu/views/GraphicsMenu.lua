GraphicsMenu = {}

local graphics = require 'src/client/scenes/menu/settings/Graphics'

function GraphicsMenu:init(menuScene)
    self.gui = menuScene.gui
    self.font = menuScene.font
    self.headerFont = love.graphics.newFont('src/client/assets/fonts/Provicali.otf', 40)

    -- todo depends on amount of buttons...
    self.w = love.graphics.getWidth() * 0.8
    self.x = love.graphics.getWidth() * 0.1
    self.h = love.graphics.getHeight() * 0.9
    self.unit = love.graphics.getWidth() / 40
    self.y = 0

    self.group = self.gui:scrollgroup(nil, {self.x, 25, self.w, self.h}, group)

    self.group.style.unit = self.unit
    self.group.style.fg = {0,0,0}
    self.group.style.bg = {0,0,0,0.1}

    local title = self.gui:text('GRAPHICS', {
            x = CenterText(self.w, menuScene.titleFont, 'GRAPHICS'),
            y = self.y,
            w = 500,
            h = 100,
        }, 
        self.group
    )
    -- Some space after main header
    self.y = self.y + 50

    title.style.fg = {0,0,0}
    title.style.font = menuScene.titleFont

    self.group.scrollv.style.hs = "auto"

    -- Remove horizontal scroll bar- we don't need that
    self.gui:rem(self.group.scrollh)

    self.graphics = graphics:load()

    self.options = {
        width = {
            1280,
            1920
        },
        height = {
            720,
            1080
        }
    }

    self:hotkeyButtons(nil, self.graphics)

    self.group:hide()

    self.group.onExit = function(this)
        graphics:save(self.graphics)
    end

    return self.group
end

function GraphicsMenu:hotkeyButtons(name, key, category)
    -- if group (category) of keys
    if type(key) == 'table' then
        if name then
            self:header(name)
        end
        for n, k  in pairs(key) do
            self:hotkeyButtons(n, k, name)
        end
    else
        self.y = self.y + self.unit
        self:optionLabel(name)

        if type(key) == 'boolean' then
            self:checkbox(category, name)
        else
            self:select(category, name)
            self.y = self.y + self.unit
        end

        self.y = self.y + self.unit
    end
end

function GraphicsMenu:header(name)
    -- Some extra space before header
    self.y = self.y + self.unit * 2

    local header = self.gui:text(name, {
            x = CenterText(self.w, self.headerFont, name),
            y = self.y,
            w = 400,
            h = self.unit
        }, self.group
    )
    header.style.font = self.headerFont
    header.style.bg = {0, 0, 0, 0.05}

    -- Some extra space after header
    self.y = self.y + self.unit * 2
end

function GraphicsMenu:optionLabel(name)
    self.gui:text(name, {self.w * 0.15, self.y, 400, self.unit}, self.group)
end

function GraphicsMenu:select(category, name)    
    local options = self.options[name]

    local select = self.gui:group(nil, {self.w * 0.7, self.y, self.unit * 4, self.unit * #options}, self.group)
    
    select.style.fg = {1,1,1}
    select.style.default = {0.2,0.2,0.2}
    select.style.hilite = {0,0,0}
    select.style.focus = {0,0,0}

    for i, option in pairs(options) do
        local button = self.gui:option(option, {0, self.unit * (i-1), self.unit * 4, self.unit}, select, options[i])
        button.click = function(this)
            select.value = this.value
            self.graphics[category][name] = this.value
        end
    end

    select.value = self.graphics[category][name]
end

function GraphicsMenu:checkbox(category, name)
    local checkbox = self.gui:checkbox(nil, {self.w * 0.7, self.y, self.unit, self.unit}, self.group)
    
    checkbox.value = self.graphics[category][name]

    checkbox.click = function(this)
        self.gui[this.elementtype].click(this)
        self.graphics[category][name] = this.value
    end

    checkbox.style.fg = {1,1,1}
end