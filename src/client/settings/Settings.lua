local settings = {}

-- game controls / graphics
settings.core = {
    input = require 'src/client/settings/input',
    graphics = require 'src/client/settings/graphics'
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
    for __,setting in pairs(self.core) do
        setting.load()
    end
end

return settings