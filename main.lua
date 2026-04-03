Game = require "game"

function love.load()
    Game:load()
    Game.stateManager:loadState("menu")
end

function love.keypressed(key)
    Game:keypressed(key)
end

function love.update(dt)
    Game:update(dt)
end

function love.draw()
    Game:draw()
end