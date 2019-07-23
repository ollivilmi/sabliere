require 'src/states/play/player/interface/cursor/CircleCursor'
require 'src/states/play/player/interface/cursor/SquareCursor'
require 'src/states/play/player/interface/cursor/RectangleCursor'

gCursors = {
    tile = SquareCursor(TILE_SIZE),
    rectangle = RectangleCursor(),
    circle = CircleCursor(TILE_SIZE, 2)
}