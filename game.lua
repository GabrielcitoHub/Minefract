local self = {}

self.font = love.graphics.newFont(32)
self.stateManager = require "libs.stateManager"
self.sprite = require "libs.sprite"
self.slab = require "libs.slab.API"

Language = require "modules.language"

function self:load(args)
    Language:load()
    self.slab.Initialize(args)

    local sprite = self.sprite
    function self.stateManager:load()
        sprite:clearSprites()
    end
end

function self:keypressed(key)
    self.stateManager:keypressed(key)
end

function self:mousepressed(x, y, button, istouch, presses)
    self.stateManager:mousepressed(x, y, button, istouch, presses)
end

function self:mousemoved(x, y, dx, dy, istouch)
    self.stateManager:mousemoved(x, y, dx, dy, istouch)
end

function self:wheelmoved(x, y)
    self.stateManager:wheelmoved(x, y)
end

function self:mousereleased(x, y, button, istouch, presses)
    self.stateManager:mousereleased(x, y, button, istouch, presses)
end

function self:update(dt)
    self.slab.Update(dt)
    self.stateManager:update(dt)
    self.sprite:update(dt)
end

function self:draw()
    self.stateManager:draw()
    self.sprite:draw(nil, true)
    self.slab.Draw()
end

-- Utils
function self:getWidth()
    return love.graphics:getWidth()
end

function self:getHeight()
    return love.graphics:getHeight()
end

return self