Healthbar = Class{}

local BAR_SIZE = love.graphics.getHeight() / 10

function Healthbar:init(gui, entity)
    self.gui = gui
    self.entity = entity

    self.hp = self.gui:group(nil,
        {
            x = BAR_SIZE,
            y = love.graphics.getHeight() - BAR_SIZE,   
            w = BAR_SIZE,
            h = BAR_SIZE
        }
    )
    self.hp.style.bg = {0.1,0.1,0.1,0.6}

    self.res = self.gui:group(nil,{
        x = love.graphics.getWidth() - BAR_SIZE * 2,
        y = love.graphics.getHeight() - BAR_SIZE,
        w = BAR_SIZE,
        h = BAR_SIZE,
    })
    self.res.style.bg = {0.1,0.1,0.1,0.6}

    self.gui:group(nil, {x = 0, y = 0, w = BAR_SIZE, h = BAR_SIZE}, self.hp)
    self.gui:group(nil, {x = 0, y = 0, w = BAR_SIZE, h = BAR_SIZE}, self.res)

    self.bars = {
        health = self.gui:group(nil, {x = 0, y = 0, w = BAR_SIZE, h = BAR_SIZE}, self.hp),
        resources = self.gui:group(nil, {x = 0, y = 0, w = BAR_SIZE, h = BAR_SIZE}, self.res)
    }
    
    self.bars.health.style.bg = {1,0,0,0.85}
    self.bars.resources.style.bg = {0.83,0.86,0.34,0.85}

    self.keys = {
        "health",
        "resources"
    }
end

function Healthbar:update()
    for __, key in pairs(self.keys) do
        local y = BAR_SIZE - ((self.entity[key] / 100) * BAR_SIZE)

        self.bars[key].pos.y = y
    end
end

function Healthbar:load(entity)
    self.entity = entity
end