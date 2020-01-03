Model = Class{}

function Model:init(def)
    self.sheet = love.graphics.newImage(def.sheet)
    self.quads = GenerateQuads(
        self.sheet,
        def.width,
        def.height
    )
    self.animationStates = def.animationStates
    self:changeState('idle')
end

function Model:changeState(state)
    self.state = state
    self.timer = 0
    self.currentFrame = 1
end

function Model:update(dt)
    local animation = self.animationStates[self.state]
    
    -- no need to update if AnimationState is only one frame
    if #animation.frames > 1 then
        self.timer = self.timer + dt

        if self.timer > animation.interval then
            self.timer = self.timer % animation.interval

            self.currentFrame = math.max(1, (self.currentFrame + 1) % (#animation.frames + 1))
        end
    end
end

function Model:render(entity)
    local animation = self.animationStates[self.state]

    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.sheet, self.quads[animation.frames[self.currentFrame]], 

    -- X and Y we draw at need to be shifted by half our width and height because we're setting the origin
    -- to that amount for proper scaling, which reverse-shifts rendering
    math.floor(entity.x) + entity.width / 2, math.floor(entity.y) + entity.height / 2, 

    -- 0 rotation, then the X and Y scales
    0, entity.direction == 'left' and -1 or 1, 1,

    -- lastly, the origin offsets relative to 0,0 on the sprite (set here to the sprite's center)
    entity.width / 2, entity.height / 2)
end