Game = require "game"

function love.load(args)
    Game:load(args)
    Game.stateManager:loadState("menu")
end

function love.keypressed(key)
    Game:keypressed(key)
end

function love.mousepressed(x, y, button, istouch, presses)
    Game:mousepressed(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
    Game:mousemoved(x, y, dx, dy, istouch)
end

function love.wheelmoved(x, y)
    Game:wheelmoved(x, y)
end

function love.mousereleased(x, y, button, istouch, presses)
    Game:mousereleased(x, y, button, istouch, presses)
end

function love.update(dt)
    Game:update(dt)
end

function love.draw()
    Game:draw()
end