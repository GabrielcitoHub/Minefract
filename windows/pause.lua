local self = {}

function self:update(Slab, dt)
    Slab.BeginWindow('pause', {
        Title = Language:get("pauseWindow"),
        BgColor = {0,0,0,0},
        NoOutline = false,
    })

    Slab.Image('pauseMenu', {
        Path = "assets/images/menus/pause.png",
        Scale = 0.5,
    })

    self.CheckColor = self.CheckButton and {1.0, 1.0, 1.0, 0.0} or {1.0, 1.0, 1.0, 1.0}
    Slab.SetCursorPos(214, 22)
    Slab.Image('soundsCheck', {Path = "assets/images/ui/checkmark.png", Color = self.CheckColor, ReturnOnClick = true})
    if Slab.IsControlClicked() then
        self.CheckButton = not self.CheckButton
    end

    self.CheckColor2 = self.CheckButton2 and {1.0, 1.0, 1.0, 0.0} or {1.0, 1.0, 1.0, 1.0}
    Slab.SetCursorPos(214, 102)
    Slab.Image('musicCheck', {Path = "assets/images/ui/checkmark.png", Color = self.CheckColor2, ReturnOnClick = true})
    if Slab.IsControlClicked() then
        self.CheckButton2 = not self.CheckButton2
    end

    Slab.SetCursorPos(55, 220)
    if Slab.Button("Close Game", {
        W = 221,
        H = 70,
        Invisible = true,
    }) then
        self.CloseButtonPressed = true
    end

    if self.CloseButtonPressed then
        love.event.quit()
    end

	Slab.EndWindow()
end

return self