Cursor = Class{}

function Cursor:init(cursors)
    self.cursors = cursors

    self.cursor = function(x, y)
            love.graphics.circle('line', x, y, 5, 5)
        end
end

function Cursor:load(abilityControls)
    self.cursor = self.cursors[1]

    abilityControls:addListener('ABILITY CHANGED', function(id)
        self.cursor = self.cursors[id]
    end)
end

-- gamestate ability, player
function Cursor:render()
    self.cursor(love.mouse.getX(), love.mouse.getY())
end