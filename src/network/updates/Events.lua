require 'lib/language/table'
require 'lib/language/Sequence'

Events = Class{}

Events.HISTORY_LENGTH = 1000

function Events:init(gettime)
    self.gettime = gettime
    self.sequence = Sequence(Events.HISTORY_LENGTH)
end

function Events:lostPackets(headers)
    local packets = {}

    for __, seq in pairs(PacketLoss.missingSequenceNumbers(headers.ack, headers.last)) do
        local packet = self:getPrevious(seq)
        if packet then
            table.insert(packets, packet)
        end
    end

    return packets
end

function Events:getPrevious(sequenceNumber)
    local previousEvents = self.sequence:get(sequenceNumber)

    if not previousEvents then return end
    
    return Data({
        batch = true,
        seq = sequenceNumber,
        sentTime = self.gettime()
    }, 
    previousEvents)
end

function Events:get()
    local data = Data({ 
        batch = true,
        seq = self.sequence.number,
        sentTime = self.gettime()
    }, 
    self.sequence:current())

    return data
end