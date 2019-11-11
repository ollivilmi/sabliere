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