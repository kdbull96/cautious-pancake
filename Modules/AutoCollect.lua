-- AUTO COLLECT MODULE

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

getgenv().AutoCollect = false

task.spawn(function()
	while true do
		if getgenv().AutoCollect then
			
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
