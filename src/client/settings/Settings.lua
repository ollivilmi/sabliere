Settings = Class{}

function Settings:init()
    self.input = require 'src/client/settings/input'
    self.graphics = require 'src/client/settings/graphics'

    self.core = {
        self.input,
        self.graphics
    }

    self:loadAll()
end

function Settings.save(fileName, setting)
    love.filesystem.write(fileName, table.show(setting))
end

function Settings.load(fileName, setting)
    if love.filesystem.getInfo(fileName) then
        s = love.filesystem.load(fileName)
        s()
    else
        settings.save(fileName, setting)
    end
end

function Settings:loadAll()
    for __, setting in pairs(self.core) do
        setting.load()
    end
end
