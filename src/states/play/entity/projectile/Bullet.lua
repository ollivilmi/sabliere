require 'src/states/play/entity/Entity'

Bullet = Class{__includes = Entity}

function Bullet:init(x, y, direction, collidables)
    Entity:init(self, { 
        x = x,
        y = y,
        width = 10,
        height = 10,
        speed = 500
    })
    self.direction = direction
    self.collidables = collidables
    self.toDestroy = false
end

function Bullet:update(dt)
    self:updateMovement(dt)
    if self.direction == 'right' then
        self.dx = self.dx + self.speed * dt
    else
        self.dx = self.dx - self.speed * dt
    end

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