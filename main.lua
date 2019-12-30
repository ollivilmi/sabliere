require 'lib/language/language-extensions'
require 'src/network/Client'
require 'src/network/Host'
require 'src/client/Game'

local settings = require 'src/client/settings/Settings'
local lovebird = require 'lib/game/love-utils/debug/lovebird'

local game = Game(Client{
    address = '127.0.0.1',
    port = 12345,
    tickrate = 0.05
})

function love.load()
    love.filesystem.setIdentity('sabliere')
    love.window.setTitle('Sabliere')

    math.randomseed(os.time())

    game.state:changeState('loading', game.client:connect())
end

function love.resize(w,h)
    push:resize(w,h)
end

function love.update(dt)
    if love.keyboard.wasPressed('escape') then
        game.client:disconnect()
        love.event.quit()
    end

    lovebird.update()

    game:update(dt)
end

function log(message)
    if DEBUG_MODE then
        print(message)
    end
end

function love.draw()
    game:render()
end