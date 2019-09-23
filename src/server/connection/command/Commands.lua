require "src/server/connection/command/Command"

local input = require "src/server/connection/command/input/Input"
local output = require "src/server/connection/command/output/Output"
local specBuilder = require "src/server/connection/command/Spec"

local Commands = {
    move = Command{
        spec = specBuilder.build({x = FLOAT, y = FLOAT}, true),
        execute = input.player.move
    },
    connect = Command{
        spec = specBuilder.build({x = FLOAT, y = FLOAT}, true),
        execute = input.player.connect
    },
    update = Command{
        execute = output.player.update
    },
    quit = Command{
        execute = output.player.quit
    }
}    

return Commands