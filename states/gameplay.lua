local self = {
    layer = require("modules.layer"),
    pauseButton = require("modules.pauseButton"),
    inventoryButton = require("modules.inventoryButton"),
    shopButton = require("modules.shopButton"),
    ruler = require("modules.ruler"),
    peopleBar = require("modules.bar")(),
    bossBar = require("modules.bar")(),
    treasures = require("modules.treasures"),
    inventory = require("modules.inventory"),
    shop = require("modules.shop"),
    bars = {},
    color = {1, 1, 1, 1},
    money = Game.money or 0,
    reputation = 0,
    gameoverTimer = 0.05,
    enabled = true,
    limit = 20,
    music = love.audio.newSource("assets/music/main_theme.mp3", "static"),
}

self.windows = {
    treasure = require("windows.treasure"),
    pause = require("windows.pause"),
    inventory = require("windows.inventory"),
    shop = require("windows.shop")
}

self.stats = {
    treasuresFound = 0,
    playtime = 0,
    clicks = 0,
}

self.activeWindows = {}
self.activeSpecialWindows = {}

function self:load()
    if self.music then
        self.music:setLooping(true)
        self.music:play()
    end

    self.windows.pause:load(self)
    self.windows.inventory:load(self)
    self.windows.shop:load(self)

    self.layer:load(self)
    self.pauseButton:load(self)
    self.inventoryButton:load(self)
    self.shopButton:load(self)
    self.ruler:load(self)

    self.peopleBar.mirrored = true
    self.peopleBar.score = 50
    self.bossBar.score = 50

    for key,color in pairs(self.peopleBar.colors) do
        -- print(color[1], color[2], color[3])
        -- color[4] = 0.5
    end

    table.insert(self.bars, self.peopleBar)
    table.insert(self.bars, self.bossBar)

    local offset = 60
    for _,bar in pairs(self.bars) do
        bar.x = Game:getWidth() / 2 - bar.score / 2
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

    -- Debug
    -- self:addScore(-100)
end

function self:addScore(efficency)
    efficency = efficency or 5
    local peopleBar = self.peopleBar
    local bossBar = self.bossBar

    peopleBar.score = peopleBar.score - efficency
    bossBar.score = bossBar.score + efficency
end

function self:addMoney(money)
    local change = money
    if self.tool then
        change = change + self.tool.speed
    end

    self.money = self.money + change
end

function self:makeTreasureWindow(treasure)
    local treasureWindow = self.windows:treasure()
    treasureWindow:load(self, treasure)
    self.stats.treasuresFound = self.stats.treasuresFound + 1

    -- Here for debugging purposes
    if self.debugKeysDown then
        treasureWindow.KeepButtonPressed = true
    end

    table.insert(self.activeWindows, treasureWindow)
end

function self:rollTreasures(rollChance)
    rollChance = rollChance or 1
    for id, treasure in pairs(self.treasures.treasures) do
        if type(id) ~= "number" then
            local chance = treasure.chance or 10
            local rng = love.math.random(1, chance)
            if rng <= rollChance then
                return treasure
            end
        end
    end
end

function self:onClick(x, y, button)
    self.layer:mousepressed(x, y, button)
    
    local chance = 1
    if self.tool then
        chance = chance + self.tool.speed
    end

    local roll = self:rollTreasures(chance)
    if roll then
        self:makeTreasureWindow(roll)
    end

    -- if button == 3 then
    --     table.insert(self.activeWindows, self.windows.shop)
    -- end
end

function self:mousepressed(x, y, button)
    local voidHovered = Game.slab.IsVoidHovered()
    -- print(voidHovered)
    if voidHovered then
        self.pauseButton:mousepressed(x, y, button)
        self.inventoryButton:mousepressed(x, y, button)
        self.shopButton:mousepressed(x, y, button)
        if not self.pauseButton:isWithinSprite(x, y) and not self.inventoryButton:isWithinSprite(x, y) and not self.shopButton:isWithinSprite(x, y) then
            self:onClick(x, y, button)
        end
    end
end

function self:update(dt)
    if not self.enabled then return end
    self.stats.playtime = self.stats.playtime + dt

    self.debugKeysDown = love.keyboard.isDown("lctrl") and love.keyboard.isDown("lshift") and love.keyboard.isDown("t")
    -- Update bars
    for _,bar in pairs(self.bars) do
        -- print(bar)
        bar:update(dt)
    end

    -- Update layer
    self.layer:update(dt)
    self.ruler:update(dt)

    -- Update windows
    local removeWindows = {}
    local activeWindows = self.activeWindows
    for i,window in ipairs(activeWindows) do
        window.index = i

        function window:remove()
            table.insert(removeWindows, self.index)
            -- print(self.index)
            for _,window in pairs(activeWindows) do
                local index = window.index
                if index then
                    window.index = index - 1
                end
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

    -- Update special windows
    local activeSpecialWindows = self.activeSpecialWindows
    for key,window in pairs(activeSpecialWindows) do
        window.index = key

        -- print(bar)
        window:update(Game.slab, dt, i)
    end

    local limit = self.limit

    local peopleScore = self.peopleBar.score
    local bossScore = self.bossBar.score

    local peopleCond = peopleScore <= 0
    local bossCond = bossScore <= 0
    if peopleCond or bossCond then
        self.gameoverTimer = self.gameoverTimer + dt
        self.color = {1, 0.3, 0.3, (limit - self.gameoverTimer) / 100}
        self.music:setPitch(1 - self.gameoverTimer / 100)
    else
        self.gameoverTimer = 0
        self.color = {1, 1, 1, 1}
        self.music:setPitch(1)
    end

    if self.gameoverTimer > limit then
        self.enabled = false
        local extra = {
            reason = ((peopleCond and 1) or 2),
            money = self.money,
            treasures = self.stats.treasuresFound,
            tools = #self.inventory.tools,
            time = self.stats.playtime,
            music = self.music,
        }
        Game.stateManager:loadState("gameover", extra)
    end

    -- Debug OP key
    if self.debugKeysDown then
        for _ = 1,love.math.random(1000,10000) do
            self:onClick(love.mouse.getX(), love.mouse.getY(), 1)
        end
    end
end

function self:draw()
    if not self.enabled then return end

    -- Draw sprites
    love.graphics.setColor(self.color)
    -- for _,spr in pairs(Game.sprite.sprites) do
    --     Game.sprite:draw(spr.tag)
    -- end

    self.layer:draw()
    self.ruler:draw()

    for i,bar in ipairs(self.bars) do
        bar:draw()
    end

    self.pauseButton:draw()
    self.inventoryButton:draw()
    self.shopButton:draw()

    -- Draw money text
    love.graphics.setFont(Game.font)
    local offset = 40
    love.graphics.print(Language:get("moneyDisplay") .. " " .. self.money, offset, Game:getHeight() - offset)
end

return self