require 'src/client/dependencies'

local settings = require 'src/client/settings/Settings'
-- for now
gWorld = {}

function love.load()
    love.filesystem.setIdentity('sabliere')
    settings:loadAll()

    math.randomseed(os.time())
    -- Game states: menu, play...
    initStateMachine()

    love.window.setTitle('Sabliere')

    client = Client{
        address = '127.0.0.1',
        port = 12345,
        updaterate = 0.05,
        requests = require 'src/network/client/Requests'
    }
end

function love.resize(w,h)
    push:resize(w,h)
end

function love.update(dt)
    if DEBUG_MODE then
        lovebird.update()
    end

    client:update(dt) 
    gStateMachine:update(dt)
    settings.core.input.clear()
end

function log(message)
    if DEBUG_MODE then
        print(message)
    end
end

function love.draw()
    settings.core.graphics.render(gStateMachine)
end
