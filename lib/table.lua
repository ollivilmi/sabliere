function table.addTable(t, toAdd)
    for k, v in pairs(toAdd) do
        table.insert(t, v)
    end
end

function table.allElementsEqual(t, comparator)
    for k,v in pairs(t)
        if compararator(v) == false then
            return false
        end
    end
    return true
end