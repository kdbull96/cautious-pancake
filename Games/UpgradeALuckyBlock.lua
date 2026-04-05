--// SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local remotes = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("LuckyBlocks")

--// STATES
local autoCollect = false
local autoUpgrade = false
local collectDelay = 0.3
local upgradeDelay = 0.5

--// ANTI AFK
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

--// 🔇 AUTO REMOVE CASH POPUP + SOUND (runs instantly)
task.spawn(function()
    -- remove popup
    local popupRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Effects"):WaitForChild("ShowCashPopUp")
    for _, v in pairs(getconnections(popupRemote.OnClientEvent)) do
        v:Disable()
    end

    -- remove sound
    local sfx = require(game.StarterPlayer.StarterPlayerScripts.ClientControllers:WaitForChild("SFXController"))
    local old = sfx.PlaySFX

    sfx.PlaySFX = function(name, ...)
        if tostring(name):lower():find("cash") then
            return
        end
        return old(name, ...)
    end
end)

--// GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "ProFarmUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 180)
frame.Position = UDim2.new(0.5, -110, 0.6, 0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Auto Farm Panel"
title.TextScaled = true
title.BackgroundColor3 = Color3.fromRGB(20,20,20)
title.TextColor3 = Color3.new(1,1,1)

-- Collapse button
local collapse = Instance.new("TextButton", frame)
collapse.Size = UDim2.new(0,30,0,30)
collapse.Position = UDim2.new(1,-30,0,0)
collapse.Text = "-"
collapse.TextScaled = true

local collapsed = false
collapse.MouseButton1Click:Connect(function()
    collapsed = not collapsed
    for _, v in pairs(frame:GetChildren()) do
        if v ~= title and v ~= collapse then
            v.Visible = not collapsed
        end
    end
    frame.Size = collapsed and UDim2.new(0,220,0,30) or UDim2.new(0,220,0,180)
end)

-- Toggle creator
local function createToggle(name, posY, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1,-20,0,30)
    btn.Position = UDim2.new(0,10,0,posY)
    btn.Text = name .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(200,50,50)
    btn.TextScaled = true

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
        callback(state)
    end)
end

-- Slider creator
local function createSlider(name, posY, min, max, default, callback)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1,-20,0,20)
    label.Position = UDim2.new(0,10,0,posY)
    label.Text = name .. ": " .. default
    label.TextScaled = true
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)

    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(1,-20,0,25)
    box.Position = UDim2.new(0,10,0,posY+20)
    box.Text = tostring(default)
    box.TextScaled = true
    box.BackgroundColor3 = Color3.fromRGB(50,50,50)

    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val then
            val = math.clamp(val, min, max)
            label.Text = name .. ": " .. val
            callback(val)
        end
    end)
end

-- Create UI
createToggle("Auto Collect", 40, function(v) autoCollect = v end)
createToggle("Auto Upgrade", 75, function(v) autoUpgrade = v end)

createSlider("Collect Delay", 110, 0.05, 2, 0.3, function(v) collectDelay = v end)
createSlider("Upgrade Delay", 140, 0.1, 3, 0.5, function(v) upgradeDelay = v end)

--// FUNCTIONS
local function doCollect()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("TouchTransmitter") then
            local part = obj.Parent
            if part and part:IsA("BasePart") then
                firetouchinterest(hrp, part, 0)
                firetouchinterest(hrp, part, 1)
            end
        end
    end
end

local function doUpgrade()
    remotes.StartUpgrade:InvokeServer(false)

    task.wait(0.2)

    pcall(function()
        remotes.TriggerUpgradeRoll:FireServer({
            priority = 100
        })
    end)

    task.wait(0.2)

    remotes.StartUpgradePhase2:FireServer()
end

--// MAIN LOOP
task.spawn(function()
    while true do
        if autoCollect then
            pcall(doCollect)
        end

        if autoUpgrade then
            pcall(doUpgrade)
        end

        task.wait(math.min(collectDelay, upgradeDelay))
    end
end)
