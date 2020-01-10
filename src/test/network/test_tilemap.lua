luaunit = require 'src/test/luaunit'
Class = require 'lib/language/class'

require 'src/network/state/tilemap/Tilemap'
local bump = require '/lib/game/physics/bump'

function testCreate()
    local tilemap = Tilemap(10, 10, bump.newWorld(80))

    assert(tilemap.width == 10)
    assert(tilemap.height == 10)
    assert(tilemap.tileSize == 20)

    -- height
    assert(table.getn(tilemap.tiles) == 10)
    -- width
    assert(table.getn(tilemap.tiles[1]) == 10)
    -- only 1 element: tile or empty table
    assert(table.getn(tilemap.tiles[1][1]) == 1)

    -- first tile should be empty table
    assert(tilemap.tiles[1][1].type == nil)
    -- last tile should be empty table
    assert(tilemap.tiles[10][10].type == nil)
end

function testAddRectangle()
    local tilemap = Tilemap(10, 10, bump.newWorld(80))

    -- only add first tile as rectangle
    tilemap:addRectangle({x=0,y=0,w=20,h=20})

    -- only first tile should be filled
    assert(tilemap:hasTile(1,1))

    for y = 1, 10 do
        for x = 1, 10 do
            if y ~= 1 and x ~= 1 then
                assert(not tilemap:hasTile(y,x), "unexpected tile at " .. x .. "," .. y)
            end
        end
    end
end

os.exit( luaunit.LuaUnit.run() )
