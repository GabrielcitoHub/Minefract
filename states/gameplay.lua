local self = {
    layer = require("modules.layer"),
    pauseButton = require("modules.pauseButton"),
    peopleBar = require("modules.bar")(),
    bossBar = require("modules.bar")(),
    bars = {},
    money = 0,
    reputation = 0,
}

self.windows = {
    treasure = require("windows.treasure"),
    pause = require("windows.pause"),
}
self.activeWindows = {}

function self:load()
    self.layer:load(self)
    self.pauseButton:load(self)

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
        bar.x = Game:getWidth() / 1.2 - offset - bar.score
        bar.y = 0 + offset / 2
    end

    -- Disable auto drawing of sprites (for layering)
    for _,spr in pairs(Game.sprite.sprites) do
        spr.noautodraw = true
    end

    Game.sprite:makeLuaSprite("cameraBorder", "ui/cameraBorder")
    Game.sprite:centerObject("cameraBorder")

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
    local voidHovered = Game.slab.IsVoidHovered()
    -- print(voidHovered)
    if voidHovered then
        self.pauseButton:mousepressed(x, y, button)
        if not self.pauseButton:isWithinSprite(x, y) then
             self.layer:mousepressed(x, y, button)
        end
    end

    if button == 3 then
        local treasureWindow = self.windows:treasure()
        table.insert(self.activeWindows, treasureWindow)
    end
end

function self:update(dt)
    -- Update bars
    for _,bar in pairs(self.bars) do
        -- print(bar)
        bar:update(dt)
    end

    -- Update layer
    self.layer:update(dt)

    -- Update windows
    local removeWindows = {}
    for i,window in ipairs(self.activeWindows) do
        function window:remove()
            table.insert(removeWindows, i)
        end
        -- print(bar)
        window:update(Game.slab, dt, i)
    end

    local i = 0
    for _,windowIndex in pairs(removeWindows) do
        table.remove(self.activeWindows, windowIndex - i)
        i = i + 1
    end
end

function self:draw()
    -- Draw sprites
    love.graphics.setColor(1,1,1,1)
    for _,spr in pairs(Game.sprite.sprites) do
        Game.sprite:draw(spr.tag)
    end

    for i,bar in ipairs(self.bars) do
        bar:draw()
    end

    self.pauseButton:draw()

    -- Draw money text
    love.graphics.setFont(Game.font)
    local offset = 40
    love.graphics.print(Language:get("moneyDisplay") .. " " .. self.money, offset, Game:getHeight() - offset)
end

return self