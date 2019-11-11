gTools = {}

gTools.load = function()
    gTools = {
        build = require 'src/states/play/interface/toolbar/objects/BuildTools',
        destroy = require 'src/states/play/interface/toolbar/objects/DestroyTools'
    }
end