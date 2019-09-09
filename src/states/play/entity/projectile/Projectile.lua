require 'src/states/play/entity/Entity'

Projectile = Class{__includes = Entity}

function Projectile:init(self, def)
    Entity:init(self, { 
        x = def.x,
        y = def.y,
        width = def.width,
        height = def.height,
        speed = def.speed
    })
    self.collidables = def.collidables
    self.toDestroy = false

    -- Projectiles fly in a straight line to direction
    -- if something else is needed, another class should be made
    self.dx = def.direction.x * self.speed
    self.dy = def.direction.y * self.speed
end

function Projectile:update(dt)
    EntityPhysics:update(self, dt)

    local tile = self:collidesTile()
    if tile then
        self:tileCollision(tile)
    end

    for k,entity in ipairs(self.collidables) do
        if self.collider:collides(entity) then
            self:entityCollision(entity)
        end
    end
end

function Projectile:render()
    if DEBUG_MODE then
        Entity:render(self)
    end

    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end