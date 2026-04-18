local self = {
    tag = "crater",
    timer = 0,
    scale = 1,
}

function self:load(state, layer)
    self.state = state
    self.layer = layer
    Game.sprite:makeLuaSprite(self.tag, "craters/1")
    
    for i = 1,5 do
        Game.sprite:loadFrame(self.tag, tostring(i), tostring(i))
    end

    local spr = Game.sprite:tagToSprite(self.tag)
    self.spr = spr
    spr.image:setFilter("nearest", "nearest")
    Game.sprite:centerObject(self.tag)
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

function self:update(dt, scale)
    scale = scale or self.scale
    Game.sprite:setObjectScale(self.tag, self.scale * scale, self.scale * scale)
    Game.sprite:centerObject(self.tag)
end

function self:draw()
    Game.sprite:draw(self.tag)
end

return self