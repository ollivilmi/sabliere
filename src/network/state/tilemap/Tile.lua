Tile = Class{}

function Tile:init(type)
    self.h = 1
    self.t = type or "s"
end

function Tile:equals(tile)
    return self.type == tile.type
end