require 'src/clients/states/State'

require 'src/client/states/play/Camera'
require 'src/client/states/play/interface/Interface'

-- ground is created here for now, need some class to initialize ground that
-- cannot be destroyed in the future
require 'src/network/state/physics/BoxCollider'

Timer = require 'lib/game/love-utils/knife/timer'

PlayState = Class{__includes = State}

function PlayState:enter(params)
    --client.state.index.level?

    -- gPlayer = Player(client.state.playerCoords)
    -- gCamera = Camera(1, gPlayer, 150)
    gInterface = Interface(self)
end

function PlayState:update(dt)
    Timer.update(dt)
    gInterface:update(dt)
end

function PlayState:render()
    gInterface:render()
end