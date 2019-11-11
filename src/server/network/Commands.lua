local request = require "src/server/network/command/request/Request"
local response = require "src/server/network/command/response/Response"

local ParameterParser = require "lib/network/ParameterParser"

local Commands = {
    move = {
        parse = ParameterParser:build({x = 'FLOAT', y = 'FLOAT'}),
        execute = request.player.move
    },
    connect = {
        parse = ParameterParser:build({x = 'FLOAT', y = 'FLOAT'}),
        execute = request.player.connect
    },
    update = {
        execute = response.player.update
    },
    quit = {
        execute = response.player.quit
    }
}

return Commands