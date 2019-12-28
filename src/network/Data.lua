Data = Class{}

local json = require 'lib/language/json'
local lzw = require 'lib/language/lzw'
local md5 = require 'lib/language/md5'

function Data:init(headers, payload)
    if type(headers) ~= 'table' then
        error('invalid headers for Data class: requires table, was ' .. type(headers))
    
    elseif payload and type(payload) ~= 'table' then
        error('invalid payload for Data class: requires table, was '.. type(payload))
    end

    self.headers = headers or {}
    self.payload = payload or {}
end

function Data:encode()
    local checksum = '0'
    local payload = lzw.compress(self:toString())

    if self.headers.duplex then
        checksum = md5.sumhexa(payload)
    end

    return string.format("%s %s", checksum, payload)
end

function Data.decode(dataString)
    local checksum, payload = dataString:match('^(%S*) (.*)')

    if checksum ~= '0' then
        if md5.sumhexa(payload) ~= checksum then
            error("Checksum does not match")
        end
    end

    local data = json.decode(lzw.decompress(payload))

    return Data(data.headers, data.payload)
end

function Data:toString()
    return json.encode({headers = self.headers, payload = self.payload})
end