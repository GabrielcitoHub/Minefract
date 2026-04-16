local self = {
    defaultLanguagePath = "data.languages.español",
    languagesPath = "data/languages",
}

function self:loadLanguages()
    self.languagesNames = {}
    for _,f in pairs(love.filesystem.getDirectoryItems(self.languagesPath)) do
        local fname = string.sub(f, 1, -5)
        -- print(fname)
        self.languagesNames[fname] = fname
        table.insert(self.languagesNames, fname)
    end
end

function self:load(path)
    self.path = path or self.defaultLanguagePath
    self.name = self:fixStr(self.path:match("([^%.]+)$"))
    self.language = require(self.path)
    self.path = path
    self:loadLanguages()
end

function self:get(id)
    if id then
        return self.language[id]
    else
        return self.language
    end
end

function self:getLanguage()
    return self.language
end

function self:fixStr(str)
    local len = string.len(str)
    local fixedStr = ""
    for i = 1, len do
        local w = string.sub(str, i, i)
        if w == "ñ" then
            w = "n"
        end

        fixedStr = fixedStr .. w
    end

    return fixedStr
end

function self:getLanguageName()
    return self.name
end

function self:getLanguageNames()
    return self.languagesNames
end

return self