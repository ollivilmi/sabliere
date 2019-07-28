require 'lib/interface/cursor/CircleCursor'
require 'lib/interface/cursor/SquareCursor'
require 'lib/interface/cursor/RectangleCursor'

gCursors = {
    tile = SquareCursor(TILE_SIZE),
    rectangle = RectangleCursor(),
    circle = CircleCursor(TILE_SIZE, 2)
}