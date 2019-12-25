push = require 'lib/game/love-utils/push'

local graphics = {}

-- DEFAULT CONSTANTS, may be changed by user settings

-- size of our actual window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size we're trying to emulate with push
RESOLUTION_SCALE = 1
VIRTUAL_WIDTH = math.floor(RESOLUTION_SCALE * WINDOW_WIDTH)
VIRTUAL_HEIGHT = math.floor(RESOLUTION_SCALE * WINDOW_HEIGHT)

function graphics.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
end

function graphics.render(state)
    push:apply('start')

    state:render()
    
    push:apply('end')
end

return graphics