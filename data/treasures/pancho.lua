return {
    english = {
        name = "Hot-dog",
        desc = "An ordinary hot-dog."
    },
    ["español"] = {
        name = "Pancho",
        desc = "Un pancho ordinario."
    },
    price = 10,
    chance = 1000000,
    onUse = function(self, state)
        self.displayName = self.displayName or ""
        self.displayName = self.displayName .. "ñom "
        return true
    end
}