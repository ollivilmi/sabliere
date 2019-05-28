PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
end

function PlayState:update(dt)
end

function PlayState:render()
    local backgroundWidth = gTextures.background:getWidth()
    local backgroundHeight = gTextures.background:getHeight()

    love.graphics.draw(gTextures.background, 
        0, 0, 
        0,
        -- scale factors on X and Y axis so it fills the screen
        VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))
    

    love.graphics.setFont(gFonts['small'])
    love.graphics.print('Hello, world', VIRTUAL_WIDTH - 60, 5)
end