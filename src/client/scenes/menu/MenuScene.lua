require 'lib/game/State'
require 'src/client/scenes/menu/views/MainMenu'
require 'src/client/scenes/menu/views/SettingsMenu'
require 'src/client/scenes/menu/views/HotkeyMenu'
require 'src/client/scenes/menu/views/GraphicsMenu'

MenuScene = Class{__includes = State}

function MenuScene:init()
    self.titleFont = love.graphics.newFont('src/client/assets/fonts/Provicali.otf', 62)
    self.font = love.graphics.newFont('src/client/assets/fonts/Provicali.otf', 28)
    self.background = love.graphics.newImage('src/client/assets/textures/background/mountain.png')
    
    self.gui = Gui()

    self.gui.style.fg = {1,1,1}
    self.gui.style.bg = {0,0,0,0}
    self.gui.style.hilite = {0.1, 0.1, 0.1}
    self.gui.style.focus = {0, 0, 0}
    self.gui.style.font = self.font

    self.views = {
        main = MainMenu:init(self),
        settings = SettingsMenu:init(self),
        hotkeys = HotkeyMenu:init(self),
        graphics = GraphicsMenu:init(self),
    }

    self.navStack = Dequeue()
end

function MenuScene:enter(params)
    Gui = self.gui

    self:navigate('main')

    if params and params.msg then
        local feedback = self.gui:feedback(params.msg, {20, 20})
        feedback.style.fg = {0,0,0}
    end
end

function MenuScene:exit()
    self.navStack = Dequeue()
end

function MenuScene:navigate(view)
    if not self.navStack:isEmpty() then
        self.navStack:peek():hide()
    end

    self.navStack:pushFirst(self.views[view])
    self.navStack:peek():show()
end

function MenuScene:pop()
    local previousMenu = self.navStack:peek()

    previousMenu:hide()
    previousMenu:onExit()

    self.navStack:pop()

    if self.navStack:isEmpty() then
        love.event.quit()
    else
        self.navStack:peek():show()
    end
end

function MenuScene:update(dt)
    if love.keyboard.wasPressed('escape') then
        self:pop()
    end
end

function MenuScene:render()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.background, -200, -200)

    self.gui:draw()
end

function CenterText(width, font, text)
    return width / 2 - (font:getWidth(text) / 2)
end