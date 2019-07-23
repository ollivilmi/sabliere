require 'src/states/play/player/interface/toolbar/Tool'

gTools = {}

gTools.load = function(playState)
    toolQuads = GenerateQuads(gTextures.ui.tools, 40, 40)

    gTools.build = {
        tile = Tool({
            quad = toolQuads[1],
            cursor = gCursors.tile,
            action = function(pos)
                playState.level.tilemap:overwrite(pos)
            end
            }
        ),
        rectangle = Tool({
            quad = toolQuads[2],
            cursor = gCursors.rectangle,
            action = function(pos)
                playState.level.tilemap:addTiles(pos)
            end
            }
        )
    }
    gTools.destroy = {
        circle = Tool({
            quad = toolQuads[3],
            cursor = gCursors.circle,
            action = function(pos)
                playState.level.tilemap:removeTiles(pos)
            end
            }
        )
    }
end