require 'src/states/play/interface/hud/toolbar/objects/Tools'

gTools.load()

gToolmap = {
    main = {
        gTools.destroy.circle,
        gTools.build.tile,
        gTools.build.rectangle
    }
}