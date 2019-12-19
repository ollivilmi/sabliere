luaunit = require 'src/test/luaunit'
Class = require 'lib/language/class'

require 'src/network/state/tilemap/Tilemap'
require 'src/network/state/physics/BoxCollider'

function testCreate()
    local tilemap = Tilemap(10, 10, 10)

    assert(tilemap.width == 10)
    assert(tilemap.height == 10)
    assert(tilemap.tileSize == 10)

    -- height
    assert(table.getn(tilemap.tiles) == 10)
    -- width
    assert(table.getn(tilemap.tiles[1]) == 10)
    -- only 1 element: tile or empty table
    assert(table.getn(tilemap.tiles[1][1]) == 1)

    -- first tile should be empty table
    assert(tilemap.tiles[1][1].t == nil)
    -- last tile should be empty table
    assert(tilemap.tiles[10][10].t == nil)
end

function testAddRectangle()
    local tilemap = Tilemap(10, 10, 10)

    -- only add first tile as rectangle
    tilemap:addRectangle(BoxCollider(0, 0, 10, 10))

    -- only first tile should be filled
    assert(tilemap.tiles[1][1].t ~= nil)

    for y = 1, 10 do
        for x = 1, 10 do
            if y ~= 1 and x ~= 1 then
                assert(tilemap.tiles[y][x].t == nil, "unexpected tile at " .. x .. "," .. y)
            end
        end
    end
end

os.exit( luaunit.LuaUnit.run() )
