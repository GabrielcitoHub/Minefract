local stateManager = {}
stateManager.state = {}
stateManager.stateFunctions = {}
stateManager.supportedFunctions = {"load", "keypressed", "mousepressed", "mousemoved", "wheelmoved", "mousereleased", "update", "draw"}
stateManager.lastState = {}

function stateManager:loadStateLocal(state, extra)
    extra = extra or nil
    package.loaded["states." .. state] = nil
    self.state = require("states." .. state)
    self.state.name = state
    self.stateFunctions = {}
    
    if self.laststate and Game.debug then
        package.loaded["states." .. self.laststate.name] = nil
    end

    -- Load functions
    for _,funcName in pairs(self.supportedFunctions) do
        if self.state[funcName] then
            self.stateFunctions[funcName] = true
        end
    end

    -- Call module load function
    if self.load then
        self:load(self.state)
    end

    -- Call state load function
    if self.stateFunctions.load then
        self.state:load(extra)
    end
end

-- function safeStateCall(funcName) -- Only use IF EXTREMELY NECCESARY, IT LAGS REALLY BAD
--     if stateManager.state[funcName] ~= nil then
--         stateManager.state[funcName]()
--     end
-- end

-- Loads a state into the state manager
---@param newstate string
function stateManager:loadState(newstate, extra)
    self:loadStateLocal(newstate, extra)
    self.laststate = self.state
end

function stateManager:reloadState(stateName)
    self:loadStateLocal(stateName or self.state.name)
end

function stateManager:keypressed(key)
    if not self.stateFunctions.keypressed then return end
    self.state:keypressed(key)
end

function stateManager:mousepressed(x, y, button, istouch, presses)
    if not self.stateFunctions.mousepressed then return end
    self.state:mousepressed(x, y, button, istouch, presses)
end

function stateManager:mousemoved(x, y, dx, dy, istouch)
    if not self.stateFunctions.mousemoved then return end
    self.state:mousemoved(x, y, dx, dy, istouch)
end

function stateManager:wheelmoved(x, y)
    if not self.stateFunctions.wheelmoved then return end
    self.state:wheelmoved(x, y)
end

function stateManager:mousereleased(x, y, button, istouch, presses)
    if not self.stateFunctions.mousereleased then return end
    self.state:mousereleased(x, y, button, istouch, presses)
end

function stateManager:update(dt)
    if not self.stateFunctions.update then return end
    self.state:update(dt)
end

function stateManager:draw()
    if Game.debug then
        if self.state.id then
            love.graphics.print("state.id." .. self.state.id, 0, 20)
        end
    end
    if not self.stateFunctions.draw then return end
    self.state:draw()
end

return stateManager