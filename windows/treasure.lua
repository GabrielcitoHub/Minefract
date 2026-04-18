return function()
local self = {
    imageScale = 0.23,
}

-- Source - https://stackoverflow.com/a/641993
-- Posted by Doub, modified by community. See post 'Timeline' for change history
-- Retrieved 2026-04-11, License - CC BY-SA 3.0

function table.shallow_copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end

-- End of atribution lol

function self:load(state, treasure)
    self.state = state
    self.treasure = treasure or self.state.treasures:getRandom()
end

function self:update(Slab, dt, windows)
    Slab.BeginWindow('treasure' .. windows, {
        Title = Language:get("treasureFound"),
        BgColor = {0,0,0,0},
        NoOutline = false,
    })

    Slab.Image('treasureMenu', {
        Path = "assets/images/menus/treasure.png",
        Scale = 0.5,
    })

    Slab.SetCursorPos(41, 41)

    local imageScale = self.imageScale
    local treasure = self.treasure
    Slab.Image('treasureImage', {
        Image = treasure.image,
        ScaleX = imageScale * 1.3,
        ScaleY = imageScale * 1.1,
        Color = treasure.color or {1, 1, 1, 1},
    })

    local x = 170
    local y = 22

    Slab.SetCursorPos(x, y)
    Slab.Textf(treasure.name)

    Slab.SetCursorPos(x, nil)
    Slab.Textf(treasure.desc)

    Slab.SetCursorPos(x, nil)
    local text = "1/" .. treasure.chance .. ", " .. "$" .. treasure.price .. ", "

    if math.abs(treasure.sellScore) == treasure.donateScore then
        text = text .. Language:get("bossAndPeopleTreasurePrefer")
    elseif math.abs(treasure.sellScore) > treasure.donateScore then
        text = text .. Language:get("bossTreasurePrefer")
    else
        text = text .. Language:get("peopleTreasurePrefer")
    end

    Slab.Textf(text)

    Slab.SetCursorPos(x, 135)
    local text =  "< " .. treasure.donateScore .. ", " .. "> " .. math.abs(treasure.sellScore)
    Slab.Textf(text)

    Slab.SetCursorPos(x, nil)
    local text =  "(< " .. self.state.bars[1].score + math.abs(treasure.sellScore) .. ", " .. "> " .. self.state.bars[2].score + treasure.donateScore .. ")"
    Slab.Textf(text)

    local buttonOptions = {Color = {0, 0, 0, 0}}
    Slab.SetCursorPos(218, 92)
    if Slab.Button(Language:get("donate"), buttonOptions) then
        self.DonateButtonPressed = true
    end

    Slab.SetCursorPos(367, 92)
    if Slab.Button(Language:get("sell"), buttonOptions) then
        self.SellButtonPressed = true
    end

    Slab.SetCursorPos(292, 135)
    if Slab.Button(Language:get("keep"), buttonOptions) then
        self.KeepButtonPressed = true
    end

    if self.DonateButtonPressed then
        Game.stateManager.state:addScore(self.treasure.donateScore)
        self:remove()
    end
        
    if self.SellButtonPressed then
        -- These lines below is bad practice but we don't have time so it'll have to work
        Game.stateManager.state:addMoney(self.treasure.price)
        print(self.treasure.price)
        Game.stateManager.state:addScore(self.treasure.sellScore)
        self:remove()
    end

    if self.KeepButtonPressed then
        local treasures = self.state.inventory["treasures"]
        if treasures then
            table.insert(treasures, table.shallow_copy(self.treasure))
        end

        self:remove()
    end

	Slab.EndWindow()
end

return self end