gToolmap = {}

-- todo: use file to load
gToolmap.load = function()

    -- default values for now
    gToolmap.main = {
        gTools.destroy.circle,
        gTools.build.tile,
        gTools.build.rectangle
    }

    local x = VIRTUAL_WIDTH / 2 - ((table.getn(gToolmap.main) * TOOLBAR_SIZE)/2)
    local y = VIRTUAL_HEIGHT - TOOLBAR_SIZE - 10

    for k,tool in pairs(gToolmap.main) do
            tool.area = BoxCollider(
                x+5,
                y+5,
                TOOL_SIZE,
                TOOL_SIZE
            )
        x = x + TOOLBAR_SIZE
    end
end

-- gToolmap.save = function ()