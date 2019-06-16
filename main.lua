require 'src/dependencies'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())
    initStateMachine()

    love.window.setTitle('2D game test')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
    love.mouse.wheelmoved = 0
end

function love.resize(w,h)
    push:resize(w,h)
end

function love.update(dt)
    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
    love.mouse.wheelmoved = 0
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
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

function love.draw()
    push:apply('start')
    
    gStateMachine:render()
    displayFPS()

    push:apply('end')
end

function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end