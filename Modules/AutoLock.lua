local Players = game:GetService("Players")
local player = Players.LocalPlayer

getgenv().KDBFeatures["Auto Lock Floor"] = {
Enabled = false
}

local feature = getgenv().KDBFeatures["Auto Lock Floor"]

task.spawn(function()

	while true do
	
		if feature.Enabled then
		
			local char = player.Character
			if char then
				
				local root = char:FindFirstChild("HumanoidRootPart")
				
				if root then
					
					for _,base in pairs(workspace.MAP_Game.Bases:GetChildren()) do
						
						local toothpaste = base:FindFirstChild("Toothpaste")
						
						if toothpaste then
							
							local stand = toothpaste:FindFirstChild("StandButtons")
							
							if stand then
								
								local lock = stand:FindFirstChild("Lock")
								
								if lock then
									
									local floor = lock:FindFirstChild("Floor1")
									
									if floor then
										firetouchinterest(root, floor, 0)
										firetouchinterest(root, floor, 1)
									end
									
								end
								
							end
							
						end
						
					end
					
				end
				
			end
			
		end
		
		task.wait(0.2)
		
	end

end)
