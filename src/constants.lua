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

-- bullets
BULLET_WIDTH = 10
BULLET_HEIGHT = 10
BULLET_SPEED = 1000

-- interface
BUTTON_SCALE = 1
BAR_SIZE = 50 * BUTTON_SCALE
BUTTON_SIZE = 40 * BUTTON_SCALE

DEBUG_MODE = true