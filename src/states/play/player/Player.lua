require 'src/states/play/lib/physics/Kinematic'
require 'src/states/play/player/Cursor'

Player = Class{__includes = Kinematic}

function Player:init(texture, playState)
    self.texture = texture
    self.width = texture:getWidth()
    self.height = texture:getHeight()
    self.x = VIRTUAL_WIDTH / 2
    self.y = VIRTUAL_HEIGHT / 2
    
    self.dy = 0
    self.dx = 0
    self.grounded = false
    self.speed = 100
    self:initHitboxes()

    self.cursor = Cursor(10, playState)
end

function Player:update(dt)
    self:applyDeltas(dt)

    if love.keyboard.isDown('left') then
        self.dx = -self.speed
    elseif love.keyboard.isDown('right') then
        self.dx = self.speed
    else
        self.dx = 0
    end

    if love.keyboard.isDown('space') then
        if self:jump() then
            gSounds.player.jump:play()
        end
    end

    self.cursor:update(dt)
end

function Player:render()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.texture, self.x, self.y, 0, 1)
    self.cursor:render()
end