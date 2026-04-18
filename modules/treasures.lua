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
        -- print(file)
        local filename = string.sub(file, 1, -5)
        local treasure = require(path .. "." .. filename)
        -- print(Language:getLanguageName())
        local data = treasure[Language:getLanguageName()] or {}
        local name = data.name or "???"
        local id = data.id or filename
        local desc = data.desc or Language:get("noTreasureDesc")
        local imagePath = self.treasuresImagesPath .. "/"
        local extPath = "." .. self.imageExt
        local tImage = treasure.image
        local image = tImage

        local imagePath1
        local imagePath2 = id and imagePath .. id .. extPath
        local imagePath3

        local acceptableImage = image and type(image) == "string"

        if acceptableImage then
            imagePath1 = imagePath .. image
            imagePath3 = imagePath .. image .. extPath
        end
        
        if acceptableImage then 
            if imagePath1 and love.filesystem.getInfo(imagePath1) then
                image = love.graphics.newImage(imagePath1)
            elseif imagePath3 and love.filesystem.getInfo(imagePath3) then
                image = love.graphics.newImage(imagePath3)
            end
        elseif imagePath2 and love.filesystem.getInfo(imagePath2) then
            image = love.graphics.newImage(imagePath2)
        end

        treasure.image = image
        treasure.price = treasure.price or 100
        treasure.donateScore = treasure.donateScore or 10
        treasure.sellScore = treasure.sellScore or -10
        -- print(name, desc, image)

        data.id = id
        data.name = name
        data.desc = desc

        local languagesNames = Language:getLanguageNames()
        for key,value in pairs(treasure) do
            if not languagesNames[key] then
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