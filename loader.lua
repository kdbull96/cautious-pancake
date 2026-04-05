local placeId = game.PlaceId

local games = {
    [110308882298123] = "UpgradeALuckyBlock"
}

local gameName = games[placeId]

if gameName then
    local url = "https://raw.githubusercontent.com/kdbull96/cautious-pancake/main/Games/" .. gameName .. ".lua?v=" .. tick()
    loadstring(game:HttpGet(url))()
else
    warn("Game not supported")
end
