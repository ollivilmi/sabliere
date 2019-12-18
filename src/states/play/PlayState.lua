require 'lib/game/state/State'

require 'src/states/play/level/Level'
require 'src/states/play/level/Camera'
require 'src/states/play/interface/Interface'

-- ground is created here for now, need some class to initialize ground that
-- cannot be destroyed in the future
require 'lib/game/physics/BoxCollider'

Timer = require 'lib/game/love-utils/knife/timer'

PlayState = Class{__includes = State}

function PlayState:enter(params)
    gLevel = Level(self)
    gTilemap:addRectangle(BoxCollider(0, MAP_HEIGHT-TILE_SIZE*8, MAP_WIDTH, TILE_SIZE*8))

    gInterface = Interface(self)
end

function PlayState:update(dt)
    Timer.update(dt)
    gLevel:update(dt)
    gInterface:update(dt)
end

function PlayState:render()
    gLevel:render()
    gInterface:render()
end