require 'src/client/scenes/play/interface/cursor/CircleCursor'
require 'src/client/scenes/play/interface/cursor/SquareCursor'
require 'src/client/scenes/play/interface/cursor/RectangleCursor'

gCursors = {
    tile = SquareCursor({ length = TILE_SIZE }),
    rectangle = RectangleCursor({}),
    circle = CircleCursor({ radius = TILE_SIZE, increment = 2 })
}