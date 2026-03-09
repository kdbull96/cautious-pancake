-- REPO
local repo = "https://raw.githubusercontent.com/kdbull96/cautious-pancake/main/Modules/"

-- MODULES
local modules = {
	"AutoCollect.lua",
	"AutoLock.lua"
}

-- GLOBAL STATES
getgenv().AutoCollect = false
getgenv().AutoLockFloor = false
getgenv().SelectedFloor = "Floor1"

-- LOAD MODULES with better error handling
local modulesLoaded = {AutoCollect = false, AutoLock = false}

for _,module in pairs(modules) do
	pcall(function()
		local success, err = pcall(function()
			loadstring(game:HttpGet(repo .. module))()
		end)
		if success then
			modulesLoaded[module:gsub(".lua", "")] = true
			print("✓ " .. module .. " loaded successfully")
		else
			warn("✗ Failed to load " .. module .. ": " .. tostring(err))
		end
	end)
end

task.wait(0.5)

-- GUI SETUP
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false
gui.Name = "KDBullsHub"

-- MAIN FRAME (Mobile-Optimized)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0.9, 0, 0, 280)  -- Bigger: 90% width, 280 height
main.Position = UDim2.new(0.05, 0, 0.1, 0)  -- Centered with padding
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Name = "MainFrame"

-- TITLE BAR
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.TextColor3 = Color3.new(1, 1, 1)
title.Text = "KDBULLS HUB - Aura Farms"
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.BorderSizePixel = 0

-- STATUS LABEL
local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(1, 0, 0, 25)
status.Position = UDim2.new(0, 0, 0.12, 0)
status.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
status.TextColor3 = Color3.new(0, 1, 0)
status.Text = "✓ Modules Loaded"
status.TextSize = 12
status.Font = Enum.Font.Gotham
status.BorderSizePixel = 0

-- Check module status
if not (modulesLoaded.AutoCollect and modulesLoaded.AutoLock) then
	status.Text = "⚠ Warning: Check console for errors"
	status.TextColor3 = Color3.new(1, 1, 0)
end

-- HIDE BUTTON
local hide = Instance.new("TextButton", main)
hide.Size = UDim2.new(0, 35, 0, 35)
hide.Position = UDim2.new(1, -35, 0, 0)
hide.Text = "−"
hide.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
hide.TextColor3 = Color3.new(1, 1, 1)
hide.TextSize = 18
hide.Font = Enum.Font.GothamBold
hide.BorderSizePixel = 0
hide.Name = "HideBtn"

-- BUBBLE BUTTON (Open Menu)
local bubble = Instance.new("TextButton", gui)
bubble.Size = UDim2.new(0, 60, 0, 60)
bubble.Position = UDim2.new(0, 10, 0.5, -30)
bubble.Text = "☰"
bubble.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
bubble.TextColor3 = Color3.new(1, 1, 1)
bubble.TextSize = 24
bubble.Visible = false
bubble.Active = true
bubble.Draggable = true
bubble.BorderSizePixel = 0
bubble.Name = "MenuBubble"

-- AUTO COLLECT BUTTON (Mobile-Friendly Size)
local collect = Instance.new("TextButton", main)
collect.Size = UDim2.new(0.85, 0, 0, 50)
collect.Position = UDim2.new(0.075, 0, 0.3, 0)
collect.Text = "Auto Collect : OFF"
collect.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
collect.TextColor3 = Color3.new(1, 1, 1)
collect.TextSize = 14
collect.Font = Enum.Font.GothamBold
collect.BorderSizePixel = 0
collect.Name = "CollectBtn"

-- Touch feedback for collect button
collect.MouseButton1Down:Connect(function()
	collect.BackgroundColor3 = Color3.fromRGB(150, 150, 150)  -- Highlight on tap
end)

collect.MouseButton1Up:Connect(function()
	getgenv().AutoCollect = not getgenv().AutoCollect

	if getgenv().AutoCollect then
		collect.Text = "Auto Collect : ON"
		collect.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
		status.Text = "✓ Auto Collect ENABLED"
		status.TextColor3 = Color3.new(0, 1, 0)
	else
		collect.Text = "Auto Collect : OFF"
		collect.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
		status.Text = "✓ Auto Collect DISABLED"
		status.TextColor3 = Color3.new(1, 1, 0)
	end
end)

-- AUTO LOCK BUTTON (Mobile-Friendly Size)
local lock = Instance.new("TextButton", main)
lock.Size = UDim2.new(0.85, 0, 0, 50)
lock.Position = UDim2.new(0.075, 0, 0.65, 0)
lock.Text = "Auto Lock Floor : OFF"
lock.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
lock.TextColor3 = Color3.new(1, 1, 1)
lock.TextSize = 14
lock.Font = Enum.Font.GothamBold
lock.BorderSizePixel = 0
lock.Name = "LockBtn"

-- Touch feedback for lock button
lock.MouseButton1Down:Connect(function()
	lock.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
end)

lock.MouseButton1Up:Connect(function()
	getgenv().AutoLockFloor = not getgenv().AutoLockFloor

	if getgenv().AutoLockFloor then
		lock.Text = "Auto Lock Floor : ON"
		lock.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
		status.Text = "✓ Auto Lock ENABLED (" .. getgenv().SelectedFloor .. ")"
		status.TextColor3 = Color3.new(0, 1, 0)
	else
		lock.Text = "Auto Lock Floor : OFF"
		lock.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
		status.Text = "✓ Auto Lock DISABLED"
		status.TextColor3 = Color3.new(1, 1, 0)
	end
end)

-- HIDE FUNCTION
hide.MouseButton1Click:Connect(function()
	main.Visible = false
	bubble.Visible = true
	status.Text = "Menu Hidden"
end)

-- OPEN AGAIN
bubble.MouseButton1Click:Connect(function()
	main.Visible = true
	bubble.Visible = false
	status.Text = "Menu Opened"
end)

print("✓ KDBulls Hub loaded successfully!")
