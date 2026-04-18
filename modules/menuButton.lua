local self = {
    tag = "menuButton",
    timer = 0,
    scale = 1,
    triggered = false,
    enabled = false,
}

function self:load(state)
    self.state = state
    self.font = love.graphics.newFont(12)
    Game.sprite:makeLuaSprite(self.tag, "buttons/x")
    Game.sprite:setObjectScale(self.tag, 0.5, 0.48)
    Game.sprite:setObjectOrder(self.tag, 10)
    local spr = Game.sprite:tagToSprite(self.tag)
    spr.image:setFilter("nearest", "nearest")

    local w, h = Game.sprite:getScaledSize(spr)
    local offset = 30
    Game.sprite:setObjectPosition(self.tag, w - offset, h - offset)
end

function self:isWithinSprite(x, y)
    local spr = Game.sprite:tagToSprite(self.tag)
    local w, h = Game.sprite:getScaledSize(spr)

    if x > spr.x and x < spr.x + w and
    y > spr.y and y < spr.y + h then
        return true
    else
        return false
    end
end

function self:onClick(x, y, button)
    local pauseButton = self.state.pauseButton
    local inventoryButton = self.state.inventoryButton

    if pauseButton then
        pauseButton.triggered = false
    end
    
    if inventoryButton then
        inventoryButton.triggered = false
    end

    if self.onPressed then
        self:onPressed()
    end

    self.state.enabled = false
    Game.stateManager:loadState("menu")
end

function self:mousepressed(x, y, button)
    if self:isWithinSprite(x, y) and self.enabled then
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
    love.graphics.print(Language:get("menuButton"), x - w / 4, y + h)
    love.graphics.setColor(1, 1, 1)

    love.graphics.pop()
end

return self