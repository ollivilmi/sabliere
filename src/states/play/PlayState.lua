require 'src/states/play/Player'
require 'src/states/play/Brick'
require 'src/states/play/Cursor'

PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.player = Player(gTextures.player, 0.1)
    self.bricks = {}

    self.cursor = Cursor(10)

    -- test brick
    table.insert(self.bricks, Brick(100, VIRTUAL_HEIGHT - 30, 100, 100))

    -- ground
    for k, brick in pairs(Brick:rectangle(0, VIRTUAL_HEIGHT-10, 700, 30)) do
        table.insert(self.bricks, brick)
    end

end

function PlayState:update(dt)

    self.player.grounded = false

    for k, brick in pairs(self.bricks) do
        if self.player:collides(brick) then
            self.player.grounded = true
            self.player:applyCollision(brick)
        end
        
        if brick:collidesPoint(self.cursor) then
            brick.color = {1, 0, 0, 1}
        end
    end

    -- TODO: mouse click checks for colliding bricks, which are then destroyed
    -- each destroyed brick should be added to your "ammo" for building
--    if love.mouse.wasPressed(1) then
 --       for k, brick in pairs(self.bricks) do
   --         if self.cursor:collides(brick) then
   --             brick:break(self.cursor)
  --          end
 --       end
 --   end

    self.cursor:update(dt)
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
    
    for k, brick in pairs(self.bricks) do
        brick:render()
    end
    self.player:render()
    self.cursor:render()

    love.graphics.setFont(gFonts['small'])
    love.graphics.print('grounded: ' .. (self.player.grounded and 1 or 0), VIRTUAL_WIDTH - 60, 5)
    love.graphics.print('grounded: ' .. (self.player.grounded and 1 or 0), VIRTUAL_WIDTH - 60, 5)
    love.graphics.print('cBot: ' .. (self.player.cBot and 1 or 0), VIRTUAL_WIDTH - 60, 15)
    love.graphics.print('cTop: ' .. (self.player.cTop and 1 or 0), VIRTUAL_WIDTH - 60, 30)
    love.graphics.print('cLeft: ' .. (self.player.cLeft and 1 or 0), VIRTUAL_WIDTH - 60, 45)
    love.graphics.print('cRight: ' .. (self.player.cRight and 1 or 0), VIRTUAL_WIDTH - 60, 60)
end