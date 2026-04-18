local self = {
    tag = "flag",
    timer = 0,
    scale = 3,
    imagesPath = "flags",
    languagesPath = "data/languages",
    flagIndex = 1,
    flags = {},
    clicks = 0,
}

function self:loadLanguages()
    for _,f in pairs(love.filesystem.getDirectoryItems(self.languagesPath)) do
        local fname = string.sub(f, 1, -5)
        -- print(fname)
        Game.sprite:loadFrame(self.tag, fname, fname)
        table.insert(self.flags, fname)
    end
end

function self:load(state)
    self.state = state
    Game.sprite:makeLuaSprite(self.tag, self.imagesPath .. "/spanish")
    local spr = Game.sprite:tagToSprite(self.tag)
    spr.image:setFilter("nearest", "nearest")
    Game.sprite:setObjectScale(self.tag, self.scale, self.scale)
    self:updatePosition()
    self:loadLanguages()
end

function self:isWithinSprite(x, y)
    local spr = Game.sprite:tagToSprite(self.tag)
    local w, h = Game.sprite:getScaledSize(spr)

    if x > spr.x and x < spr.x + w and
    y > spr.y and y < spr.y + h then
        return true
    else
        return false
    end
end

function self:updatePosition()
    local image = Game.sprite:getProperty(self.tag, "image")
    if image then
        local spr = Game.sprite:tagToSprite(self.tag)
        spr.image:setFilter("nearest", "nearest")

        local w, h = Game.sprite:getScaledSize(spr)
        local offset = 20
        Game.sprite:setObjectPosition(self.tag, offset, Game:getHeight() - h - offset)
    end
end

function self:onClick(x, y, button)
    self.clicks = self.clicks + 1
    self.flagIndex = self.flagIndex + 1
    if self.flagIndex > #self.flags then
        self.flagIndex = 1
    end

    local flag = self.flags[self.flagIndex]
    Game.sprite:playFrame(self.tag, flag)
    self:updatePosition()
    Language:load(string.gsub(self.languagesPath, "/", ".") .. "." .. flag)

    if self.clicks == 1 then
        -- It doesn't work the first time for some reason
        self:onClick()
    end
end

function self:mousepressed(x, y, button)
    if self:isWithinSprite(x, y) then
        self:onClick(x, y, button)
    end
end

return self