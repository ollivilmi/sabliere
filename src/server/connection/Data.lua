Data = Class{}

function Data:init(client, command, parameters)
    self.client = client
    self.command = command
    self.parameters = {}
    if parameters then
        for k,v in pairs(parameters) do
            self[k] = v
            table.insert(self.parameters, v)
        end
    end
end

function Data:toString()
    return string.format("%s %s %s", self.client, self.command, table.concat(self.parameters, " "))
end