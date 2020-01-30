local ok, bit = pcall(require, 'bit')

if not ok then
    bit = require 'bit32'
end

PacketLoss = {}

PacketLoss.MASK_LENGTH = 16
PacketLoss.BITMASK = (2 ^ PacketLoss.MASK_LENGTH) - 1

-- parses ack mask for missing sequence numbers (missing packets)
function PacketLoss.missingSequenceNumbers(ackMask, LastReceived)
    if ackMask == PacketLoss.BITMASK then return {} end

    local missingSequenceNumbers = {}

    local temp = bit.rshift(ackMask, 1)

    for i = 1, PacketLoss.MASK_LENGTH - 1 do
        if bit.band(temp, 1) == 0 then
            -- missing package -> add sequence number to be sent
            table.insert(missingSequenceNumbers, LastReceived - i)
        end
        temp = bit.rshift(temp, 1)
    end

    return missingSequenceNumbers
end

function PacketLoss.update(ackMask, lastReceived, sequenceNumber)
    if lastReceived > sequenceNumber then
        -- eg. latest event = 5, sn = 3
        -- 00001 -> 00100
        local v = bit.lshift(1, (lastReceived - sequenceNumber))

        -- eg. mask = 10001
        -- 10001 bor 00100 = 10101
        ackMask = bit.bor(ackMask, v)
    else
        -- n of missing packets would be shift_len - 1
        local shift_len = sequenceNumber - lastReceived
        lastReceived = sequenceNumber

        -- shift, leaving missing packets as 0
        ackMask = bit.lshift(ackMask, shift_len)
        -- latest packet is marked as 1 (received)
        ackMask = bit.bor(ackMask, 1)

        -- AND to clear shifted bits
        ackMask = bit.band(ackMask, PacketLoss.BITMASK)
    end

    return ackMask, lastReceived
end