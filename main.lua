require 'src/dependencies'
local socket = require "socket"
 
local address, port = "127.0.0.1", 12345
 
local entity
local updaterate = 0.1
 
local world = {}
local t

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.filesystem.setIdentity('sabliere')
    settings.loadAll()

    math.randomseed(os.time())
    initStateMachine()

    love.window.setTitle('Sabliere')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
    love.mouse.buttonsReleased = {}
    love.mouse.wheelmoved = 0

    -- connection settings
    udp = socket.udp()
    udp:settimeout(0)

    udp:setpeername(address, port)
    
    entity = tostring(math.random(99999))

    local datagram = string.format("%s %s %d %d", entity, 'at', 320, 240)
    local work, msg = udp:send(datagram)
    print(work)

    t = 0
end

function love.resize(w,h)
    push:resize(w,h)
end

function love.update(dt)
    t = t + dt -- increase t by the deltatime
 
	if t > updaterate then
		local x, y = 0, 0
		if love.keyboard.isDown('up') then      y=y-(20*t) end
		if love.keyboard.isDown('down') then 	y=y+(20*t) end
		if love.keyboard.isDown('left') then 	x=x-(20*t) end
		if love.keyboard.isDown('right') then 	x=x+(20*t) end
    
        local dg = string.format("%s %s %f %f", entity, 'move', x, y)
        udp:send(dg)

        local dg = string.format("%s %s $", entity, 'update')
        udp:send(dg)
        
        t=t-updaterate -- set t for the next round
	end

    repeat
        data, msg = udp:receive()
 
        if data then -- you remember, right? that all values in lua evaluate as true, save nil and false?
            
            ent, cmd, parms = data:match("^(%S*) (%S*) (.*)")
			if cmd == 'at' then
				local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
                assert(x and y)
				x, y = tonumber(x), tonumber(y)
				world[ent] = {x=x, y=y}
			else
				-- print("unrecognised command:", cmd)
            end
        elseif msg ~= 'timeout' then 
			error("Network error: "..tostring(msg))
		end
	until not data
            
    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
    love.mouse.buttonsReleased = {}
    love.mouse.wheelmoved = 0
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.mousereleased(x, y, button)
    love.mouse.buttonsReleased[button] = true
end

function love.wheelmoved(x, y)
    love.mouse.wheelmoved = y
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.mouse.wasReleased(button)
    return love.mouse.buttonsReleased[button]
end

function log(message)
    if DEBUG_MODE then
        print(message)
    end
end

function love.draw()
    push:apply('start')
    gStateMachine:render()

    	-- pretty simple, we 
	for k, v in pairs(world) do
		love.graphics.print(k, v.x, v.y)
	end
    push:apply('end')
end
