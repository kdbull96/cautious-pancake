-- [ GEMINI HUB - ULTIMATE COMPLETE EDITION ] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local HubName = "GeminiHub_Ultimate_Full"

-- 1. Anti-Duplication
if CoreGui:FindFirstChild(HubName) then CoreGui[HubName]:Destroy() end
if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild(HubName) then LocalPlayer.PlayerGui[HubName]:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = HubName
local success = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- === DRAG FUNCTION ===
local function MakeDraggable(dragPoint, frameToMove)
    local dragging, dragInput, dragStart, startPos
    dragPoint.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frameToMove.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    dragPoint.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then 
            dragInput = input 
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frameToMove.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- === MOBILE TOGGLE BUTTON (Draggable) ===
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 15, 0.5, -25)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 245) -- Very Light Gray
ToggleBtn.TextColor3 = Color3.fromRGB(50, 50, 50) -- Dark Gray Text
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.TextSize = 26
ToggleBtn.Text = "G"
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(180, 180, 180) -- Gray Stroke
ToggleStroke.Thickness = 2
ToggleStroke.Parent = ToggleBtn

MakeDraggable(ToggleBtn, ToggleBtn)

-- === MAIN FRAME ===
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 260)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(250, 250, 250) -- White/Gray Main Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(200, 200, 200)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(235, 235, 235) -- Gray Header
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
MakeDraggable(TopBar, MainFrame)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(50, 50, 50) -- Dark Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Text = "Gemini Hub Clean"
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Open/Close Animation Logic
local isGuiOpen = false
ToggleBtn.MouseButton1Click:Connect(function()
    isGuiOpen = not isGuiOpen
    if isGuiOpen then
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 420, 0, 260),
            Position = UDim2.new(0.5, -210, 0.5, -130)
        }):Play()
    else
        local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        closeTween:Play()
        closeTween.Completed:Wait()
        MainFrame.Visible = false
    end
end)

-- === TAB SYSTEM ===
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 110, 1, -30)
Sidebar.Position = UDim2.new(0, 0, 0, 30)
Sidebar.BackgroundColor3 = Color3.fromRGB(235, 235, 235) -- Gray Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Parent = Sidebar

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -110, 1, -30)
ContentArea.Position = UDim2.new(0, 110, 0, 30)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local Tabs = {}
local Pages = {}

local function CreateTab(tabName)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 35)
    TabBtn.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
    TabBtn.TextColor3 = Color3.fromRGB(130, 130, 130) -- Inactive Gray Text
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextSize = 13
    TabBtn.Text = tabName
    TabBtn.BorderSizePixel = 0
    TabBtn.Parent = Sidebar
    
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, -10, 1, -10)
    Page.Position = UDim2.new(0, 5, 0, 5)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 150) -- Gray Scrollbar
    Page.Visible = false
    Page.Parent = ContentArea
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Padding = UDim.new(0, 6)
    PageLayout.Parent = Page
    
    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y)
    end)
    
    table.insert(Tabs, TabBtn)
    table.insert(Pages, Page)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.TextColor3 = Color3.fromRGB(130, 130, 130) end
        for _, p in pairs(Pages) do p.Visible = false end
        TabBtn.TextColor3 = Color3.fromRGB(30, 30, 30) -- Active Black Text
        Page.Visible = true
    end)
    
    return Page
end

-- === UI COMPONENT FUNCTIONS ===
local function CreateToggle(page, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Text = "  " .. text
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    local Status = Instance.new("Frame")
    Status.Size = UDim2.new(0, 10, 0, 10)
    Status.Position = UDim2.new(1, -20, 0.5, -5)
    Status.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    Status.Parent = btn
    Instance.new("UICorner", Status).CornerRadius = UDim.new(1, 0)

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        Status.BackgroundColor3 = enabled and Color3.fromRGB(85, 255, 85) or Color3.fromRGB(255, 60, 60)
        callback(enabled)
    end)
end

local function CreateSlider(page, text, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 45)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    sliderFrame.Parent = page
    Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 4)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -10, 0, 20)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(200, 200, 200)
    title.Font = Enum.Font.Gotham
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = text .. " : " .. tostring(default)
    title.Parent = sliderFrame
    
    local slideBg = Instance.new("Frame")
    slideBg.Size = UDim2.new(1, -20, 0, 8)
    slideBg.Position = UDim2.new(0, 10, 0, 28)
    slideBg.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    slideBg.Parent = sliderFrame
    Instance.new("UICorner", slideBg).CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame")
    local startWidth = (default - min) / (max - min)
    fill.Size = UDim2.new(startWidth, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    fill.Parent = slideBg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = slideBg
    
    local dragging = false
    local function updateSlider(input)
-- === UI COMPONENT FUNCTIONS ===
local function CreateToggle(page, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(240, 240, 240) -- Light Gray Button
    btn.TextColor3 = Color3.fromRGB(60, 60, 60)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Text = "  " .. text
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    local Status = Instance.new("Frame")
    Status.Size = UDim2.new(0, 10, 0, 10)
    Status.Position = UDim2.new(1, -20, 0.5, -5)
    Status.BackgroundColor3 = Color3.fromRGB(200, 200, 200) -- Default Off (Gray)
    Status.Parent = btn
    Instance.new("UICorner", Status).CornerRadius = UDim.new(1, 0)

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        Status.BackgroundColor3 = enabled and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 200, 200)
        callback(enabled)
    end)
