local self = {
    peopleBar = require("modules.bar")(),
    bossBar = require("modules.bar")(),
    bars = {},
    score = 0,
    working = true,
}

function self:load()
    -- Game.sadneess = 0
    self.peopleBar.mirrored = true
    for key,color in pairs(self.peopleBar.colors) do
        print(color[1], color[2], color[3], color[4])
        color[4] = 0.5
    end
    table.insert(self.bars, self.peopleBar)
    table.insert(self.bars, self.bossBar)
    print("Gameplay state loaded!")
end

function self:keypressed(key)
    self.working = not self.working
end

function self:update(dt)
    for _,bar in pairs(self.bars) do
        -- print(bar)
        bar:update(dt)
    end
    
    local peopleBar = self.peopleBar
    local bossBar = self.bossBar
    local efficency = 5

    if self.working then
        efficency = -efficency
    end

    local peoplesHappiness = efficency

    peopleBar.score = peopleBar.score + (peoplesHappiness + love.math.random(1,100) / 1000) * dt
    bossBar.score = bossBar.score + (peoplesHappiness + love.math.random(1,100) / 1000) * dt
end

function self:draw()
    for i,bar in ipairs(self.bars) do
        bar:draw()
    end
end

return self