require 'lib/game/State'

MenuScene = Class{__includes = State}

function MenuScene:init(game)
    self.game = game

    self.titleFont = love.graphics.newFont('src/client/assets/fonts/Provicali.otf', 62)
    self.buttonFont = love.graphics.newFont('src/client/assets/fonts/Provicali.otf', 28)

    self.background = love.graphics.newImage('src/client/assets/textures/background/mountain.png')
    
    self.gui = Gui()

    self.title = self.gui:text('SABLIERE', {
        x = love.graphics.getWidth() / 2 - (self.titleFont:getWidth('SABLIERE') / 2),
        y = 50,
        w = 500,
        h = 100,
    })
    self.title.style.fg = {0,0,0}
    self.title.style.font = self.titleFont

    self.connectButton = self.gui:button('Connect', {
            x = (love.graphics.getWidth() / 2) - 150, 
            y = (love.graphics.getHeight() / 2) + 40, 
            w = 300, 
            h = 50
        }
    )

    self.hostButton = self.gui:button('Host', {
            x = (love.graphics.getWidth() / 2) - 150, 
            y = (love.graphics.getHeight() / 2) + 140, 
            w = 300, 
            h = 50
        }
    )
    
    self.settingsButton = self.gui:button('Settings', {
            x = (love.graphics.getWidth() / 2) - 150, 
            y = (love.graphics.getHeight() / 2) + 240, 
            w = 300, 
            h = 50
        }
    )

    self.connectButton.click = function(this)
        game.scene:changeState('loading', game.client:connect())
    end

    self.gui.style.fg = {1,1,1}
    self.gui.style.default = {0.15, 0.15, 0.15}
    self.gui.style.hilite = {0.1, 0.1, 0.1}
    self.gui.style.font = self.buttonFont
end

function MenuScene:enter(params)
    Gui = self.gui

    if params and params.msg then
        local feedback = self.gui:feedback(params.msg, {20, 20})
        feedback.style.fg = {0,0,0}
    end
end

function MenuScene:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function MenuScene:render()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.background, -200, -200)

    self.gui:draw()

    love.graphics.setColor(0,0,0)
    love.graphics.setFont(self.titleFont)
end