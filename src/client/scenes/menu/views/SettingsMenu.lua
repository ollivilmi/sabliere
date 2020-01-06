SettingsMenu = {}

function SettingsMenu:init(menuScene)
    local gui = menuScene.gui

    local group = gui:group(nil, {0, 0, love.graphics.getWidth(), love.graphics.getHeight()})

    local title = gui:text('SETTINGS', {
            x = CenterText(love.graphics.getWidth(), menuScene.titleFont, 'SETTINGS'),
            y = 50,
            w = 500,
            h = 100,
        }, 
        group
    )
    title.style.fg = {0,0,0}
    title.style.font = menuScene.titleFont

    local hotkeysButton = gui:button('Hotkeys', {
            x = (love.graphics.getWidth() / 2) - 150, 
            y = (love.graphics.getHeight() / 2) + 140, 
            w = 300, 
            h = 50
        },
        group
    )

    hotkeysButton.click = function(this)
        menuScene:navigate('hotkeys')
    end
    
    gui:button('Graphics', {
            x = (love.graphics.getWidth() / 2) - 150, 
            y = (love.graphics.getHeight() / 2) + 240, 
            w = 300, 
            h = 50
        },
        group
    )

    group:hide()

    group.onExit = function(this)
    end

    return group
end