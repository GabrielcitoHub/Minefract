return function()
local self = {}

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
        Path = "assets/images/treasures/uiiai_cat.png",
        ScaleX = imageScale * 1.3,
        ScaleY = imageScale * 1.1,
    })

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
        Game.stateManager.state:addScore(10)
        self:remove()
    end
        
    if self.SellButtonPressed then
        -- These lines below is bad practice but we don't have time so it'll have to work
        Game.stateManager.state:addMoney(100)
        Game.stateManager.state:addScore(-10)
        self:remove()
    end

    if self.KeepButtonPressed then
        self:remove()
    end

	Slab.EndWindow()
end

return self end