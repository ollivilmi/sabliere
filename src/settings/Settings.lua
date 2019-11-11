require 'src/settings/player/Keymap'
require 'src/settings/player/Toolmap'

-- Settings are loaded / saved as files
local settings = {}

-- Core settings are always loaded to setup game controls / graphics
settings.core = {
    input = require 'src/settings/input',
    graphics = require 'src/settings/graphics'
}

-- Extended settings, player specific can be saved / loaded from file
settings.player = {
    keymap = gKeymap,
    toolmap = gToolmap
}

settings.save = function(fileName, setting)
    love.filesystem.write(fileName, table.show(setting))
end

settings.load = function(fileName, setting)
    if love.filesystem.getInfo(fileName) then
        s = love.filesystem.load(fileName)
        s()
    else
        settings.save(fileName, setting)
    end
end

function settings:loadAll()
    -- load core settings with default values
    -- (not loaded from files yet)
    for __,setting in pairs(self.core) do
        setting.load()
    end

    -- load user settings from files
    for k,v in pairs(self.player) do
        settings.load(k, v)
    end
end

return settings