return function(x, y, width, height, score, color, colors)
local self = {
    x = x or 200,
    y = y or 300,
    width = width or 5,
    height = height or 8,
    score = score or 0,
    colors = colors or {
        low = {1,0,0}, -- Rojo
        middle = {1,1,0}, -- Amarillo
        close = {1,0.6,0}, -- Naranja
        high = {0,1,0}, -- Verde
    },
    limit = 100,
    mirrored = false
}
self.color = color or self.colors.low

function self:update(dt)
    if self.score < 40% self.limit then
        self.color = self.colors.high
    elseif self.score < 60% self.limit then
        self.color = self.colors.middle
    elseif self.score < 80% self.limit then
        self.color = self.colors.close
    else
        self.color = self.colors.low
    end

    if self.score > self.limit then
        self.score = self.limit
    elseif self.score < 0 then
        self.score = 0
    end
end

function self:draw(x, y, w, h, color)
    x = x or self.x
    y = y or self.y
    w = w or self.width
    h = h or self.height
    color = self.color or color

    love.graphics.setColor(color)
    love.graphics.rectangle("fill", x, y, self.score * ((self.mirrored and -1) or 1), h)
    love.graphics.setColor(1,1,1,1)
    -- print("Bar drawn", self.score)
end

return self end