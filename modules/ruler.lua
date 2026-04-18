local self = {
    tag = "ruler",
    timer = 0,
    scale = 1,
    metalMarker = require("modules.metalMarker"),
    paper = require("modules.paper"),
}

function self:load(state)
    self.state = state
    Game.sprite:makeLuaSprite(self.tag, "ui/ruler")
    local spr = Game.sprite:tagToSprite(self.tag)
    self.spr = spr
    spr.image:setFilter("nearest", "nearest")

    self.paper:load(state, self)
    self.metalMarker:load(state, self)
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
    local w, h = Game.sprite:getScaledSize(self.tag)
    Game.sprite:setObjectPosition(self.tag, w * 1.65, h / 8)

    self.paper:update(dt)
    self.metalMarker:update(dt)
end

function self:drawLines()
    local x, y = Game.sprite:getProperty(self.tag, "x"), Game.sprite:getProperty(self.tag, "y")
    local w, h = Game.sprite:getScaledSize(self.tag)

    local i = 1
    local shift = 50

    local numbers = 10
    local offsetY = 36
    
    while y < h do
        -- print(i)
        love.graphics.setColor(0, 0, 0)
        local x1, x2 = x + w / 1.3, x + w / 1.1
        love.graphics.setLineWidth(3)
        love.graphics.line(x1, y + offsetY, x2, y + offsetY)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(tostring(numbers), x1 - 28, y - 8 + offsetY)

        numbers = numbers + 10
        y = y + shift
        i = i + 1
    end
    love.graphics.setColor(1, 1, 1)
end

function self:draw()
    self.paper:draw()
    Game.sprite:draw(self.tag)
    self:drawLines()
    self.metalMarker:draw()
end

return self