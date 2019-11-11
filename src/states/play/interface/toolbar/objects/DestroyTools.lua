require 'src/states/play/interface/toolbar/Tool'
require 'src/states/play/interface/cursor/objects/Cursors'
require 'lib/interface/Icon'

local toolQuads = GenerateQuads(gTextures.ui.tools, 40, 40)

local destroyTools = {
    circle = Tool(
        {
            icon = Icon(gTextures.ui.tools, toolQuads[3], BUTTON_SCALE),
            cursor = gCursors.circle,
            range = 250,
            action = function(pos)
                gTilemap:removeTiles(pos)
            end
        }
    )
}

return destroyTools