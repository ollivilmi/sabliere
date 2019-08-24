gToolmap = {}

-- todo: use file to load
gToolmap.load = function()

    -- default values for now
    gToolmap.main = {
        gTools.destroy.circle,
        gTools.build.tile,
        gTools.build.rectangle
    }
end