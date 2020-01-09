AbilityRendering = Class{}

function AbilityRendering:init()
    self.abilities = Game.state.level.abilities

    Game.client:addListener('PLAYER CONNECTED', function(player)
        self.player = player
    end)

    self.icons = {
        [1] = {
            name = "Destroy tiles",
            description = [[
                Lorem ipsum
                Sit dolore
            ]],
            icon = love.graphics.newImage('src/client/assets/textures/tile/sand.png'),
        },
        [2] = {
            name = "Shoot",
            description = "Lorem ipsum",
            icon = love.graphics.newImage('src/client/assets/textures/tile/sand.png'),
        }
    }

    self.cursors = {
        [1] = function(x, y)
            local ability = self.abilities[1]
            local px, py = math.rectangleCenter(self.player)
            local wx, wy = Camera:worldCoordinates(x, y)

            local color = math.distance(px, py, wx, wy) < ability.range and {0,0,0} or {0,0,0,0.5}
            
            love.graphics.setColor(color)
            love.graphics.rectangle('line', x, y, ability.radius / Camera.zoom, ability.radius / Camera.zoom)
        end,
        [2] = function(x, y)
            love.graphics.setColor(0,0,0)
            love.graphics.circle('line', x, y, 5, 5)
            -- todo: arrow from player, gun?
        end
    }
end