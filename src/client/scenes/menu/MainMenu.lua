MainMenu = {}

function MainMenu:init(menuScene)
    local gui = menuScene.gui

    local group = gui:group(nil, {0, 0, love.graphics.getWidth(), love.graphics.getHeight()})

    local title = gui:text('SABLIERE', {
            x = love.graphics.getWidth() / 2 - (menuScene.titleFont:getWidth('SABLIERE') / 2),
            y = 50,
            w = 500,
            h = 100,
        }, 
        group
    )
    title.style.fg = {0,0,0}
    title.style.font = menuScene.titleFont

    connectButton = gui:button('Connect', {
            x = (love.graphics.getWidth() / 2) - 150, 
            y = (love.graphics.getHeight() / 2) + 40, 
            w = 300, 
            h = 50
        },
        group
    )
    
    connectButton.click = function(this)
        menuScene.game.scene:changeState('loading', menuScene.game.client:connect())
    end

    gui:button('Host', {
            x = (love.graphics.getWidth() / 2) - 150, 
            y = (love.graphics.getHeight() / 2) + 140, 
            w = 300, 
            h = 50
        },
        group
    )
    
    local settingsButton = gui:button('Settings', {
            x = (love.graphics.getWidth() / 2) - 150, 
            y = (love.graphics.getHeight() / 2) + 240, 
            w = 300, 
            h = 50
        },
        group
    )

    settingsButton.click = function(this)
        menuScene:navigate('settings')
    end

    group:hide()

    return group
end