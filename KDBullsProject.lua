-- MODULE LIST
local modules = {
"AutoCollect",
"AutoLock"
}

-- GLOBAL FEATURE TABLE
getgenv().KDBFeatures = {}

-- LOAD MODULES
for _,module in pairs(modules) do
	loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/kdbull96/cautious-pancake/main/Modules/"..module..".lua"
	))()
end


-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,260,0,200)
main.Position = UDim2.new(0.35,0,0.3,0)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,30)
title.Text = "KDBULLS HUB"
title.BackgroundColor3 = Color3.fromRGB(40,40,40)
title.TextColor3 = Color3.new(1,1,1)

local container = Instance.new("Frame", main)
container.Size = UDim2.new(1,0,1,-30)
container.Position = UDim2.new(0,0,0,30)
container.BackgroundTransparency = 1


-- AUTO CREATE BUTTONS
local y = 0

for name,feature in pairs(getgenv().KDBFeatures) do
	
	local btn = Instance.new("TextButton", container)
	btn.Size = UDim2.new(0.8,0,0,40)
	btn.Position = UDim2.new(0.1,0,0,y)
	btn.Text = name.." : OFF"
	btn.BackgroundColor3 = Color3.fromRGB(120,0,0)
	btn.TextColor3 = Color3.new(1,1,1)
	
	feature.Enabled = false
	
	btn.MouseButton1Click:Connect(function()
		
		feature.Enabled = not feature.Enabled
		
		if feature.Enabled then
			btn.Text = name.." : ON"
			btn.BackgroundColor3 = Color3.fromRGB(0,170,0)
		else
			btn.Text = name.." : OFF"
			btn.BackgroundColor3 = Color3.fromRGB(120,0,0)
		end
		
	end)
	
	y = y + 0.25
	
end
