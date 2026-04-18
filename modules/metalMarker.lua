local self = {
    tag = "metalMarker",
    timer = 0,
    scale = 1,
}

function self:load(state, parent)
    self.state = state
    self.parent = parent
    Game.sprite:makeLuaSprite(self.tag, "ui/metalMarker")
    local spr = Game.sprite:tagToSprite(self.tag)
    self.spr = spr
    spr.image:setFilter("nearest", "nearest")
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

function self:update(dt)
    local x, y = Game.sprite:getProperty(self.parent.tag, "x"), Game.sprite:getProperty(self.parent.tag, "y")
    local w, h = Game.sprite:getScaledSize(self.parent.tag)

    local myW, myH = Game.sprite:getScaledSize(self.tag)

    local layers = self.state.layer.layers
    local addY = (self.state.stats.clicks * h) / layers[#layers].reach
    if addY > h - myH then
        addY = h - myH
    end

    Game.sprite:setObjectPosition(self.tag, x, y + addY)
end

function self:draw()
    Game.sprite:draw(self.tag)
end

return self