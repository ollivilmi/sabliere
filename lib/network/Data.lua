Data = Class{}

function Data:init(client, command, parameters)
    self.client = client
    self.command = command
    self.parameters = parameters
end

function Data:toString()
    -- table.concat does not work with string indices
    local params = {}
    for __,v in pairs(self.parameters) do
        table.insert(params, v)
    end

    return string.format("%s %s %s", self.client, self.command, table.concat(params, " "))
end