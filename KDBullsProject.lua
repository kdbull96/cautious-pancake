local repo = "kdbull96/cautious-pancake"
local branch = "main"

local function loadFolder(path)

	local api =
	"https://api.github.com/repos/"..repo.."/contents/"..path.."?ref="..branch
	
	local data = game:HttpGet(api)
	local files = game:GetService("HttpService"):JSONDecode(data)

	for _,file in pairs(files) do
		
		if file.type == "file" and file.name:sub(-4) == ".lua" then
			
			loadstring(game:HttpGet(file.download_url))()
			
		elseif file.type == "dir" then
			
			loadFolder(path.."/"..file.name)
			
		end
		
	end
	
end

-- load semua modules
loadFolder("Modules")
