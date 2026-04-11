local self = {
    defaultLanguagePath = "data.languages.español"
}

function self:load(path)
    self.language = require(path or self.defaultLanguagePath)
    self.path = path
end

function self:get(id)
    if id then
        return self.language[id]
    else
        return self.language
    end
end

return self