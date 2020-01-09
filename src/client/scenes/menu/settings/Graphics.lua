local json = require 'lib/language/json'

local Graphics = {
    fileName = 'graphics'
}

function Graphics:default()
    return {
        resolution = {
            width = '1280',
            height = '720',
            fullscreen = false,
            vsync = true
        },
    }
end

function Graphics:save(settings)
    local hotkeys = hotkeys or self:default()
    love.filesystem.write(self.fileName, json.encode(settings))
end

function Graphics:load()
    if love.filesystem.getInfo(self.fileName) then
        return json.decode(love.filesystem.read(self.fileName))
    else
        return self:default()
    end
end

return Graphics