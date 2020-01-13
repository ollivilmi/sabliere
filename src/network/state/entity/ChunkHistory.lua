local ChunkHistory = {}

function ChunkHistory:update(id, chunk)
    if not self[id][chunk.x] then
        self[id][chunk.x] = {}
    end

    self[id][chunk.x][chunk.y] = os.time()
    self[id].current = chunk
end

function ChunkHistory:timeElapsed(id, chunk)
    if not self[id][chunk.x] then return - 1 end
    if not self[id][chunk.x][chunk.y] then return - 1 end

    return os.time() - self[id][chunk.x][chunk.y]
end

return ChunkHistory