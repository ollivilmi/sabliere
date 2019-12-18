require 'src/client/states/play/interface/hud/toolbar/Tool'
require 'src/client/states/play/interface/cursor/objects/Cursors'
require 'src/client/states/play/interface/hud/Icon'

local toolQuads = GenerateQuads(gTextures.ui.tools, 40, 40)

local buildTools = {
    tile = Tool(
        {
            icon = Icon(gTextures.ui.tools, toolQuads[1], BUTTON_SCALE),
            cursor = gCursors.tile,
            range = 250,
            action = function(square)
                gTilemap:addSquareInRange(square, gPlayer.toolRange)
            end
        }
    ),
    rectangle = Tool(
        {
            icon = Icon(gTextures.ui.tools, toolQuads[2], BUTTON_SCALE),
            cursor = gCursors.rectangle,
            range = 600,
            action = function(rectangle)
                gTilemap:addRectangleInRange(rectangle, gPlayer.toolRange)
            end
        }
    )
}

return buildTools