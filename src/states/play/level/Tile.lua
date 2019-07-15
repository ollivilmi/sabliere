Tile = Class{__includes = Collision}

-- Tiles are squares with min length TILE_SIZE
-- tiles size increases in binary increments (TILE_SIZE * 2^n) to ensure
-- that they can be divided into 4 segments
function Tile:init(x, y, length, image)
    self.x, self.y, length = tilemath.snap(x, y, length)
    self.map = {
        x = self.x / TILE_SIZE + 1, -- addition because tables are 1 indexed
        y = self.y / TILE_SIZE + 1,
        size = (length / TILE_SIZE) -1 -- subtraction because coords are 0 indexed
    }
    self.width = length
    self.height = length

    self.health = 1
    self.image = image or "sand"
end

function Tile:destroy(area)
    local newTiles = {}
    local width = self.width/2
    local height = self.height/2
    local tiles = {}

    -- break into 4x4 segments by dividing height & width by 2
    if width >= TILE_SIZE then
        for x = self.x, self.x + width, width do
            for y = self.y, self.y + height, height do
                table.insert(tiles, Tile(x, y, width, self.image))
            end
        end

        for k, tile in pairs(tiles) do 
            if area:collides(tile) then
                table.addTable(newTiles, tile:destroy(area))
                tile = nil
            else
                table.insert(newTiles, tile)
            end
        end
    end

    return newTiles 
end

function Tile:equals(tile)
    return self.map.size == tile.map.size
end

function Tile:toString()
    return self.map.x .. "," .. self.map.y .. ";" .. self.map.size
end

function Tile:render()
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end