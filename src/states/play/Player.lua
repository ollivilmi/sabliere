require 'src/states/play/Kinematic'

Player = Class{__includes = Kinematic}

function Player:init(texture)
    self.texture = texture
    self.width = texture:getWidth()
    self.height = texture:getHeight()
    self.x = VIRTUAL_WIDTH / 2
    self.y = VIRTUAL_HEIGHT - self.height
    
    -- self.setKinematic()
    self.dy = 0
    self.dx = 0
    self.speed = 100
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
        self:jump()
        gSounds.player.jump:play()
    end
end

function Player:render()
    love.graphics.draw(self.texture, self.x, self.y, 0, 1)
end