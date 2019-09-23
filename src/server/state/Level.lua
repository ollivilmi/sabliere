local Level = {}

-- level should be possible to save to a file in a serialized format

-- this serialized format is also used when sending it to the player


-- level.toData()
-- returns entire tilemap for current level

-- level.update()
-- updates tilemap, returns a list of tiles that we changed
-- this list of tiles is then added on the client side, overwriting old tiles

return Level