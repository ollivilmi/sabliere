require 'lib/game/State'

LoadingScene = Class{__includes = State}

function LoadingScene:init(game)
    self.game = game
    self.font = love.graphics.newFont('src/client/assets/fonts/Provicali.otf', 24)
    self.gui = Gui()

    self.gui.style.fg = {1,1,1}
    self.gui.style.default = {0.15, 0.15, 0.15}
    self.gui.style.hilite = {0.1, 0.1, 0.1}
end

function LoadingScene:enter(loadingCoroutine)
    self.t = 0
    self.timePassed = 0
    self.timeOut = 15
    self.retryInterval = 0.5
    self.loadingCoroutine = loadingCoroutine

    Gui = self.gui
end

function LoadingScene:update(dt)
    if love.keyboard.wasPressed('escape') then
        self.game.client:setDisconnected()
        self.game.scene:changeState('menu')
    end


    if self.timePassed > self.timeOut then
        self.game.scene:changeState('menu', {msg = "Connection timed out"})
    end

    self.t = self.t + dt
    self.timePassed = self.timePassed + dt

    if self.t > self.retryInterval then
        self.t = self.t - self.retryInterval
        coroutine.resume(self.loadingCoroutine)

        if coroutine.status(self.loadingCoroutine) == 'dead' then
            self.game.scene:changeState('play')
        end
    end
end

function LoadingScene:render()
    self.gui:draw()

    local loadingString = 'LOADING... ' .. math.floor(self.timePassed)
    love.graphics.setFont(self.font)
    
    love.graphics.print(
        loadingString,
        love.graphics.getWidth() / 2 - (self.font:getWidth(loadingString) / 2),
        love.graphics.getHeight() / 2
    )
end