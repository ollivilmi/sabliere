Abilities = {}

function Abilities:init(level)
    return
    {
        [1] = {
            range = 200,
            radius = 40,
            use = function(this, player, pos, cursor)
                local x, y = math.rectangleCenter(pos)
                if math.distance(x, y, cursor.x, cursor.y) > this.range then return end
                
                local items, len = level.world:queryRect(cursor.x, cursor.y, this.radius, this.radius)
                        
                for __, item in pairs(items) do
                    if item.isTile then
                        local x, y = level.world:getRect(item)
                        level.tilemap:removeTile(item)
                        level.resources:addResource(x, y, 't')
                    end
                end
            end
        },
        [2] = {
            use = function(this, player, pos, cursor)
                if player.resources > 0 then
                    level.projectiles:spawnBullet(pos, cursor)
                    player.resources = player.resources - 1
                end
            end
        }
    }
end