end

local function CreateSlider(page, text, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 45)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    sliderFrame.Parent = page
    Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 4)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -10, 0, 20)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(60, 60, 60)
    title.Font = Enum.Font.Gotham
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = text .. " : " .. tostring(default)
    title.Parent = sliderFrame
    
    local slideBg = Instance.new("Frame")
    slideBg.Size = UDim2.new(1, -20, 0, 8)
    slideBg.Position = UDim2.new(0, 10, 0, 28)
    slideBg.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    slideBg.Parent = sliderFrame
    Instance.new("UICorner", slideBg).CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame")
    local startWidth = (default - min) / (max - min)
    fill.Size = UDim2.new(startWidth, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- Dark Gray fill
    fill.Parent = slideBg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = slideBg
    
    local dragging = false
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - slideBg.AbsolutePosition.X) / slideBg.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        local value = math.floor(min + ((max - min) * pos))
        title.Text = text .. " : " .. tostring(value)
        callback(value)
    end
    
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; updateSlider(input) end
    end)
    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end
    end)
end

local function CreateTextBox(page, placeholder, callback)
    local boxFrame = Instance.new("Frame")
    boxFrame.Size = UDim2.new(1, 0, 0, 35)
    boxFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    boxFrame.Parent = page
    Instance.new("UICorner", boxFrame).CornerRadius = UDim.new(0, 4)
    
    local stroke = Instance.new("UIStroke", boxFrame)
    stroke.Color = Color3.fromRGB(180, 180, 180)
    stroke.Thickness = 1

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -10, 1, 0)
    box.Position = UDim2.new(0, 5, 0, 0)
    box.BackgroundTransparency = 1
    box.TextColor3 = Color3.fromRGB(30, 30, 30)
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.PlaceholderText = placeholder
    box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    box.Text = ""
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.ClearTextOnFocus = false
    box.Parent = boxFrame

    box.FocusLost:Connect(function()
        callback(box.Text)
    end)
end

