Data = Class{}
local json = require 'lib/util/json'

function Data:init(client, request, parameters)
    self.client = client
    self.request = request
    self.parameters = parameters
end

function Data:toString()
    return string.format("%s %s %s", self.client, self.request, json.encode(self.parameters))
end