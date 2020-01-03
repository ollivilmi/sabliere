gTools = {}

gTools.load = function()
    gTools = {
        build = require 'src/client/scenes/play/interface/hud/toolbar/objects/BuildTools',
        destroy = require 'src/client/scenes/play/interface/hud/toolbar/objects/DestroyTools'
    }
end