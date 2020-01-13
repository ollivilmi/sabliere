Abilities = {}

function Abilities:init(level)
    return
    {
        [1] = {
            range = 200,
            radius = 40,
            use = function(this, player, coords)
                local px, py = math.rectangleCenter(player)
                if math.distance(px, py, coords.x, coords.y) > this.range then return end
                
                local items, len = level.world:queryRect(coords.x, coords.y, this.radius, this.radius)
                        
                for __, item in pairs(items) do
                    if item.isTile then
                        local x, y = level.world:getRect(item)
                        level.tilemap:removeIfExists(x, y)
                        level.resources:addResource(x, y, 't')
                    end
                end
            end
        },
        [2] = {
            use = function(this, player, coords)
                -- spawn bullet if player has resources, subtract resources
            end
        }
    }
end