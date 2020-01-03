Toolbar = Class{}

function Toolbar:init(gui, x, y, n)
    local unit = gui.style.unit

    local x = x - (n / 2 * unit)

    local toolbar = gui:group('Toolbar', {x, y, n * unit, n * unit})

    for i = 0, n - 1 do
        local button = gui:button(i, {i * unit, 0, unit, unit}, toolbar)
        button.click = function(self)
            gui:unfocus()
            gui:setfocus(self)
        end
    end
end