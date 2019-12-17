require 'lib/network/Data'

-- State holds the current server state for everything necessary
-- Can be compared to redux index

-- Is a class because this will have some functionality such as loading
-- previous state from database etc.
State = Class{}

function State:init(host)
    self.host = host

    self.index = {
        level = {},
        client = {},
        player = {}
    }
end

-- Update state for given table
function State:update(substate, key, value)
    self.index[substate][key] = value
end

-- The same but also add to be sent for clients
function State:push(substate, key, value)
    self:update(substate, key, value)

    table.insert(self.host.updates, Data(key, substate, value))
end
