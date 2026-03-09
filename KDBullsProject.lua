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

-- LOAD MODULES
for _,module in pairs(modules) do
	pcall(function()
		loadstring(game:HttpGet(repo .. module))()
	end)
end


-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,260,0,180)
main.Position = UDim2.new(0.35,0,0.3,0)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,30)
title.Text = "KDBULLS HUB"
title.BackgroundColor3 = Color3.fromRGB(40,40,40)
title.TextColor3 = Color3.new(1,1,1)

-- HIDE BUTTON
local hide = Instance.new("TextButton", main)
hide.Size = UDim2.new(0,30,0,30)
hide.Position = UDim2.new(1,-30,0,0)
hide.Text = "-"
hide.BackgroundColor3 = Color3.fromRGB(80,80,80)
hide.TextColor3 = Color3.new(1,1,1)

-- BUBBLE BUTTON (saat hide)
local bubble = Instance.new("TextButton", gui)
bubble.Size = UDim2.new(0,120,0,40)
bubble.Position = UDim2.new(0,20,0.5,0)
bubble.Text = "OPEN HUB"
bubble.BackgroundColor3 = Color3.fromRGB(40,40,40)
bubble.TextColor3 = Color3.new(1,1,1)
bubble.Visible = false
bubble.Active = true
bubble.Draggable = true


-- AUTO COLLECT BUTTON
local collect = Instance.new("TextButton", main)
collect.Size = UDim2.new(0.8,0,0,40)
collect.Position = UDim2.new(0.1,0,0.3,0)
collect.Text = "Auto Collect : OFF"
collect.BackgroundColor3 = Color3.fromRGB(120,0,0)
collect.TextColor3 = Color3.new(1,1,1)

collect.MouseButton1Click:Connect(function()

	getgenv().AutoCollect = not getgenv().AutoCollect

	if getgenv().AutoCollect then
		collect.Text = "Auto Collect : ON"
		collect.BackgroundColor3 = Color3.fromRGB(0,170,0)
	else
		collect.Text = "Auto Collect : OFF"
		collect.BackgroundColor3 = Color3.fromRGB(120,0,0)
	end

end)


-- AUTO LOCK BUTTON
local lock = Instance.new("TextButton", main)
lock.Size = UDim2.new(0.8,0,0,40)
lock.Position = UDim2.new(0.1,0,0.6,0)
lock.Text = "Auto Lock Floor : OFF"
lock.BackgroundColor3 = Color3.fromRGB(120,0,0)
lock.TextColor3 = Color3.new(1,1,1)

lock.MouseButton1Click:Connect(function()

	getgenv().AutoLockFloor = not getgenv().AutoLockFloor

	if getgenv().AutoLockFloor then
		lock.Text = "Auto Lock Floor : ON"
		lock.BackgroundColor3 = Color3.fromRGB(0,170,0)
	else
		lock.Text = "Auto Lock Floor : OFF"
		lock.BackgroundColor3 = Color3.fromRGB(120,0,0)
	end

end)


-- HIDE FUNCTION
hide.MouseButton1Click:Connect(function()

	main.Visible = false
	bubble.Visible = true

end)


-- OPEN AGAIN
bubble.MouseButton1Click:Connect(function()

	main.Visible = true
	bubble.Visible = false

end)
