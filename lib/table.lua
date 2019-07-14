function table.addTable(t, toAdd)
    for k, v in pairs(toAdd) do
        table.insert(t, v)
    end
end