local function CreateButton(page, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(220, 220, 220) -- Gray Button
    btn.TextColor3 = Color3.fromRGB(30, 30, 30)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Text = text
    btn.Parent = page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    btn.MouseButton1Click:Connect(callback)
end

-- === BUILDING THE PAGES ===

local PlayerPage = CreateTab("Player")
local VisualsPage = CreateTab("Visuals")
local TrollPage = CreateTab("Troll")

-- Default Tab
Tabs[1].TextColor3 = Color3.fromRGB(30, 30, 30)
Pages[1].Visible = true

local function GetChar() return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() end

-- [ PLAYER TAB ] --
local currentWalkSpeed = 16
CreateSlider(PlayerPage, "WalkSpeed", 16, 250, 16, function(value)
    currentWalkSpeed = value
    local hum = GetChar():FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = currentWalkSpeed end
end)
RunService.Stepped:Connect(function()
    local hum = GetChar():FindFirstChild("Humanoid")
    if hum and hum.WalkSpeed ~= currentWalkSpeed and currentWalkSpeed ~= 16 then
        hum.WalkSpeed = currentWalkSpeed
    end
end)

local flying = false
local flySpeed = 50
local flyBodyVelocity, flyBodyGyro
CreateToggle(PlayerPage, "Fly", function(state)
    flying = state
    local char = GetChar()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    
    if flying and hrp and hum then
        hum.PlatformStand = true
        flyBodyVelocity = Instance.new("BodyVelocity", hrp)
        flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        
        flyBodyGyro = Instance.new("BodyGyro", hrp)
        flyBodyGyro.P = 9e4
        flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBodyGyro.CFrame = hrp.CFrame
        
        task.spawn(function()
            local camera = workspace.CurrentCamera
            while flying and char and hrp do
                local moveDir = hum.MoveDirection
                if moveDir.Magnitude > 0 then
                    flyBodyVelocity.Velocity = Vector3.new(moveDir.X * flySpeed, camera.CFrame.LookVector.Y * flySpeed, moveDir.Z * flySpeed)
                else
                    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
                end
                flyBodyGyro.CFrame = camera.CFrame
                task.wait()
            end
        end)
    else
        if hum then hum.PlatformStand = false end
        if flyBodyVelocity then flyBodyVelocity:Destroy() end
        if flyBodyGyro then flyBodyGyro:Destroy() end
    end
end)

CreateSlider(PlayerPage, "Fly Speed", 10, 200, 50, function(value)
    flySpeed = value
end)

local noclipConnection
CreateToggle(PlayerPage, "Noclip", function(state)
    if state then
        noclipConnection = RunService.Stepped:Connect(function()
            for _, part in pairs(GetChar():GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() end
    end
end)

-- [ VISUALS TAB ] --
local defaultAmbient = Lighting.Ambient
CreateToggle(VisualsPage, "Fullbright", function(state)
    if state then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
    else
        Lighting.Ambient = defaultAmbient
        Lighting.Brightness = 1
    end
end)

local espHighlights = {}
CreateToggle(VisualsPage, "Player ESP", function(state)
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hl = Instance.new("Highlight")
                hl.FillColor = Color3.fromRGB(138, 43, 226)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.Parent = player.Character
                table.insert(espHighlights, hl)
            end
        end
    else
        for _, hl in pairs(espHighlights) do
            if hl and hl.Parent then hl:Destroy() end
        end
        espHighlights = {}
    end
end)

local toolHighlights = {}
CreateToggle(VisualsPage, "Dropped Tool ESP", function(state)
    if state then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Tool") then
                local hl = Instance.new("Highlight")
                hl.FillColor = Color3.fromRGB(255, 255, 0) -- Yellow for items
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.Parent = obj
                table.insert(toolHighlights, hl)
            end
        end
    else
        for _, hl in pairs(toolHighlights) do
            if hl and hl.Parent then hl:Destroy() end
        end
        toolHighlights = {}
    end
end)

-- [ TROLL TAB ] --
CreateToggle(TrollPage, "Scan Inventories (Check Console)", function(state)
    if state then
        print("====== INVENTORY SCAN START ======")
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                print("🎒 [" .. plr.Name .. "] Inventory:")
                local backpack = plr:FindFirstChild("Backpack")
                local foundItems = false
                
                if backpack then
                    for _, item in pairs(backpack:GetChildren()) do
                        if item:IsA("Tool") then
                            print("   - " .. item.Name)
                            foundItems = true
                        end
                    end
                end
                
                if plr.Character then
                    local holding = plr.Character:FindFirstChildOfClass("Tool")
                    if holding then
                        print("   - " .. holding.Name .. " (HOLDING IN HAND)")
                        foundItems = true
                    end
                end
                
                if not foundItems then print("   - (Empty)") end
            end
        end
        print("====== INVENTORY SCAN END ======")
    end
end)

local currentTarget = nil
local function FindPlayer(nameString)
    if nameString == "" then return nil end
    local lowerName = string.lower(nameString)
    for _, p in pairs(Players:GetPlayers()) do
        if string.find(string.lower(p.Name), lowerName) or string.find(string.lower(p.DisplayName), lowerName) then
            return p
        end
    end
    return nil
end

CreateTextBox(TrollPage, "Type Target Name Here...", function(text)
    local found = FindPlayer(text)
    if found then
        currentTarget = found
        print("Target locked: " .. currentTarget.Name)
    else
        currentTarget = nil
        print("Player not found.")
    end
end)

CreateButton(TrollPage, "Teleport to Target", function()
    if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = GetChar():FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = currentTarget.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
        end
    end
end)

local sitConnection
CreateToggle(TrollPage, "Sit on Target's Head", function(state)
    if state then
        sitConnection = RunService.RenderStepped:Connect(function()
            if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("Head") then
                local hrp = GetChar():FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = currentTarget.Character.Head.CFrame * CFrame.new(0, 2, 0)
                end
            end
        end)
    else
        if sitConnection then sitConnection:Disconnect() end
    end
end)

local orbitConnection
local orbitAngle = 0
CreateToggle(TrollPage, "Orbit Target", function(state)
    if state then
        orbitConnection = RunService.RenderStepped:Connect(function()
            if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") then
                local targetHRP = currentTarget.Character.HumanoidRootPart
                local hrp = GetChar():FindFirstChild("HumanoidRootPart")
                if hrp then
                    orbitAngle = orbitAngle + 4
                    local offset = CFrame.Angles(0, math.rad(orbitAngle), 0) * CFrame.new(0, 0, 6)
                    hrp.CFrame = targetHRP.CFrame * offset
                end
            end
        end)
    else
        if orbitConnection then orbitConnection:Disconnect() end
    end
end)

local spinForce
CreateToggle(TrollPage, "Beyblade Spin", function(state)
    local hrp = GetChar():FindFirstChild("HumanoidRootPart")
    if state and hrp then
        spinForce = Instance.new("BodyAngularVelocity")
        spinForce.MaxTorque = Vector3.new(0, math.huge, 0)
        spinForce.AngularVelocity = Vector3.new(0, 100, 0) 
        spinForce.Parent = hrp
    else
        if spinForce then spinForce:Destroy() end
    end
end)

local flingConnection
CreateToggle(TrollPage, "Fling Aura", function(state)
    local char = GetChar()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if state and hrp then
        flingConnection = RunService.Stepped:Connect(function()
            if hrp then
                hrp.Velocity = Vector3.new(0, 9999, 0)
                hrp.RotVelocity = Vector3.new(9999, 9999, 9999)
            end
        end)
    else
        if flingConnection then 
            flingConnection:Disconnect() 
            if hrp then 
                hrp.Velocity = Vector3.new(0,0,0)
                hrp.RotVelocity = Vector3.new(0,0,0)
            end
        end
    end
end)
