require 'src/client/language-extensions'
require 'src/network/Client'

local settings = require 'src/client/settings/Settings'

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
end

function love.resize(w,h)
    push:resize(w,h)
end

function love.update(dt)
    if DEBUG_MODE then
        lovebird.update()
    end

    -- client:update(dt) 
    -- gStateMachine:update(dt)
    -- settings.core.input.clear()
end

function log(message)
    if DEBUG_MODE then
        print(message)
    end
end

function love.draw()
    -- settings.core.graphics.render(gStateMachine)
end
