require 'lib/interface/cursor/CircleCursor'
require 'lib/interface/cursor/SquareCursor'
require 'lib/interface/cursor/RectangleCursor'

gCursors = {
    tile = SquareCursor({ length = TILE_SIZE }),
    rectangle = RectangleCursor({}),
    circle = CircleCursor({ radius = TILE_SIZE, increment = 2})
}