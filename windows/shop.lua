local self = {
    bgColor = {0.4, 0.4, 0.5, 0.8},
    imageScale = 0.23,
    buttonStates = {},
}

function self:load(state)
    self.state = state
end

function self:update(Slab, dt)
    Slab.BeginWindow('shop', {
        Title = Language:get("shopWindow"),
        BgColor = self.bgColor,
        NoOutline = false,
    })

    local tools = self.state.shop["tools"]
    if tools then
        if #tools <= 0 then
            Slab.Text(
                Language:get("noShopItems")
            )
        else
            local imageScale = self.imageScale
            self.removeTools = {}
            local i2 = 0
            for i, tool in ipairs(tools) do
                local buttonState = self.buttonStates[i] or {}
                local image = tool.image
                local color = tool.color or {1, 1, 1, 1}
                local scaleX = imageScale * 1.3
                local scaleY = imageScale * 1.1
                Slab.Image('shopImage', {
                    Image = image,
                    ScaleX = scaleX,
                    ScaleY = scaleY,
                    Color = color,
                })

                local cursorX, cursorY = Slab.GetCursorPos()
                local w, h = image:getWidth() * scaleX, image:getHeight() * scaleY
                local x = cursorX + (w * 1.2)
                local y = cursorY - h
                Slab.SetCursorPos(x, y)
                Slab.Textf(tool.displayName or tool.name)

                Slab.SetCursorPos(x, nil)
                Slab.Textf(tool.desc or "???")

                Slab.SetCursorPos(x, nil)
                Slab.Textf("$" .. tool.price)

                local buttonOptions = {Color = {0, 0, 0, 0.2}}
                local remove = false

                Slab.SetCursorPos(x, nil)
                if Slab.Button(Language:get("buy"), buttonOptions) then
                    local money = self.state.money
                    if money >= tool.price then
                        self.state.money = money - tool.price
                        table.insert(self.state.inventory.tools, tool)
                        -- Remove this tool
                        remove = true
                    end
                end

                if remove then
                    table.insert(self.removeTools, i)
                end

                self.buttonStates[i] = buttonState
                Slab.SetCursorPos(cursorX, cursorY + (h * 1.6))
            end

            table.sort(self.removeTools, function(a, b)
                return a > b -- descending
            end)

            for _, index in ipairs(self.removeTools) do
                table.remove(self.buttonStates, index)
                table.remove(tools, index)
            end
        end
    end

	Slab.EndWindow()
end

return self