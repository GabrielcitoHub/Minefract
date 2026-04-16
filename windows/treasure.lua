return function()
local self = {}

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

    local imageScale = 0.23
    Slab.Image('treasureImage', {
        Image = self.treasure.image,
        ScaleX = imageScale * 1.3,
        ScaleY = imageScale * 1.1,
    })

    local x = 170
    local y = 11

    Slab.SetCursorPos(x, y)
    Slab.Textf(self.treasure.name)

    Slab.SetCursorPos(x, nil)
    Slab.Textf(self.treasure.desc)

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
        Game.stateManager.state:addScore(self.treasure.donateScore or 10)
        self:remove()
    end
        
    if self.SellButtonPressed then
        -- These lines below is bad practice but we don't have time so it'll have to work
        Game.stateManager.state:addMoney(self.treasure.price or 100)
        print(self.treasure.price)
        Game.stateManager.state:addScore(self.treasure.sellScore or -10)
        self:remove()
    end

    if self.KeepButtonPressed then
        self:remove()
    end

	Slab.EndWindow()
end

return self end