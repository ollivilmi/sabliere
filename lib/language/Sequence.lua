Sequence = Class{}

-- Finite sequence which starts again from 1 after length is reached
function Sequence:init(length)
    self.length = length or 1000
    self.data = {{}}
    self.number = 1
end

function Sequence:next()
    self.number = self.number + 1
    
    if self.number > self.length then
        self.number = 1
    end
    self.data[self.number] = {}
end

function Sequence:push(data)
    table.insert(self.data[self.number], data)
end

function Sequence:current()
    return self.data[self.number]
end

function Sequence:get(sequenceNumber)
    if sequenceNumber < 1 then
        sequenceNumber = sequenceNumber + self.length
    end

    return self.data[sequenceNumber]
end

function Sequence:pop()
    local data = self.data[self.number]
    self:next()

    return data
end