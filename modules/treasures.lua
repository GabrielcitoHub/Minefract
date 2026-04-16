local self = {
    treasuresPath = "data/treasures",
    treasuresImagesPath = "assets/images/treasures",
    imageExt = "png",
}

function self:load()
    self:loadTreasures()
end

function self:loadTreasures()
    self.treasures = {}
    self.indexedTreasures = {}
    local path = string.gsub(self.treasuresPath, "/", ".")

    for _,file in pairs(love.filesystem.getDirectoryItems(self.treasuresPath)) do
        print(file)
        local filename = string.sub(file, 1, -5)
        local treasure = require(path .. "." .. filename)
        print(Language:getLanguageName())
        local data = treasure[Language:getLanguageName()] or {}
        local name = data.name or "???"
        local id = data.id or filename
        local desc = data.desc or "This item has no description."
        local imagePath = self.treasuresImagesPath .. "/"
        local extPath = "." .. self.imageExt
        local imagePath1 = data.image and imagePath .. data.image
        local imagePath2 = id and imagePath .. id .. extPath

        local image
        if imagePath1 and love.filesystem.getInfo(imagePath1) then
            image = love.graphics.newImage(imagePath1)
        elseif imagePath2 and love.filesystem.getInfo(imagePath2) then
            image =love.graphics.newImage(imagePath2)
        end

        data.image = image
        print(name, desc, image)

        data.id = id
        data.name = name
        data.desc = desc

        local languagesNames = Language:getLanguageNames()
        for key,value in pairs(treasure) do
            if not languagesNames[key] then
                print(key, value)
                data[key] = value
            end
        end

        self.treasures[data.id] = data
        table.insert(self.treasures, data)
    end
end

function self:get(id)
    local treasure = self.treasures[id]
    if treasure then
        return treasure
    else
        print("No treasure found with the id: \"" .. id .. "\"")
    end
end

function self:getRandom()
    local len = #self.treasures
    if len <= 0 then
        print("There are no loaded treasures")
        return
    end

    local rngTreasure = self.treasures[love.math.random(1, len)]
    return rngTreasure
end

return self