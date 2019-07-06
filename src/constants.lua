-- size of our actual window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size we're trying to emulate with push
RESOLUTION_SCALE = 0.75
VIRTUAL_WIDTH = math.floor(RESOLUTION_SCALE * WINDOW_WIDTH)
VIRTUAL_HEIGHT = math.floor(RESOLUTION_SCALE * WINDOW_HEIGHT)

MAP_WIDTH = 1920
MAP_HEIGHT = 1020

GRAVITY = 8

-- minimum size
TILE_SIZE = 10
SNAP = TILE_SIZE

TILE_TYPE = {
    empty = 0,
    static = 1,
    dynamic = 2
}

DEBUG_MODE = true