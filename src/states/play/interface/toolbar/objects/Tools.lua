require 'src/states/play/interface/toolbar/Tool'
require 'lib/interface/Icon'

gTools = {}

gTools.load = function(playState)
    local toolQuads = GenerateQuads(gTextures.ui.tools, 40, 40)
    gTools.build = {
        tile = Tool(
            {
                icon = Icon(gTextures.ui.tools, toolQuads[1], BUTTON_SCALE),
                cursor = gCursors.tile,
                action = function(pos)
                    playState.level.tilemap:overwrite(pos)
                end,
                onClick = function()
                    playState.interface:switchTool(2)
                end
            }
        ),
        rectangle = Tool(
            {
                icon = Icon(gTextures.ui.tools, toolQuads[2], BUTTON_SCALE),
                cursor = gCursors.rectangle,
                action = function(pos)
                    playState.level.tilemap:addTiles(pos)
                end,
                onClick = function()
                    playState.interface:switchTool(3)
                end
            }
        )
    }
    gTools.destroy = {
        circle = Tool(
            {
                icon = Icon(gTextures.ui.tools, toolQuads[3], BUTTON_SCALE),
                cursor = gCursors.circle,
                action = function(pos)
                    playState.level.tilemap:removeTiles(pos)
                end,
                onClick = function()
                    playState.interface:switchTool(1)
                end
            }
        )
    }
end