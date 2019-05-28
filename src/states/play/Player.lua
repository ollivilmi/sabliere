Player = Class{}

function Player:init(texture)
    self.texture = texture
    self.width = texture:getWidth()
    self.height = texture:getHeight()
    self.x = VIRTUAL_WIDTH / 2
    self.y = VIRTUAL_HEIGHT - self.height
    
    self.grounded = true
    self.dy = 0
    self.speed = 100
end

function Player:update(dt)
    if not self.grounded then
        self.dy = self.dy + GRAVITY * dt
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy)
    end

    if love.keyboard.wasPressed('space') then
        self.dy = -GRAVITY/4
        gSounds.player.jump:play()
        self.grounded = false
    end

    if love.keyboard.isDown('left') then
        self.dx = -self.speed
    elseif love.keyboard.isDown('right') then
        self.dx = self.speed
    else
        self.dx = 0
    end

    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    end
end

function Player:collides(target)
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    return true
end

function Player:render()
    love.graphics.draw(self.texture, self.x, self.y, 0, 1)
end