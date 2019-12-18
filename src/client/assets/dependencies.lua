local dir = '/src/client/assets/'
local baseFont = dir .. 'fonts/font.ttf'

gFonts = {
    ['small'] = love.graphics.newFont(baseFont, 8),
    ['medium'] = love.graphics.newFont(baseFont, 16),
    ['large'] = love.graphics.newFont(baseFont, 32)
}

gTextures = {
    tiles = {
        sand = love.graphics.newImage(dir .. '/textures/sand.png')
    },
    player = love.graphics.newImage(dir .. '/textures/dude.png'),
    background = love.graphics.newImage(dir .. '/textures/mountain.png'),
    ui = {
        bar = love.graphics.newImage(dir .. '/textures/toolbar.png'),
        tools = love.graphics.newImage(dir .. '/textures/tools.png')
    }
}

gSounds = {
    player = {
        jump = love.audio.newSource(dir .. '/sounds/jump.wav', 'static')
    }
}