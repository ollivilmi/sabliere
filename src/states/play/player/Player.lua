require 'src/states/play/lib/animations/AnimatedKinematic'
require 'src/states/play/player/Tool'

Player = Class{__includes = AnimatedKinematic}

function Player:init(playState)
    self:loadSheet(gTextures.player)
    self.width = 50
    self.height = 100
    self.x = MAP_WIDTH / 2
    self.y = MAP_HEIGHT - 300
    
    self.dy = 0
    self.dx = 0
    self.grounded = false
    self.speed = 200
    self:initHitboxes()

    self.tool = Tool(playState)
end

function Player:update(dt)
    self:applyDeltas(dt)
    self:updateControls()
    self:updateAnimation(dt)
    self.tool:update(dt)
end

function Player:updateControls()
    if love.keyboard.isDown('a') then
        self.dx = -self.speed
    elseif love.keyboard.isDown('d') then
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
    self:animate()
    self.tool:render()
    if DEBUG_MODE then
        self:renderHitboxes()
    end
end