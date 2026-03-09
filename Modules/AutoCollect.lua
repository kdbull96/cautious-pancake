local Players = game:GetService("Players")
local player = Players.LocalPlayer

getgenv().KDBFeatures["Auto Collect"] = {
Enabled = false
}

local feature = getgenv().KDBFeatures["Auto Collect"]

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
							
							local slots = toothpaste:FindFirstChild("Slots")
							
							if slots then
								
								for _,slot in pairs(slots:GetChildren()) do
									
									local collect = slot:FindFirstChild("Recolect")
									
									if collect then
										firetouchinterest(root, collect, 0)
										firetouchinterest(root, collect, 1)
									end
									
								end
								
							end
							
						end
						
					end
					
				end
				
			end
			
		end
		
		task.wait(0.05)
		
	end

end)
