-- needs cursor
-- perhaps cursors should be separated from tools
-- then just have different possible cursors for player, switch to that
-- cursor and then just swap callback logic
gTools = {}

gTools.load = function(playState)
    local toolQuads = GenerateQuads(gTextures.ui.tools, 40, 40)

    gTools.build = {
        tile = Tool({
            quad = toolQuads[1],
            cursor = gCursors.tile,
            action = function()
                playState.level.tilemap:overwrite(playState.player.cursor:getPosition())
            end
            }
        ),
        rectangle = Tool({
            quad = toolQuads[2],
            cursor = gCursors.rectangle,
            action = function()
                playState.level.tilemap:addTiles(playState.player.cursor:getPosition())
            end
            }
        )
    }
    gTools.destroy = {
        circle = Tool({
            quad = toolQuads[3],
            cursor = gCursors.circle,
            action = function()
                playState.level.tilemap:removeTiles(playState.player.cursor:getPosition())
            end
            }
        )
    }
end