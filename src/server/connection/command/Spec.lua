local SpecBuilder = {}

START_OF_LINE = "^"
END_OF_LINE = "$"

STRING = "(%S*)"
FLOAT = "(%-?[%d.e]*)"
REMAINDERS = "(.*)"

function SpecBuilder.build(args, eol)
    local k,v = next(args)

    local keys = {k}
    -- using a table because strings are immutable and there is no stringbuilder in lua
    local description = { START_OF_LINE .. v }

    while true do
        k,v = next(args, k)
        if not k then break end

        table.insert(keys, k)
        table.insert(description, " " .. v)
    end

    if eol then
        table.insert(description, END_OF_LINE)
    end

    return {keys = keys, description = table.concat(description)}
end

DEFAULT = SpecBuilder.build({STRING, STRING, REMAINDERS})

return SpecBuilder