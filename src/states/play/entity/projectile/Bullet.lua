require 'src/states/play/entity/Entity'

Bullet = Class{__includes = Entity}

function Bullet:init(x, y, direction, collidables)
    Entity:init(self, { 
        x = x,
        y = y,
        width = BULLET_WIDTH,
        height = BULLET_HEIGHT,
        speed = BULLET_SPEED
    })
    self.collidables = collidables
    self.toDestroy = false

    self.dx = direction.x * self.speed
    self.dy = direction.y * self.speed
end

function Bullet:update(dt)
    self:updateMovement(dt)

    if self:collidesTile() then
        self.toDestroy = true
    end

    for k,entity in ipairs(self.collidables) do
        if self.collider:collides(entity) then
            self.toDestroy = true
        end
    end

    -- if collides collidable entity
    -- destroy
    -- knockback entity (- dy, dx by direction)
    -- lower entity health
end

function Bullet:render()
    if DEBUG_MODE then
        Entity:render(self)
    end

    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end