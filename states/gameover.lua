local self = {
    gotoState = "menu",
    menuButton = require("modules.menuButton"),
}

function self:load(extra)
    self.extra = extra
    self.reason = self.extra.reason
    self.menuButton:load(self)
    self.menuButton.enabled = true
end

function self.menuButton:onPressed()
    self.extra.music:stop()
end

function self:mousepressed(x, y, button)
    self.menuButton:mousepressed(x, y, button)
end

function self:draw()
    -- print(self.reason)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(Game.font)
    local text = ""
    if self.reason == 1 then
        text = Language:get("youGotFired")
    elseif self.reason == 2 then
        text = Language:get("youGotLynched")
    end

    text = text .. "\n"
    text = text .. "\n" .. Language:get("moneyGot") .. ": " .. self.extra.money
    text = text .. "\n" .. Language:get("treasuresFound") .. ": " .. self.extra.treasures
    text = text .. "\n" .. Language:get("toolsBought") .. ": " .. self.extra.tools
    text = text .. "\n" .. Language:get("playtime") .. ": " .. math.floor(self.extra.time) .. "'s"
    text = text .. "\n"
    text = text .. "\n" .. Language:get("thanksForPlaying") .. "!"

    love.graphics.printf(text, 0, Game:getHeight() / 5, Game:getWidth(), "center")
    Game.sprite:centerObject(self.menuButton.tag)
    Game.sprite:moveObject(self.menuButton.tag, nil, Game:getHeight() / 3)
    self.menuButton:draw()
end

return self