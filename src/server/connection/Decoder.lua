require "src/server/connection/Data"

Decoder = Class{}

function Decoder:init(commands)
    self.commands = commands
end

function Decoder:decode(data)
    local client, command, payload = data:match(DEFAULT.description)
    -- initially load parameters into array, then into variables
    local parameterArray
    local parameters = {}

    local spec = self.commands[command].spec
    if spec then
        parameterArray = table.pack(payload:match(spec.description))

        for k,v in ipairs(spec.keys) do
            parameters[v] = parameterArray[k]
        end

        -- TODO: add verification that data was decoded correctly.
        -- could also edit spec so that we are not dealing with
        -- just parameters array, but something more concrete.
    end

    return Data(client, command, parameters)
end