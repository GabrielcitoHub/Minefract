local self = {}

self.stateManager = require "libs.stateManager"
self.sprite = require "libs.sprite"

function self:load()
    local sprite = self.sprite
    function self.stateManager:load()
        sprite:clearSprites()
    end
end

function self:keypressed(key)
    self.stateManager:keypressed(key)
end

function self:update(dt)
    self.stateManager:update(dt)
    self.sprite:update(dt)
end

function self:draw()
    self.stateManager:draw()
    self.sprite:draw()
end

function self:getWidth()
    return love.graphics:getWidth()
end

function self:getHeight()
    return love.graphics:getHeight()
end

return self