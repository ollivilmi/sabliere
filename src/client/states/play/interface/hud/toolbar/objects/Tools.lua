gTools = {}

gTools.load = function()
    gTools = {
        build = require 'src/client/states/play/interface/hud/toolbar/objects/BuildTools',
        destroy = require 'src/client/states/play/interface/hud/toolbar/objects/DestroyTools'
    }
end