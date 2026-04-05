-- ❌ Disable popup remote
local remote = game:GetService("ReplicatedStorage")
    :WaitForChild("Remotes")
    :WaitForChild("Effects")
    :WaitForChild("ShowCashPopUp")

for _, v in pairs(getconnections(remote.OnClientEvent)) do
    v:Disable()
end

-- ❌ Disable cash SFX
local sfx = require(game.StarterPlayer.StarterPlayerScripts.ClientControllers:WaitForChild("SFXController"))

local old = sfx.PlaySFX
sfx.PlaySFX = function(name, ...)
    if tostring(name):lower():find("cash") then
        return
    end
    return old(name, ...)
end
