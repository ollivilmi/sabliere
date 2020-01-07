local json = require 'lib/language/json'

local Hotkeys = {
    fileName = 'hotkeys',
}

function Hotkeys:default()
    return { 
        movement = {
            left = 'a',
            right = 'd',
            jump = 'space'
        },

        interface = {
            toggle = '-'
        },

        camera = {
            zoomIn = ',',
            zoomOut = '.'
        },

        toolbar = {
            '1',
            '2',
            '3',
            '4',
            '5',
            '6',
            '7',
            '8',
            '9',
            '0',
        },
    }
end

function Hotkeys:save(hotkeys)
    local hotkeys = hotkeys or self:default()
    love.filesystem.write(self.fileName, json.encode(hotkeys))
end

function Hotkeys:load()
    if love.filesystem.getInfo(self.fileName) then
        return json.decode(love.filesystem.read(self.fileName))
    else
        return self:default()
    end
end

return Hotkeys