require 'src/states/play/lib/physics/Kinematic'
require 'src/states/play/player/Tool'
require 'src/states/play/player/Animation'

Player = Class{__includes = Kinematic}

function Player:init(playState)
    self.texture = gTextures.player
    self.characterQuads = GenerateQuads(gTextures.player, 50, 100)
    self.animations = {
        idle = Animation {
            frames = {1},
            interval = 1
        },
        moving = Animation {
            frames = {2, 3},
            interval = 0.2
        },
        jump = Animation {
            frames = {4},
            interval = 1
        },
        fall = Animation {
            frames = {5},
            interval = 1
        }
    }
    self.animation = self.animations.idle
    self.direction = 'right'

    self.width = 50
    self.height = 100
    self.x = VIRTUAL_WIDTH / 2
    self.y = VIRTUAL_HEIGHT / 2
    
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
    self:updateAnimation()
    self.animation:update(dt)
    self.tool:update(dt)
end

function Player:updateControls()
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

function Player:updateAnimation()
    if self.dx ~= 0 and self.grounded then
        self.animation = self.animations.moving
        if self.dx > 0 then
            self.direction = 'right'
        else
            self.direction = 'left'
        end

    elseif not self.grounded then
        if self.dy < 0 then
            self.animation = self.animations.jump
        else
            self.animation = self.animations.fall
        end

    else
        self.animation = self.animations.idle
    end
end

function Player:render()
    love.graphics.draw(self.texture, self.characterQuads[self.animation:get()], 

            -- X and Y we draw at need to be shifted by half our width and height because we're setting the origin
            -- to that amount for proper scaling, which reverse-shifts rendering
            math.floor(self.x) + self.width / 2, math.floor(self.y) + self.height / 2, 

            -- 0 rotation, then the X and Y scales
            0, self.direction == 'left' and -1 or 1, 1,

            -- lastly, the origin offsets relative to 0,0 on the sprite (set here to the sprite's center)
            self.width / 2, self.height / 2)
    self.tool:render()
end