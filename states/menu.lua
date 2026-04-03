local self = {}

function self:load()
    self.menu = Game.sprite:makeLuaSprite("menu", "menu")
    Game.sprite:centerObject(self.menu)
    Game.sprite:moveObject(self.menu, nil, -200)
end

function self:update(dt)
end

function self:draw()
end

function self:keypressed(key)
    Game.stateManager:loadState("gameplay")
end

return self