BackgroundRendering = Class{}

-- This is a class because it can be extended to have more advanced features in
-- the future
-- (Parallax scrolling, tiles etc..)

function BackgroundRendering:init()
    self.sky = love.graphics.newImage('src/client/assets/textures/background/sky.png')
    self.sky:setWrap('repeat', 'repeat')

    self.ground = love.graphics.newImage('src/client/assets/textures/background/ground.png')
    self.ground:setWrap('repeat', 'repeat')

    self.skyQuad = love.graphics.newQuad(0, 0, 5000, 500, self.sky:getWidth(), self.sky:getHeight())
    self.groundQuad = love.graphics.newQuad(0, 0, 5000, 5000, self.ground:getWidth(), self.ground:getHeight())
end

function BackgroundRendering:update(dt)

end

function BackgroundRendering:render()
    love.graphics.draw(self.sky, self.skyQuad, 0, 0)
    love.graphics.draw(self.ground, self.groundQuad, 0, 500)
end
