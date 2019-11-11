require "lib/network/Data"

-- Splits strings into parameters depending on the command
Decoder = Class{}

function Decoder:init(commands, format)
    self.commands = commands
    self.format = format or '^(%S*) (%S*) (.*)'
end

function Decoder:decode(data)
    local client, command, payload = data:match(self.format)

    local parameters = self.commands[command].parse(payload)

    --todo: verify that decoding was ok before returning

    return Data(client, command, parameters)
end