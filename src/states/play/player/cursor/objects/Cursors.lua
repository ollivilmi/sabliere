require 'src/states/play/player/cursor/CircleCursor'
require 'src/states/play/player/cursor/SquareCursor'
require 'src/states/play/player/cursor/RectangleCursor'

gCursors = {
    tile = SquareCursor(TILE_SIZE),
    rectangle = RectangleCursor(),
    circle = CircleCursor(TILE_SIZE, 2)
}