luaunit = require 'src/test/luaunit'
Class = require 'lib/language/class'

require 'src/network/state/Level'
require 'src/network/state/tilemap/Tilemap'
require 'src/network/Data'

local bump = require '/lib/game/physics/bump'

function testAddRectangle()
    local level = Level(bump.newWorld(80))
    local tilemap = level.tilemap

    -- only add first tile as rectangle
    tilemap:addRectangle({x=0,y=0,w=tilemap.tileSize,h=tilemap.tileSize})

    -- only first tile should be filled
    assert(tilemap:getTile(0,0))

    for x = 0, tilemap.tileSize * 10, tilemap.tileSize do
        for y = 0, tilemap.tileSize * 10, tilemap.tileSize do
            if y ~= 0 and x ~= 0 then
                assert(not tilemap:getTile(x,y), "unexpected tile at " .. x .. "," .. y)
            end
        end
    end
end

function testChunking()
    local level = Level(bump.newWorld(80))
    local tilemap = level.tilemap

    tilemap:addRectangle({x=0,y=0,w= tilemap.tileSize * 200,h= tilemap.tileSize * 100})
    local items, len = tilemap.world:queryRect(0, 0, 200 * tilemap.tileSize, tilemap.tileSize * 100)
    assert(len == 20000, 'There should only be 20k tiles after adding 200x100, was ' .. len)

    local chunk = tilemap:getChunk({x = 0, y = 0})

    local level2 = Level(bump.newWorld(80))
    local tilemap2 = level2.tilemap

    tilemap2:setChunk(chunk)
    local tilesX = tilemap.chunk.w / tilemap.tileSize
    local tilesY = tilemap.chunk.h / tilemap.tileSize

    local expectedCount = tilesX * tilesY

    local items, len = tilemap2.world:queryRect(0, 0, tilemap2.chunk.w, tilemap2.chunk.h)
    assert(len == expectedCount, 'Expected ' .. expectedCount .. " tiles, was " .. len)

    -- verify things are in place
    assert(tilemap:getTile(0,0), 'Tilemap should have first tile after loading chunk')
    assert(tilemap:getTile(99 * tilemap2.tileSize, 99 *tilemap2.tileSize), 'Tilemap should have last tile after loading chunk')
    assert(not tilemap:getTile(100 * tilemap2.tileSize, 100 *tilemap2.tileSize), 'Tilemap should not have tile 100,100 - only from 0,0 to 99,99')
end

function testMessageSize()
    local level = Level(bump.newWorld(80))
    local tilemap = level.tilemap

    for x = 0, tilemap.chunk.w, tilemap.tileSize do
        for y = 0, tilemap.chunk.h, tilemap.tileSize do
            tilemap:setTile(x, y, 'r')
        end
    end

    local chunk = tilemap:getChunk({x = 0, y = 0})

    local data = Data({request = 'tileSnapshot'}, chunk)

    local dataLength = data:encode():len()
    assert(dataLength < 8000, 'LuaSocket has 8.1k byte limitation for msg payload')
end

os.exit( luaunit.LuaUnit.run() )
