-- AUTO LOCK FLOOR MODULE

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

getgenv().AutoLockFloor = false

task.spawn(function()
	while true do
		if getgenv().AutoLockFloor then
			
			for _,base in pairs(workspace.MAP_Game.Bases:GetChildren()) do
				
				local toothpaste = base:FindFirstChild("Toothpaste")
				
				if toothpaste then
					local stand = toothpaste:FindFirstChild("StandButtons")
					
					if stand then
						local lock = stand:FindFirstChild("Lock")
						
						if lock then
							local floor = lock:FindFirstChild("Floor1")
							
							if floor and floor:IsA("BasePart") then
								firetouchinterest(root, floor, 0)
								firetouchinterest(root, floor, 1)
							end
							
						end
					end
				end
				
			end
			
		end
		
		task.wait(0.2)
	end
end)
