local self = {
    tag = "inventoryButton",
    timer = 0,
    scale = 1,
    triggered = false,
}

function self:load(state)
    self.state = state
    self.font = love.graphics.newFont(12)
    Game.sprite:makeLuaSprite(self.tag, "ui/bag")
    Game.sprite:setObjectScale(self.tag, 0.5, 0.48)
    Game.sprite:setObjectOrder(self.tag, 10)
    local spr = Game.sprite:tagToSprite(self.tag)
    self.spr = spr
    spr.image:setFilter("nearest", "nearest")

    local w, h = Game.sprite:getScaledSize(spr)
    local offset = 30
    Game.sprite:setObjectPosition(self.tag, Game:getWidth() - w - offset, Game:getHeight() - h - offset)
end

function self:isWithinSprite(x, y)
    local spr = self.spr
    if not spr then return end

    local w, h = Game.sprite:getScaledSize(spr)
    if x > spr.x and x < spr.x + w and
    y > spr.y and y < spr.y + h then
        return true
    else
        return false
    end
end

function self:onClick(x, y, button)
    self.triggered = not self.triggered
    if not self.triggered then
        self.state.activeSpecialWindows["inventory"] = nil
    else
        self.state.activeSpecialWindows["inventory"] = self.state.windows.inventory
    end
end

function self:mousepressed(x, y, button)
    if self:isWithinSprite(x, y) then
        self:onClick(x, y, button)
    end
end

function self:draw()
    Game.sprite:draw(self.tag)
    love.graphics.push()
    love.graphics.setFont(self.font)

    local x, y = Game.sprite:getProperty(self.tag, "x"), Game.sprite:getProperty(self.tag, "y")
    local w, h = Game.sprite:getScaledSize(self.tag)
    
    love.graphics.setColor((self.triggered and {0.5, 0.5, 0.5}) or {0, 0, 0})
    love.graphics.print(Language:get("inventoryButton"), x + w / 12, y + h)
    love.graphics.setColor(1, 1, 1)

    love.graphics.pop()
end

return self