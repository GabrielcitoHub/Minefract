local self = {
    layer = require("modules.layer"),
    peopleBar = require("modules.bar")(),
    bossBar = require("modules.bar")(),
    bars = {},
    money = 0,
}

function self:load()
    self.layer:load(self)

    self.peopleBar.mirrored = true
    self.peopleBar.score = 50
    self.bossBar.score = 50

    for key,color in pairs(self.peopleBar.colors) do
        print(color[1], color[2], color[3])
        -- color[4] = 0.5
    end

    table.insert(self.bars, self.peopleBar)
    table.insert(self.bars, self.bossBar)

    local offset = 60
    for _,bar in pairs(self.bars) do
        bar.x = Game:getWidth() - offset - bar.score
        bar.y = 0 + offset / 2
    end

    print("Gameplay state loaded!")
end

function self:addScore(efficency)
    efficency = efficency or 5
    local peopleBar = self.peopleBar
    local bossBar = self.bossBar

    peopleBar.score = peopleBar.score - efficency
    bossBar.score = bossBar.score + efficency
end

function self:addMoney(money)
    self.money = self.money + money
end

function self:mousepressed(x, y, button)
    local change = 2.3

    if button == 1 then
        self:addScore(change)
    elseif button == 2 then
        self:addScore(-change)
    end

    self.layer:mousepressed(x, y, button)
end

function self:update(dt)
    for _,bar in pairs(self.bars) do
        -- print(bar)
        bar:update(dt)
    end

    self.layer:update(dt)
end

function self:draw()
    for i,bar in ipairs(self.bars) do
        bar:draw()
    end

    local offset = 40
    love.graphics.print("Money: " .. self.money, offset, Game:getHeight() - offset)
end

return self