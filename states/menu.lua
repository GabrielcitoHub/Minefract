local self = {
    flag = require("modules.flag"),
    gotoState = "gameplay",
}

function self:load()
    self.flag:load(self)

    love.graphics.setFont(Game.font)
    -- self.menu = Game.sprite:makeLuaSprite("menu", "menu")
    self.logo = Game.sprite:makeLuaSprite("logo", "logos/gamelogo")

    -- Game.sprite:centerObject(self.menu)
    -- Game.sprite:moveObject(self.menu, nil, -200)
    Game.sprite:centerObject(self.logo)
    Game.sprite:moveObject(self.logo, nil, -300)
end

function self:onContinue()
    Game.stateManager:loadState(self.gotoState)
end

function self:mousepressed(x, y, button)
    self.flag:mousepressed(x, y, button)

    if not self.flag:isWithinSprite(x, y) then
        self:onContinue()
    end
end

function self:draw()
    love.graphics.printf(Language:get("presstoplay"), 0, Game:getHeight() - 200, Game:getWidth(), "center")
end

function self:keypressed(key)
    self:onContinue()
end

return self