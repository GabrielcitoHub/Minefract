local self = {
    tag = "layer",
    timer = 0,
    scale = 1,
}

function self:load(state)
    self.state = state
    Game.sprite:makeLuaSprite(self.tag, "grounds/layer0")
    local spr = Game.sprite:tagToSprite(self.tag)
    spr.image:setFilter("nearest", "nearest")
    Game.sprite:centerObject(self.tag)
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

function self:update(dt)
    if self.timer > 0 then
        self.timer = self.timer - dt
        local scaleAmount = 0.05
        local scale = self.scale + scaleAmount * (self.timer * 1)

        Game.sprite:setObjectScale(self.tag, scale, scale)
    else
        Game.sprite:setObjectScale(self.tag, self.scale, self.scale)
    end

    Game.sprite:centerObject(self.tag)
end

function self:onClick(x, y, button)
    self.timer = 1.2
    self.state:addMoney(1)

    local reputation = self.state.reputation
    local change = 0.01 * reputation
    self.state:addScore(change)
end

function self:mousepressed(x, y, button)
    if self:isWithinSprite(x, y) then
        self:onClick(x, y, button)
    end
end

return self