local self = {
    layer = require("modules.layer"),
    pauseButton = require("modules.pauseButton"),
    peopleBar = require("modules.bar")(),
    bossBar = require("modules.bar")(),
    treasures = require("modules.treasures"),
    bars = {},
    money = 0,
    reputation = 0,
    -- music = love.audio.newSource("assets/music/main_theme.mp3", "static"),
}

self.windows = {
    treasure = require("windows.treasure"),
    pause = require("windows.pause"),
}
self.activeWindows = {}

function self:load()
    if self.music then
        self.music:setLooping(true)
        self.music:play()
    end

    self.windows.pause:load(self)
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

    self.treasures:load()
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

function self:makeTreasureWindow(treasure)
    local treasureWindow = self.windows:treasure()
    treasureWindow:load(self, treasure)
    table.insert(self.activeWindows, treasureWindow)
end

function self:rollTreasures()
    for id, treasure in pairs(self.treasures.treasures) do
        if type(id) ~= "number" then
            local chance = treasure.chance or 10
            local rng = love.math.random(1, chance)
            if rng == 1 then
                return treasure
            end
        end
    end
end

function self:onClick(x, y, button)
    self.layer:mousepressed(x, y, button)
    local roll = self:rollTreasures()
    if roll then
        self:makeTreasureWindow(roll)
    end
end

function self:mousepressed(x, y, button)
    local voidHovered = Game.slab.IsVoidHovered()
    -- print(voidHovered)
    if voidHovered then
        self.pauseButton:mousepressed(x, y, button)
        if not self.pauseButton:isWithinSprite(x, y) then
            self:onClick(x, y, button)
        end
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
    local activeWindows = self.activeWindows
    for i,window in ipairs(activeWindows) do
        window.index = i
        function window:remove()
            table.insert(removeWindows, self.index)
            print(self.index)
            for _,window in pairs(activeWindows) do
                window.index = window.index - 1
            end
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