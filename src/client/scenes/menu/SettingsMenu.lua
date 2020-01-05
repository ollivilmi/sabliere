SettingsMenu = {}

function SettingsMenu:init(menuScene)
    local gui = menuScene.gui

    local group = gui:group(nil, {0, 0, love.graphics.getWidth(), love.graphics.getHeight()})

    local title = gui:text('SETTINGS', {
            x = love.graphics.getWidth() / 2 - (menuScene.titleFont:getWidth('SETTINGS') / 2),
            y = 50,
            w = 500,
            h = 100,
        }, 
        group
    )
    title.style.fg = {0,0,0}
    title.style.font = menuScene.titleFont

    gui:button('Hotkeys', {
            x = (love.graphics.getWidth() / 2) - 150, 
            y = (love.graphics.getHeight() / 2) + 140, 
            w = 300, 
            h = 50
        },
        group
    )
    
    gui:button('Graphics', {
            x = (love.graphics.getWidth() / 2) - 150, 
            y = (love.graphics.getHeight() / 2) + 240, 
            w = 300, 
            h = 50
        },
        group
    )

    group:hide()

    return group
end