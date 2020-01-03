require 'lib/game/State'

LoadingState = Class{__includes = State}

function LoadingState:init(game)
    self.game = game
    self.font = love.graphics.newFont('src/client/assets/fonts/font.ttf', 24)
    self.gui = Gui()

    self.gui:button('Menu', {0, 0, 100, 25})

    self.gui.style.fg = {1,1,1}
    self.gui.style.default = {0.15, 0.15, 0.15}
    self.gui.style.hilite = {0.1, 0.1, 0.1}
end

function LoadingState:enter(loadingCoroutine)
    self.t = 0
    self.timePassed = 0
    self.timeOut = 100
    self.retryInterval = 0.5
    self.loadingCoroutine = loadingCoroutine

    Gui = self.gui
end

function LoadingState:update(dt)
    if self.t > self.timeOut then
        love.event.quit()
    end

    self.t = self.t + dt
    self.timePassed = self.timePassed + dt

    if self.t > self.retryInterval then
        self.t = self.t - self.retryInterval
        coroutine.resume(self.loadingCoroutine)

        if coroutine.status(self.loadingCoroutine) == 'dead' then
            self.game.state:changeState('play')
        end
    end
end

function LoadingState:render()
    self.gui:draw()

    local loadingString = 'LOADING... ' .. math.floor(self.timePassed)
    love.graphics.setFont(self.font)
    
    love.graphics.print(
        loadingString,
        love.graphics.getWidth() / 2 - (self.font:getWidth(loadingString) / 2),
        love.graphics.getHeight() / 2
    )
end