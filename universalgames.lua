-- [ PREMIUM UNIVERSAL EXECUTOR HUB - V3 ] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local HubName = "PremiumHub_V3"

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
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ToggleBtn.TextColor3 = Color3.fromRGB(85, 170, 255) -- Neon Blue
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.TextSize = 22
ToggleBtn.Text = "⚡"
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(85, 170, 255)
ToggleStroke.Thickness = 2
ToggleStroke.Parent = ToggleBtn

MakeDraggable(ToggleBtn, ToggleBtn) -- Makes the button drag itself!

-- === MAIN FRAME ===
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 250)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(40, 40, 50)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Top Bar (Draggable Area for Main GUI)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
MakeDraggable(TopBar, MainFrame)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(85, 170, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Text = "NEXUS HUB"
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
            Size = UDim2.new(0, 400, 0, 250),
            Position = UDim2.new(0.5, -200, 0.5, -125)
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
Sidebar.Size = UDim2.new(0, 100, 1, -30)
Sidebar.Position = UDim2.new(0, 0, 0, 30)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Parent = Sidebar

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -100, 1, -30)
ContentArea.Position = UDim2.new(0, 100, 0, 30)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local Tabs = {}
local Pages = {}

local function CreateTab(tabName)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 35)
    TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
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
    Page.ScrollBarImageColor3 = Color3.fromRGB(85, 170, 255)
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
        for _, t in pairs(Tabs) do t.TextColor3 = Color3.fromRGB(150, 150, 150) end
        for _, p in pairs(Pages) do p.Visible = false end
        TabBtn.TextColor3 = Color3.fromRGB(85, 170, 255) -- Highlight active tab
        Page.Visible = true
    end)
    
    return Page
end

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
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn
    
    local Status = Instance.new("Frame")
    Status.Size = UDim2.new(0, 10, 0, 10)
    Status.Position = UDim2.new(1, -20, 0.5, -5)
    Status.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    Status.Parent = btn
    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = Status

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        Status.BackgroundColor3 = enabled and Color3.fromRGB(85, 255, 85) or Color3.fromRGB(255, 60, 60)
        callback(enabled)
    end)
end

-- === BUILDING THE MENU ===

local PlayerPage = CreateTab("Local Player")
local VisualsPage = CreateTab("Visuals")

-- Default Tab to Open First
Tabs[1].TextColor3 = Color3.fromRGB(85, 170, 255)
Pages[1].Visible = true

local function GetChar() return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() end

-- Player Tab Features
CreateToggle(PlayerPage, "Fast WalkSpeed", function(state)
    local hum = GetChar():FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = state and 100 or 16 end
end)

local infJumpConnection
CreateToggle(PlayerPage, "Infinite Jump", function(state)
    if state then
        infJumpConnection = UserInputService.JumpRequest:Connect(function()
            local hum = GetChar():FindFirstChild("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    else
        if infJumpConnection then infJumpConnection:Disconnect() end
    end
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

-- Visuals Tab Features
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
                hl.FillColor = Color3.fromRGB(85, 170, 255)
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

-- Update ESP for newly added players
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        if #espHighlights > 0 then -- If ESP is active
            task.wait(1)
            local hl = Instance.new("Highlight")
            hl.FillColor = Color3.fromRGB(85, 170, 255)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.Parent = char
            table.insert(espHighlights, hl)
        end
    end)
end)
