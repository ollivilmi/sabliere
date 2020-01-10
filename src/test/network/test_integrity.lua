luaunit = require 'src/test/luaunit'
Class = require 'lib/language/class'

require "src/test/network/clientHostSetup"
require 'lib/language/Dequeue'
require 'src/network/state/tilemap/Tilemap'

local md5 = require 'lib/language/md5'
local lzw = require 'lib/language/lzw'
local json = require 'lib/language/json'

function testLibraries()
    ok, err = pcall(require, 'bit32')
    assert(ok, err)
    ok, bit = pcall(require, 'socket')
    assert(ok, err)
end

-- benchmark that md5 is fast enough for snapshots
function testMd5()
    local m1 = md5.sumhexa('this is our very important message payload')
    local m2 = md5.sumhexa('this is our very important message payload')
    assert(m1 == m2, "same message, should be equal")

    m2 = md5.sumhexa('this is our very important message payload ')
    assert(m1 ~= m2, "message 2 has an extra space, should not equal")

    local bump = require '/lib/game/physics/bump'
    local tilemap = Tilemap(10, 10, bump.newWorld(20))

    -- Generate a tile chunk that is twice as large as 1920x1080p
    -- quite big, but still should perform very fast

    tilemap:addRectangle({x=0,y=0,w=384,h=216})
    local socket = require 'socket'
    local start = socket.gettime()
    md5.sumhexa(lzw.compress(json.encode(tilemap:getChunk({
        x = 1,
        y = 1,
        width = tilemap.width,
        height = tilemap.height,
    }))))

    -- if it's slower than 0.025 things will be bad
    assert(socket.gettime() - start < 0.025, "generating checksum slow, may cause issues")
end

function testQueue()
    local queue = Dequeue()

    queue:push(1)
    assert(queue:peek() == 1, 'first item in queue should be 1')
    assert(queue:pop() == 1, 'first item in queue should be 1')
    assert(queue:length() == 0, 'queue should be empty after popping the only item')
    
    queue:push(2)
    queue:push(6)
    queue:push(15)
    assert(queue:pop() == 2, 'first item in queue should be 2')
    assert(queue:length() == 2, 'queue should 2 after popping 1 out of 3')

    queue:pushFirst(255)
    assert(queue:pop() == 255, 'first item in queue should be 255 after pushing it to the head')
    queue:push(1337)
    assert(queue:popLast() == 1337, 'last item in queue should be 1337 after pushing it to the tail')
end

function testInvalidRequests()
    local client, host = setupClientAndHost()

    local client = 12345
    local request = 'test'
    local payload = {x = 5, y = 14, width = 100, height = 50}

    local msg = Data({
        client = client, 
        request = request,
        duplex = true
    }, payload)

    -- send valid data, invalid checksum
    local dataString = lzw.compress(msg:toString())
    local expectedMsg = "Checksum does not match"

    local result, errorMsg = pcall(Data.decode, dataString)
    assert(result == false, "Decode should return false when checksum is incorrect")

    -- send valid data
    result = Data.decode(msg:encode())

    assert(result.headers.client == client, 
    "Decoded client should be " .. client .. " not " .. result.headers.client)
    
    assert(result.headers.request == request, 
    "Decoded request should be " .. request .. " not " .. result.headers.request)
    
    assert(json.encode(result.payload) == json.encode(payload), 
    "Decoded payload should be " .. json.encode(payload) .. " not " .. json.encode(result.payload))

    -- send empty payload

    msg = Data({client = client, request = request})
    encodedMsg = msg:encode()

    result = Data.decode(encodedMsg)
    assert(json.encode(result.payload) == "[]", "Empty payload should be empty table, was " .. json.encode(result.payload))
end

os.exit( luaunit.LuaUnit.run() )
