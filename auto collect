--// SERVICES
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

--// VARIABLES
local AutoCollect = false

--// GUI
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0,260,0,180)
main.Position = UDim2.new(0.35,0,0.3,0)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true
main.Parent = gui

local title = Instance.new("TextLabel")
title.Text = "AUTO FARM PANEL"
title.Size = UDim2.new(1,0,0,30)
title.BackgroundColor3 = Color3.fromRGB(40,40,40)
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = main

-- CLOSE BUTTON
local close = Instance.new("TextButton")
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-30,0,0)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(170,0,0)
close.TextColor3 = Color3.new(1,1,1)
close.Parent = main

-- HIDE BUTTON
local hide = Instance.new("TextButton")
hide.Size = UDim2.new(0,30,0,30)
hide.Position = UDim2.new(1,-60,0,0)
hide.Text = "-"
hide.BackgroundColor3 = Color3.fromRGB(70,70,70)
hide.TextColor3 = Color3.new(1,1,1)
hide.Parent = main

-- TAB BUTTONS
local farmTab = Instance.new("TextButton")
farmTab.Size = UDim2.new(0.5,0,0,25)
farmTab.Position = UDim2.new(0,0,0,30)
farmTab.Text = "Farm"
farmTab.BackgroundColor3 = Color3.fromRGB(50,50,50)
farmTab.TextColor3 = Color3.new(1,1,1)
farmTab.Parent = main

local settingsTab = Instance.new("TextButton")
settingsTab.Size = UDim2.new(0.5,0,0,25)
settingsTab.Position = UDim2.new(0.5,0,0,30)
settingsTab.Text = "Settings"
settingsTab.BackgroundColor3 = Color3.fromRGB(50,50,50)
settingsTab.TextColor3 = Color3.new(1,1,1)
settingsTab.Parent = main

-- TAB FRAMES
local farmFrame = Instance.new("Frame")
farmFrame.Size = UDim2.new(1,0,1,-55)
farmFrame.Position = UDim2.new(0,0,0,55)
farmFrame.BackgroundTransparency = 1
farmFrame.Parent = main

local settingsFrame = Instance.new("Frame")
settingsFrame.Size = farmFrame.Size
settingsFrame.Position = farmFrame.Position
settingsFrame.BackgroundTransparency = 1
settingsFrame.Visible = false
settingsFrame.Parent = main

-- AUTO COLLECT BUTTON
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0.8,0,0,40)
toggle.Position = UDim2.new(0.1,0,0.1,0)
toggle.Text = "Auto Collect : OFF"
toggle.BackgroundColor3 = Color3.fromRGB(120,0,0)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.TextSize = 18
toggle.Parent = farmFrame

-- SHOW BUTTON (WHEN HIDDEN)
local show = Instance.new("TextButton")
show.Size = UDim2.new(0,120,0,35)
show.Position = UDim2.new(0,10,0.5,0)
show.Text = "OPEN PANEL"
show.Visible = false
show.BackgroundColor3 = Color3.fromRGB(40,40,40)
show.TextColor3 = Color3.new(1,1,1)
show.Parent = gui

-- TAB SWITCH
farmTab.MouseButton1Click:Connect(function()
	farmFrame.Visible = true
	settingsFrame.Visible = false
end)

settingsTab.MouseButton1Click:Connect(function()
	farmFrame.Visible = false
	settingsFrame.Visible = true
end)

-- TOGGLE
toggle.MouseButton1Click:Connect(function()
	AutoCollect = not AutoCollect
	
	if AutoCollect then
		toggle.Text = "Auto Collect : ON"
		toggle.BackgroundColor3 = Color3.fromRGB(0,170,0)
	else
		toggle.Text = "Auto Collect : OFF"
		toggle.BackgroundColor3 = Color3.fromRGB(120,0,0)
	end
end)

-- HIDE
hide.MouseButton1Click:Connect(function()
	main.Visible = false
	show.Visible = true
end)

show.MouseButton1Click:Connect(function()
	main.Visible = true
	show.Visible = false
end)

-- CLOSE
close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- AUTO COLLECT LOOP
task.spawn(function()
	while true do
		if AutoCollect then
			for _,base in pairs(workspace.MAP_Game.Bases:GetChildren()) do
				local toothpaste = base:FindFirstChild("Toothpaste")
				if toothpaste then
					local slots = toothpaste:FindFirstChild("Slots")
					if slots then
						for _,slot in pairs(slots:GetChildren()) do
							local collect = slot:FindFirstChild("Recolect")
							if collect and collect:IsA("BasePart") then
								firetouchinterest(root, collect, 0)
								firetouchinterest(root, collect, 1)
							end
						end
					end
				end
			end
		end
		
		task.wait(0.05)
	end
end)
