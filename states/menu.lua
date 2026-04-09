local self = {}

function self:load()
    self.font = love.graphics.newFont(32)
    love.graphics.setFont(self.font)
    -- self.menu = Game.sprite:makeLuaSprite("menu", "menu")
    self.logo = Game.sprite:makeLuaSprite("logo", "logos/gamelogo")

    -- Game.sprite:centerObject(self.menu)
    -- Game.sprite:moveObject(self.menu, nil, -200)
    Game.sprite:centerObject(self.logo)
    Game.sprite:moveObject(self.logo, nil, -300)
end

function self:update(dt)
end

function self:draw()
    love.graphics.printf("Press any key to continue!", 0, Game:getHeight() - 200, Game:getWidth(), "center")
end

function self:keypressed(key)
    Game.stateManager:loadState("gameplay")
end

return self