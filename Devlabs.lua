--[=[
    DEVLABS / PHASE - TOUCHLINE Open Source
    Full GUI + Reach + Ball + Avatar Stealer
    GitHub Version - Mobile + PC
]=]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ================== CONFIG ==================
local Config = {
    LegReach = {Enabled = true, Size = 5},
    BallReach = {Enabled = true, Size = 8},
    BallMagnet = {Enabled = true, Power = 45},
    AutoKick = {Enabled = true},
    GoalAim = {Enabled = true},
    AirDribble = {Enabled = true, Size = 4.5},
}

-- ================== GUI ==================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DEVLABS_TOUCHLINE"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 540, 0, 480)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
Title.Text = "DEVLABS - TOUCHLINE"
Title.TextColor3 = Color3.fromRGB(180, 100, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Sidebar.Parent = MainFrame

local SidebarList = Instance.new("UIListLayout")
SidebarList.Padding = UDim.new(0, 5)
SidebarList.Parent = Sidebar

local tabs = {"Reach", "Ball", "Player", "Helpers"}
for _, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = tabName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = Sidebar
    btn.MouseButton1Click:Connect(function()
        print(tabName .. " sekmesi aktif")
    end)
end

-- Content Area
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -160, 1, -60)
Content.Position = UDim2.new(0, 155, 0, 55)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 6
Content.Parent = MainFrame

local ContentList = Instance.new("UIListLayout")
ContentList.Padding = UDim.new(0, 10)
ContentList.Parent = Content

local function CreateToggle(parent, name, cfgTable, key)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(1, -20, 0, 45)
    toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    toggle.Text = name .. ": " .. (cfgTable[key].Enabled and "ON" or "OFF")
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.Parent = parent
    
    toggle.MouseButton1Click:Connect(function()
        cfgTable[key].Enabled = not cfgTable[key].Enabled
        toggle.Text = name .. ": " .. (cfgTable[key].Enabled and "ON" or "OFF")
    end)
end

-- Avatar Stealer
local function CreateAvatarStealer()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 130)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.Parent = Content

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,0,30)
    label.BackgroundTransparency = 1
    label.Text = "🔥 Avatar Stealer"
    label.TextColor3 = Color3.fromRGB(180, 100, 255)
    label.TextSize = 16
    label.Font = Enum.Font.GothamBold
    label.Parent = frame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1,-20,0,35)
    box.Position = UDim2.new(0,10,0,35)
    box.PlaceholderText = "Kullanıcı adı gir..."
    box.BackgroundColor3 = Color3.fromRGB(20,20,20)
    box.TextColor3 = Color3.new(1,1,1)
    box.Parent = frame

    local stealBtn = Instance.new("TextButton")
    stealBtn.Size = UDim2.new(1,-20,0,40)
    stealBtn.Position = UDim2.new(0,10,0,75)
    stealBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
    stealBtn.Text = "STEAL AVATAR"
    stealBtn.TextColor3 = Color3.new(1,1,1)
    stealBtn.Font = Enum.Font.GothamBold
    stealBtn.Parent = frame

    stealBtn.MouseButton1Click:Connect(function()
        local targetName = box.Text
        if targetName == "" then return end
        local target = Players:FindFirstChild(targetName)
        if not target or not target.Character then
            warn("Kullanıcı bulunamadı!")
            return
        end

        local myChar = player.Character
        if not myChar then return end

        -- Temizle
        for _, v in ipairs(myChar:GetChildren()) do
            if v:IsA("Accessory") or v:IsA("Clothing") or v.Name == "Shirt" or v.Name == "Pants" then
                v:Destroy()
            end
        end

        -- Kopyala
        for _, item in ipairs(target.Character:GetChildren()) do
            if item:IsA("Accessory") or item:IsA("Clothing") then
                item:Clone().Parent = myChar
            end
        end
        if target.Character:FindFirstChild("Shirt") then target.Character.Shirt:Clone().Parent = myChar end
        if target.Character:FindFirstChild("Pants") then target.Character.Pants:Clone().Parent = myChar end

        print(targetName .. " avatarı başarıyla çalındı!")
    end)
end

CreateAvatarStealer()

CreateToggle(Content, "Leg Reach", Config, "LegReach")
CreateToggle(Content, "Ball Reach", Config, "BallReach")
CreateToggle(Content, "Ball Magnet", Config, "BallMagnet")
CreateToggle(Content, "Auto Kick", Config, "AutoKick")
CreateToggle(Content, "Goal Aim", Config, "GoalAim")
CreateToggle(Content, "Air Dribble", Config, "AirDribble")

-- Draggable
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local startPos = MainFrame.Position
        local startInput = input.Position
        local conn = UserInputService.InputChanged:Connect(function(chg)
            if chg.UserInputType == Enum.UserInputType.MouseMovement or chg.UserInputType == Enum.UserInputType.Touch then
                local delta = chg.Position - startInput
                MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(endInput)
            if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
                conn:Disconnect()
            end
        end)
    end
end)

-- ================== MAIN LOOP ==================
RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local ball = nil
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("ball") or obj.Name:lower():find("football")) then
            ball = obj
            break
        end
    end
    if not ball then return end

    local dist = (root.Position - ball.Position).Magnitude

    -- Ball Reach + Magnet
    if Config.BallReach.Enabled and dist < Config.BallReach.Size * 5 then
        if Config.BallMagnet.Enabled then
            local dir = (root.Position - ball.Position).Unit
            ball.Velocity = ball.Velocity:Lerp(dir * Config.BallMagnet.Power, 0.3)
        end
    end

    -- Auto Kick
    if Config.AutoKick.Enabled and dist < 12 then
        local cam = workspace.CurrentCamera
        ball.Velocity = cam.CFrame.LookVector * 90 + Vector3.new(0, 30, 0)
    end
end)

print("✅ DEVLABS - TOUCHLINE + Avatar Stealer yüklendi! İyi oyunlar 🔥")
