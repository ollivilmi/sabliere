ServerOnlyEvents = Class{}

function ServerOnlyEvents:init(host)
    local state = host.state

    state.players:addListener('RESOURCE COLLISION', function(player, resources)
        local entity = state.players:getEntity(player)
        local coords = {}

        for __, resource in pairs(resources) do
            if entity.resources < 100 then
                entity.resources = entity.resources + 1

                local x, y = state.world:getRect(resource)
                state.level.resources:removeResource(resource)
                table.insert(coords, {x = x, y = y})
            else
                break
            end
        end

        host.updates:pushEvent(Data({request = "pickup", entityId = player},{coords = coords}))
    end)

    state.players:addListener('PROJECTILE COLLISION', function(player, bullet)
        print("projectile col")
    end)
end