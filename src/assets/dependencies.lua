local dir = '/src/assets/'
local baseFont = dir .. 'fonts/font.ttf'

gFonts = {
    ['small'] = love.graphics.newFont(baseFont, 8),
    ['medium'] = love.graphics.newFont(baseFont, 16),
    ['large'] = love.graphics.newFont(baseFont, 32)
}

gTextures = {
    background = love.graphics.newImage(dir .. '/textures/pub.png'),
    player = love.graphics.newImage(dir .. '/textures/player.png')
}

gSounds = {
    player = {
        jump = love.audio.newSource(dir .. '/sounds/jump.wav', 'static')
    }
}