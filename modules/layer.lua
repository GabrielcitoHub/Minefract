local self = {
    tag = "layer",
    timer = 0,
    scale = 1,
    crater = require("modules.crater"),
    layers = require("modules.layers"),
}

function self:load(state)
    self.state = state
    Game.sprite:makeLuaSprite(self.tag, "grounds/layer0")
    local spr = Game.sprite:tagToSprite(self.tag)
    self.spr = spr
    spr.image:setFilter("nearest", "nearest")
    Game.sprite:centerObject(self.tag)

    self.crater:load(state)
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
    if self.timer > 0 then
        self.timer = self.timer - dt
        local scaleAmount = 0.05
        local scale = self.scale + scaleAmount * (self.timer * 1)

        Game.sprite:setObjectScale(self.tag, scale, scale)
        self.crater:update(dt, scale)
    else
        Game.sprite:setObjectScale(self.tag, self.scale, self.scale)
    end

    Game.sprite:centerObject(self.tag)
end

function self:updateCraterLevel()
    local index = 0
    local layer = {}
    for i, l in ipairs(self.layers) do
        index = i
        layer = l
        local reach = l.reach

        if self.state.stats.treasuresFound < reach then break end
    end

    local craterTag = self.crater.tag
    if not craterTag then return end
    Game.sprite:playFrame(craterTag, tostring(index))
    self.state.currentLayer = layer
end

function self:onClick(x, y, button)
    self.timer = 1.2
    local money = 1
    self.state:addMoney(money)
    Game.money = self.state.money

    local reputation = self.state.reputation
    local change = 0.01 * reputation
    self.state:addScore(change)
    self:updateCraterLevel()

    local change = money
    local tool = self.state.tool
    if tool then
        change = change + tool.speed
    end
    self.state.stats.clicks = self.state.stats.clicks + change
end

function self:mousepressed(x, y, button)
    if self:isWithinSprite(x, y) then
        self:onClick(x, y, button)
    end
end

function self:draw()
    Game.sprite:draw(self.tag)
    self.crater:draw()
end

return self