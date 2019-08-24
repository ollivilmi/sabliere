require 'src/assets/settings/Keymap'
require 'src/assets/settings/Toolmap'

settings = {}

settings.save = function(fileName, setting)
    love.filesystem.write(fileName, table.show(setting))
end

settings.load = function(fileName, setting)
    if love.filesystem.getInfo(fileName) ~= nil then
        s = love.filesystem.load(fileName)
        s()
    else
        settings.save(fileName, setting)
    end
end

settings.loadAll = function()
    local all = {
        keymap = gKeymap,
        toolmap = gToolmap
    }

    for k,v in pairs(all) do
        settings.load(k, v)
    end
end