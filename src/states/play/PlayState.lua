require 'src/states/play/Player'

PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.player = Player(gTextures.player, 0.1)
end

function PlayState:update(dt)
    self.player:update(dt)
end

function PlayState:render()
    local backgroundWidth = gTextures.background:getWidth()
    local backgroundHeight = gTextures.background:getHeight()

    love.graphics.draw(gTextures.background, 
        0, 0, 
        0,
        -- scale factors on X and Y axis so it fills the screen
        VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))
    
    self.player:render()

    love.graphics.setFont(gFonts['small'])
    love.graphics.print('Hello, world', VIRTUAL_WIDTH - 60, 5)
end