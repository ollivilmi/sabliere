require 'src/states/play/interface/toolbar/Tool'
require 'src/states/play/interface/cursor/objects/Cursors'
require 'lib/interface/Icon'

gTools = {}

gTools.load = function()
    local toolQuads = GenerateQuads(gTextures.ui.tools, 40, 40)
    gTools.build = {
        tile = Tool(
            {
                icon = Icon(gTextures.ui.tools, toolQuads[1], BUTTON_SCALE),
                cursor = gCursors.tile,
                range = 250,
                action = function(pos)
                    gTilemap:overwrite(pos)
                end
            }
        ),
        rectangle = Tool(
            {
                icon = Icon(gTextures.ui.tools, toolQuads[2], BUTTON_SCALE),
                cursor = gCursors.rectangle,
                range = 300,
                action = function(pos)
                    gTilemap:addTiles(pos)
                end
            }
        )
    }
    gTools.destroy = {
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
end