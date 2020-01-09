HotkeyMenu = {}

local hotkeys = require 'src/client/scenes/menu/settings/Hotkeys'

function HotkeyMenu:init(menuScene)
    self.gui = menuScene.gui
    self.font = menuScene.font
    self.headerFont = love.graphics.newFont('src/client/assets/fonts/Provicali.otf', 40)

    -- todo depends on amount of buttons...
    self.w = love.graphics.getWidth() * 0.8
    self.x = love.graphics.getWidth() * 0.1
    self.h = love.graphics.getHeight() * 0.9
    self.unit = love.graphics.getWidth() / 30
    self.y = 0

    self.group = self.gui:scrollgroup(nil, {self.x, 25, self.w, self.h}, group)
    self.group.style.fg = {0,0,0}
    self.group.style.bg = {0,0,0,0.1}

    local title = self.gui:text('HOTKEYS', {
            x = CenterText(self.w, menuScene.titleFont, 'HOTKEYS'),
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

    self.hotkeys = hotkeys:load()

    self:hotkeyButtons(nil, self.hotkeys)

    self.group:hide()

    self.group.onExit = function(this)
        hotkeys:save(self.hotkeys)
    end

    return self.group
end

function HotkeyMenu:hotkeyButtons(name, key, category)
    -- if group (category) of keys
    if type(key) == 'table' then
        if name then
            -- Some extra space before header
            self.y = self.y + 50

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
            self.y = self.y + 50
        end

        for n, k  in pairs(key) do
            self:hotkeyButtons(n, k, name)
        end
    else
        self.y = self.y + self.unit + 1

        self.gui:text(name, {self.w * 0.15, self.y, 400, self.unit}, self.group)
        local button = self.gui:button(key, {self.w * 0.7, self.y, 200, self.unit}, self.group)
        button.click = function()
            button:focus()
        end
        button.keypress = function(this, key)
            button.label = key
            self.hotkeys[category][name] = key
            self.gui:unfocus()
        end
        button.style.fg = {1,1,1}
    end
end