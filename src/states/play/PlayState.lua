require 'src/states/play/Player'
require 'src/states/play/Brick'

PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.player = Player(gTextures.player, 0.1)
    self.bricks = {}
    table.insert(self.bricks, Brick(0, VIRTUAL_HEIGHT - 30, 40, 100))
end

function PlayState:update(dt)
    self.player:update(dt)


    for k, brick in pairs(self.bricks) do
        if self.player:collides(brick) then
            self.player.grounded = true
        end
    end
end

function PlayState:render()
    local backgroundWidth = gTextures.background:getWidth()
    local backgroundHeight = gTextures.background:getHeight()

    love.graphics.draw(gTextures.background, 
        0, 0, 
        0,
        -- scale factors on X and Y axis so it fills the screen
        VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))
    
    for k, brick in pairs(self.bricks) do
        brick:render()
    end
    self.player:render()

    love.graphics.setFont(gFonts['small'])
    love.graphics.print('Hello, world', VIRTUAL_WIDTH - 60, 5)
end