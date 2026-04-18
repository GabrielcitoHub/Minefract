local self = {
    bgColor = {0.4, 0.4, 0.5, 0.8},
    imageScale = 0.23,
    buttonStates = {},
    buttonStates2 = {},
}

function self:load(state)
    self.state = state
end

function self:update(Slab, dt)
    Slab.BeginWindow('inventory', {
        Title = Language:get("inventoryWindow"),
        BgColor = self.bgColor,
        NoOutline = false,
    })

    local menus = {Language:get("treasures"), Language:get("tools")}
    self.selected = self.selected or menus[1]

    if Slab.BeginComboBox('selectedInventoryMenu', {Selected = self.selected}) then
        for I, V in ipairs(menus) do
            if Slab.TextSelectable(V) then
                self.selected = V
            end
        end

        Slab.EndComboBox()
    end

    if self.selected == Language:get("treasures") then
        local treasures = self.state.inventory["treasures"]
        if treasures then
            if #treasures <= 0 then
                Slab.Text(
                    Language:get("noTreasures")
                )
            else
                local imageScale = self.imageScale
                self.removeTreasures = {}
                for i, treasure in ipairs(treasures) do
                    local buttonState = self.buttonStates[i] or {}
                    local image = treasure.image
                    local color = treasure.color or {1, 1, 1, 1}
                    local scaleX = imageScale * 1.3
                    local scaleY = imageScale * 1.1
                    Slab.Image('treasureImage', {
                        Image = image,
                        ScaleX = scaleX,
                        ScaleY = scaleY,
                        Color = color,
                    })

                    local cursorX, cursorY = Slab.GetCursorPos()
                    local x = cursorX + image:getWidth() * scaleX
                    local y = cursorY - image:getHeight() * scaleY
                    Slab.SetCursorPos(x, y)
                    Slab.Textf(treasure.displayName or treasure.name)

                    Slab.SetCursorPos(x, nil)
                    Slab.Textf(treasure.desc)

                    local buttonOptions = {Color = {0, 0, 0, 0.2}}
                    Slab.SetCursorPos(x, nil)
                    if Slab.Button(Language:get("rename"), buttonOptions) then
                        for i2, _ in ipairs(treasures) do
                            if i ~= i2 then
                                local buttonState = self.buttonStates[i2]
                                buttonState.input = false
                                self.buttonStates[i2] = buttonState
                            end
                        end
                        buttonState.input = not buttonState.input
                    end

                    Slab.SameLine()
                    buttonState.paint = buttonState.paint or false
                    if Slab.Button(Language:get("paint"), buttonOptions) then
                        for i2, _ in ipairs(treasures) do
                            if i ~= i2 then
                                local buttonState = self.buttonStates[i2]
                                buttonState.paint = false
                                self.buttonStates[i2] = buttonState
                            end
                        end
                        buttonState.paint = not buttonState.paint
                    end

                    local remove = false

                    Slab.SameLine()
                    local ctrlDown = love.keyboard.isDown("lctrl")
                    if not ctrlDown then
                        if Slab.Button(Language:get("discard"), buttonOptions) then
                            -- Remove this treasure
                            remove = true
                        end
                    else
                        if Slab.Button(Language:get("discardAll"), buttonOptions) then
                            -- Remove all coincideences, including this one
                            for i3,treasure2 in ipairs(treasures) do
                                local t, t2 = treasure, treasure2
                                if t.id == t2.id and
                                t.displayName == t2.displayName and
                                t.color == t.color then
                                    table.insert(self.removeTreasures, i3)
                                end
                            end
                        end
                    end

                    local chest = treasure.chest
                    if chest then
                        local items = chest.items or 1
                        Slab.SameLine()
                        if Slab.Button(Language:get("open"), buttonOptions) then
                            remove = true
                            for _ = 1, items do
                                self.state:makeTreasureWindow()
                            end
                        end
                    end

                    local onUse = treasure.onUse
                    if onUse then
                        Slab.SameLine()
                        if Slab.Button(Language:get("use"), buttonOptions) then
                            local dontUse = onUse(treasure, self.state)
                            if not dontUse then
                                remove = true
                            end
                        end
                    end

                    if remove then
                        table.insert(self.removeTreasures, i)
                    end

                    if buttonState.paint then
                        local colorPicker = Slab.ColorPicker({Color = color})
                        local button, newColor = colorPicker.Button, colorPicker.Color
                        if button and button ~= 0 then
                            if button == 1 then
                                treasure.color = newColor
                            end

                            buttonState.paint = false
                        end
                    end

                    if buttonState.input then
                        Slab.NewLine()
                        if Slab.Input('treasureNewNameInput', {Text = treasure.displayName or treasure.name, ReturnOnText = false}) then
                            treasure.displayName = Slab.GetInputText()
                            if treasure.displayName == "" then
                                treasure.displayName = nil
                            end

                            buttonState.input = false
                        end

                        cursorY = cursorY + 25
                    end

                    self.buttonStates[i] = buttonState
                    Slab.SetCursorPos(cursorX, cursorY)
                end

                table.sort(self.removeTreasures, function(a, b)
                    return a > b -- descending
                end)

                for _, index in ipairs(self.removeTreasures) do
                    table.remove(self.buttonStates, index)
                    table.remove(treasures, index)
                end
            end
        end
    elseif self.selected == Language:get("tools") then
        local tools = self.state.inventory["tools"]
        if tools then
            if #tools <= 0 then
                Slab.Text(
                    Language:get("noTools")
                )
            else
                local imageScale = self.imageScale
                self.removeTools = {}
                for i, tool in ipairs(tools) do
                    local buttonState = self.buttonStates2[i] or {}
                    local image = tool.image
                    local color = tool.color or {1, 1, 1, 1}
                    local scaleX = imageScale * 1.3
                    local scaleY = imageScale * 1.1
                    Slab.Image('treasureImage', {
                        Image = image,
                        ScaleX = scaleX,
                        ScaleY = scaleY,
                        Color = color,
                    })

                    local cursorX, cursorY = Slab.GetCursorPos()
                    local x = cursorX + image:getWidth() * scaleX
                    local y = cursorY - image:getHeight() * scaleY
                    Slab.SetCursorPos(x, y)
                    Slab.Textf(tool.displayName or tool.name)

                    Slab.SetCursorPos(x, nil)
                    Slab.Textf(tool.desc)

                    Slab.SetCursorPos(x, nil)
                    Slab.Textf("CPS: " .. tool.speed .. " + 1")

                    local buttonOptions = {Color = {0, 0, 0, 0.2}}

                    local remove = false

                    Slab.SetCursorPos(x, nil)
                    local function trigger()
                        -- Equip/Unequip this tool
                        for i2, _ in ipairs(tools) do
                            if i ~= i2 then
                                local buttonState = self.buttonStates2[i2]
                                buttonState.equipped = false
                                self.buttonStates2[i2] = buttonState
                            end
                        end
                        buttonState.equipped = not buttonState.equipped
                    end

                    if not buttonState.equipped then
                        if Slab.Button(Language:get("equip"), buttonOptions) then
                            self.state.tool = tool
                            trigger()
                        end
                    else
                        if Slab.Button(Language:get("unequip"), buttonOptions) then
                            self.state.tool = nil
                            trigger()
                        end
                    end
                    
                    Slab.SameLine()
                    if Slab.Button(Language:get("rename"), buttonOptions) then
                        for i2, _ in ipairs(tools) do
                            if i ~= i2 then
                                local buttonState = self.buttonStates2[i2]
                                buttonState.input = false
                                self.buttonStates2[i2] = buttonState
                            end
                        end
                        buttonState.input = not buttonState.input
                    end

                    Slab.SameLine()
                    buttonState.paint = buttonState.paint or false
                    if Slab.Button(Language:get("paint"), buttonOptions) then
                        for i2, _ in ipairs(tools) do
                            if i ~= i2 then
                                local buttonState = self.buttonStates2[i2]
                                buttonState.paint = false
                                self.buttonStates2[i2] = buttonState
                            end
                        end
                        buttonState.paint = not buttonState.paint
                    end

                    local onUse = tool.onUse
                    if onUse then
                        Slab.SameLine()
                        if Slab.Button(Language:get("use"), buttonOptions) then
                            local dontUse = onUse(tool, self.state)
                            if not dontUse then
                                remove = true
                            end
                        end
                    end

                    if remove then
                        table.insert(self.removeTools, i)
                    end

                    if buttonState.paint then
                        local colorPicker = Slab.ColorPicker({Color = color})
                        local button, newColor = colorPicker.Button, colorPicker.Color
                        if button and button ~= 0 then
                            if button == 1 then
                                tool.color = newColor
                            end

                            buttonState.paint = false
                        end
                    end

                    if buttonState.input then
                        Slab.NewLine()
                        if Slab.Input('treasureNewNameInput', {Text = tool.displayName or tool.name, ReturnOnText = false}) then
                            tool.displayName = Slab.GetInputText()
                            if tool.displayName == "" then
                                tool.displayName = nil
                            end

                            buttonState.input = false
                        end

                        cursorY = cursorY + 25
                    end

                    self.buttonStates2[i] = buttonState
                    Slab.SetCursorPos(cursorX, cursorY + 30)
                end

                table.sort(self.removeTools, function(a, b)
                    return a > b -- descending
                end)

                for _, index in ipairs(self.removeTools) do
                    table.remove(self.buttonStates2, index)
                    table.remove(tools, index)
                end
            end
        end
    end

	Slab.EndWindow()
end

return self