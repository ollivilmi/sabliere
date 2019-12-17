require "lib/network/Data"
local json = require 'lib/util/json'

Decoder = Class{}

function Decoder:init()
    -- First two variables are strings
    -- 
    -- String 1: entity   String 2: command
    --
    -- Remainders: optional parameters for the command (json)
    self.format = '^(%S*) (%S*) (.*)'
end

function Decoder:decode(data)
    local client, command, payload = data:match(self.format)

    local parameters = json.decode(payload)

    return Data(client, command, parameters)
end