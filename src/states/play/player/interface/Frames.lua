Frames = Class{}

function Frames:render()
    if DEBUG_MODE then
        love.graphics.setFont(gFonts['medium'])
        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), gCamera.x + 5, gCamera.y + 5)
    end
end