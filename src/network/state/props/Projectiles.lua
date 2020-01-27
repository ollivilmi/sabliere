require 'src/network/state/props/Bullet'
require 'lib/language/Listener'

Projectiles = Class{__includes = Listener}

local BULLET_WIDTH = 10
local BULLET_HEIGHT = 10
local BULLET_SPEED = 800

function Projectiles:init(world)
    Listener:init(self)
    self.world = world
    self.projectiles = {}
end

function Projectiles:spawnBullet(pos, cursor)
    local bullet = Bullet(pos, cursor)

    self.world:add(bullet, bullet.x, bullet.y, bullet.w, bullet.h)
    table.insert(self.projectiles, bullet)

    Timer.after(10, function()
        if not bullet.destroyed then
            self.world:remove(bullet)
            bullet.destroyed = true
        end
    end)
end

local function projectileCollision(projectile, other)
    if other.isResource then
        return 'cross'
    else
        return 'slide'
    end
end

function Projectiles:update(dt)
    for __, p in pairs(self.projectiles) do
        if not p.destroyed then
            local x, y, cols, cols_len = self.world:move(p, p.x + p.dx * dt, p.y + p.dy * dt, projectileCollision)
            p.x = x
            p.y = y
            
            for __, col in pairs(cols) do
                if col.type ~= 'cross' then
                    if col.other.isEntity then
                        self:broadcastEvent('PROJECTILE COLLISION', col.other)
                    end
                    p.destroyed = true
                    pcall(self.world.remove, self.world, p)
                end
            end
        end
    end
end