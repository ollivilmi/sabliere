EntityControls = Class{}

function EntityControls:init(keymap, entity)
    self.keymap = keymap
    self.entity = entity

    self.inputs = {
        falling = self.falling,
        idle = self.idle,
        jumping = self.jumping,
        moving = self.moving
    }
end

function EntityControls:update()
    self.inputs[self.entity.state](self)
end

function EntityControls:falling()
    if love.keyboard.isDown(self.keymap.left) then
        self.entity.dx = -self.entity.speed
    elseif love.keyboard.isDown(self.keymap.right) then
        self.entity.dx = self.entity.speed
    else
        self.entity.dx = 0
    end
end

function EntityControls:idle()
    if love.keyboard.isDown(self.keymap.left) or love.keyboard.isDown(self.keymap.right) then
        self.entity:changeState('moving')
    elseif love.keyboard.isDown(self.keymap.jump) then
        self.entity:changeState('jumping')
    end
end

function EntityControls:jumping()
    if love.keyboard.isDown(self.keymap.left) then
        self.entity.dx = -self.entity.speed
    elseif love.keyboard.isDown(self.keymap.right) then
        self.entity.dx = self.entity.speed
    else
        self.entity.dx = 0
    end
end

function EntityControls:moving()
    if love.keyboard.isDown(self.keymap.jump) then
        self.entity:changeState('jumping')
    
    elseif love.keyboard.isDown(self.keymap.left) then
        self.entity.dx = -self.entity.speed
    
    elseif love.keyboard.isDown(self.keymap.right) then
        self.entity.dx = self.entity.speed
    
    else
        self.entity.dx = 0
        self.entity:changeState('idle')
    end

end

