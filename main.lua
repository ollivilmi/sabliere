require 'src/client/language-extensions'
require 'src/network/Client'

local settings = require 'src/client/settings/Settings'
local game = require 'src/client/Game'

local lovebird = require 'lib/game/love-utils/debug/lovebird'

function love.load()
    love.filesystem.setIdentity('sabliere')
    settings:loadAll()

    math.randomseed(os.time())

    love.window.setTitle('Sabliere')

    client = Client{
        address = '127.0.0.1',
        port = 12345,
        tickrate = 0.05
    }

    game:changeState('play', client)
end

function love.resize(w,h)
    push:resize(w,h)
end

function love.update(dt)
    if love.keyboard.wasPressed('escape') then
        client:disconnect()
        love.event.quit()
    end

    lovebird.update()

    client:update(dt)
    game:update(dt)

    settings.core.input.clear()
end

function log(message)
    if DEBUG_MODE then
        print(message)
    end
end

function love.draw()
    settings.core.graphics.render(game)
end