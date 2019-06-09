require 'src/states/play/Kinematic'

Player = Class{__includes = Kinematic}

function Player:init(texture)
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
    self.cRight = false
    self.cLeft = false
    self.cBot = false
    self.cTop = false
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
end

function Player:render()
    love.graphics.draw(self.texture, self.x, self.y, 0, 1)
end