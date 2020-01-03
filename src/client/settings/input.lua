function love.keypressed(key, code)
    love.keyboard.keysPressed[key] = true
    Gui:keypress(key, code)
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
    Gui:mousepress(x, y, button)
end

function love.mousereleased(x, y, button)
    love.mouse.buttonsReleased[button] = true
    Gui:mouserelease(x, y, button)
end

function love.wheelmoved(x, y)
    love.mouse.wheelmoved = y
    Gui:mousewheel(x, y, button)
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

local input = {}

function input.clear()
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
    love.mouse.buttonsReleased = {}
    love.mouse.wheelmoved = 0
end

function input.load()
    input.clear()
end

return input