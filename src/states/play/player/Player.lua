require 'src/states/play/lib/physics/Kinematic'
require 'src/states/play/player/Tool'
require 'src/states/play/player/Animation'

Player = Class{__includes = Kinematic}

function Player:init(playState)
    self.texture = gTextures.player
    self.characterQuads = GenerateQuads(gTextures.player, 50, 100)

    idleAnimation = Animation {
        frames = {1},
        interval = 1
    }
    movingAnimation = Animation {
        frames = {2, 3},
        interval = 0.2
    }
    jumpAnimation = Animation {
        frames = {4},
        interval = 1
    }
    fallAnimation = Animation {
        frames = {5},
        interval = 1
    }


    currentAnimation = idleAnimation
    direction = 'right'

    self.width = 50
    self.height = 100
    self.x = VIRTUAL_WIDTH / 2
    self.y = VIRTUAL_HEIGHT / 2
    
    self.dy = 0
    self.dx = 0
    self.grounded = false
    self.speed = 100
    self:initHitboxes()

    self.tool = Tool(playState)
end

function Player:update(dt)
    self:applyDeltas(dt)

    if love.keyboard.isDown('left') then
        self.dx = -self.speed
        direction = 'left'
    elseif love.keyboard.isDown('right') then
        self.dx = self.speed
        direction = 'right'
    else
        self.dx = 0
    end

    if self.dx ~= 0 and self.grounded then
        currentAnimation = movingAnimation
    elseif not self.grounded then
        if self.dy < 0 then
            currentAnimation = jumpAnimation
        else
            currentAnimation = fallAnimation
        end
    else
        currentAnimation = idleAnimation
    end

    if love.keyboard.isDown('space') then
        if self:jump() then
            gSounds.player.jump:play()
        end
    end

    currentAnimation:update(dt)
    self.tool:update(dt)
end

function Player:render()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.texture, self.characterQuads[currentAnimation:getCurrentFrame()], 

            -- X and Y we draw at need to be shifted by half our width and height because we're setting the origin
            -- to that amount for proper scaling, which reverse-shifts rendering
            math.floor(self.x) + self.width / 2, math.floor(self.y) + self.height / 2, 

            -- 0 rotation, then the X and Y scales
            0, direction == 'left' and -1 or 1, 1,

            -- lastly, the origin offsets relative to 0,0 on the sprite (set here to the sprite's center)
            self.width / 2, self.height / 2)
    self.tool:render()
end