local self = {
    tag = "layer",
    timer = 0,
}

function self:load(state)
    self.state = state
    Game.sprite:makeLuaSprite(self.tag, Game.sprite.placeholderImage)
    local spr = Game.sprite:tagToSprite(self.tag)
    spr.image:setFilter("nearest", "nearest")
    Game.sprite:centerObject(self.tag)
end

function self:isWithinSprite(x, y)
    local spr = Game.sprite:tagToSprite(self.tag)
    local sx, sy = Game.sprite:getScaledSize(spr)

    if x > spr.x and x < spr.x + sx and
    y > spr.y and y < spr.y + sy then
        return true
    else
        return false
    end
end

function self:update(dt)
    if self.timer > 0 then
        self.timer = self.timer - dt
        local sprite = Game.sprite:tagToSprite(self.tag)
        local scaleAmount = 0.1
        local scale = 1 + scaleAmount * (self.timer * 15)

        Game.sprite:setObjectScale(self.tag, scale, scale)
    else
        Game.sprite:setObjectScale(self.tag, 1, 1)
    end

    Game.sprite:centerObject(self.tag)
end

function self:onClick(x, y, button)
    self.timer = 1.2
    self.state:addMoney(1)
end

function self:mousepressed(x, y, button)
    if self:isWithinSprite(x, y) then
        self:onClick(x, y, button)
    end
end

return self