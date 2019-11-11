local playerCommands = require "src/client/network/command/PlayerCommands"
local worldCommands = require "src/client/network/command/response/WorldCommands"

local ParameterParser = require "lib/network/ParameterParser"

local Commands = {
    update = {
        parse = ParameterParser:build({x = 'FLOAT', y = 'FLOAT'}),
        execute = worldCommands.update
    },
    connect = {
        parse = ParameterParser:build({x = 'FLOAT', y = 'FLOAT'}),
        execute = playerCommands.connect
    },
    move = {
        execute = playerCommands.update
    },
    quit = {
        execute = playerCommands.quit
    }
}    

return Commands