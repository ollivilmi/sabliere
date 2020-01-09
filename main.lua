require 'lib/language/language-extensions'
require 'src/network/Client'
require 'src/network/Host'
require 'src/client/GameClient'

Gui = require 'lib/game/love-utils/interface/Gspot'
local lovebird = require 'lib/game/love-utils/debug/lovebird'
local graphics = require 'src/client/scenes/menu/settings/Graphics'

function love.load()
    love.filesystem.setIdentity('sabliere')
    love.window.setTitle('Sabliere')
    -- Load resolution, fullscreen from settings file
    local graphics = graphics:load()
    love.window.setMode(graphics.resolution.width, graphics.resolution.height, {
            fullscreen = graphics.resolution.fullscreen,
            vsync = graphics.resolution.vsync,
        }
    )

    Game = GameClient(Client{
        address = '127.0.0.1',
        port = 12345,
        tickrate = 0.05
    })

    math.randomseed(os.time())

    Game:load()
end

function love.update(dt)
    lovebird.update()
    Timer.update(dt)
    Gui:update(dt)

    Game:update(dt)
end

function log(message)
    if DEBUG_MODE then
        print(message)
    end
end

function love.draw()
    Game:render()
end