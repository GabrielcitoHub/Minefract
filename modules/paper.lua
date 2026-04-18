local self = {
    tag = "paper",
    timer = 0,
    scale = 1,
    font = love.graphics.newFont(13),
    bigFont = love.graphics.newFont(17),
}

function self:load(state, parent)
    self.state = state
    self.parent = parent
    Game.sprite:makeLuaSprite(self.tag, "ui/paper")
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
    local w, h = Game.sprite:getScaledSize(self.spr)
    Game.sprite:setObjectPosition(self.tag, x - (w - w / 4), y + h / 16)
end

function self:draw()
    Game.sprite:draw(self.tag)
    local x, y = Game.sprite:getProperty(self.tag, "x"), Game.sprite:getProperty(self.tag, "y")
    local w, h = Game.sprite:getScaledSize(self.spr)

    love.graphics.push()
    love.graphics.setColor(0, 0, 0)

    local y = y + 40
    local r = math.rad(3)

    love.graphics.setFont(self.font)
    love.graphics.printf(Language:get("currentProfundity"), x, y, w, "center", r)

    y = y + 25

    love.graphics.setFont(self.bigFont)
    love.graphics.printf(self.state.stats.clicks .. " mts", x, y, w, "center", r)

    y = y + 35

    love.graphics.setFont(self.font)
    love.graphics.printf(Language:get("layer"), x, y, w, "center", r)

    y = y + 25

    love.graphics.setFont(self.bigFont)
    local currentLayer = self.state.currentLayer or {}
    love.graphics.printf(currentLayer.name or "???", x, y, w, "center", r)

    love.graphics.setColor(1, 1, 1)
    love.graphics.pop()
end

return self