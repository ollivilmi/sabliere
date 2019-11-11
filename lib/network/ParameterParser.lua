require "lib/util/table"

local ParameterParser = {}

ParameterParser.patterns = {
    START_OF_LINE = "^",
    END_OF_LINE = "$",
    
    STRING = "(%S*)",
    FLOAT = "(%-?[%d.e]*)",
    REMAINDERS = "(.*)"
}

function ParameterParser:build(args, eol)
    -- Get first element in table to initialize the string matcher with start of line
    local accessor, pattern = next(args)

    local accessors = {accessor}
    
    -- appending to a table because there is no stringbuilder in lua
    local matchPattern = { self.patterns.START_OF_LINE .. self.patterns[pattern] }

    -- Iterate rest of the table
    while true do
        accessor, pattern = next(args, accessor)
        
        if not accessor then break end

        table.insert(accessors, accessor)
        table.insert(matchPattern, " " .. self.patterns[pattern])
    end

    -- always ends in eol
    table.insert(matchPattern, self.patterns.END_OF_LINE)
    
    -- convert table into string
    local matchString = table.concat(matchPattern)
    
    -- parses parameters using closure
    local parser = function(data)
        local parameters = {}

        -- Map parsed parameters to string accessors
        for k, parameter in ipairs(table.pack(data:match(matchString))) do
            parameters[accessors[k]] = parameter
        end

        return parameters
    end

    return parser
end

return ParameterParser