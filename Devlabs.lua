--[[
    DEVLABS - TOUCHLINE PREMIUM EDITION (ULTRA STABLE MOBILE)
    100% FIXED: NO MORE BLACK SCREEN, NO MORE TOGGLE FREEZE
--]]

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local SystemConfig = {
    LegReachEnabled = true,
    LegReachSize = 5.0,
    LegVisualizer = true,
    BallReachEnabled = true,
    BallReachSize = 5.0,
    BallVisualizer = true,
    AirDribbleHelper = false
}

local Colors = {
    Background = Color3.fromRGB(11, 11, 11),
    Sidebar = Color3.fromRGB(6, 6, 6),
    ComponentBg = Color3.fromRGB(18, 18, 18),
    AccentPurple = Color3.fromRGB(105, 55, 215),
    TextWhite = Color3.fromRGB(245, 245, 245),
    TextMuted = Color3.fromRGB(130, 130, 130)
}

local TargetParent = nil
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("RobloxGui") then
        TargetParent = game:GetService("CoreGui")
    else
        TargetParent = LocalPlayer:WaitForChild("PlayerGui")
    end
end)
if not TargetParent then TargetParent = LocalPlayer:WaitForChild("PlayerGui") end

if TargetParent:FindFirstChild("Phase_Touchline") then
    TargetParent:FindFirstChild("Phase_Touchline"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Phase_Touchline"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = TargetParent

-- [1] ANA PANEL (Görünürlüğü Garanti Altına Alındı)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 540, 0, 340)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -170)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Visible = true
MainFrame.ZIndex = 5
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)
MainFrame.Parent = ScreenGui

-- [2] ÜST BAR
local TopHeader = Instance.new("Frame")
TopHeader.Name = "TopHeader"
TopHeader.Size = UDim2.new(1, 0, 0, 38)
TopHeader.BackgroundColor3 = Colors.Sidebar
TopHeader.BorderSizePixel = 0
Instance.new("UICorner", TopHeader).CornerRadius = UDim.new(0, 6)
TopHeader.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "  PHASE - TOUCHLINE (STABLE MOBILE)"
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 14
TitleLabel.TextColor3 = Colors.TextWhite
TitleLabel.Size = UDim2.new(0, 300, 1, 0)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = TopHeader

-- [3] SOL MENÜ (Sadece Görsel Sabit Duracak)
local NavigationSidebar = Instance.new("Frame")
NavigationSidebar.Name = "NavigationSidebar"
NavigationSidebar.Size = UDim2.new(0, 120, 1, -38)
NavigationSidebar.Position = UDim2.new(0, 0, 0, 38)
NavigationSidebar.BackgroundColor3 = Colors.Sidebar
NavigationSidebar.BorderSizePixel = 0
NavigationSidebar.Parent = MainFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 5)
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarLayout.Parent = NavigationSidebar

local Tabs = {"Home", "Reach", "Ball", "Helpers", "Player", "Settings"}
for _, tabName in ipairs(Tabs) do
    local DummyBtn = Instance.new("TextButton")
    DummyBtn.Size = UDim2.new(0, 110, 0, 32)
    DummyBtn.BackgroundColor3 = (tabName == "Reach") and Colors.ComponentBg or Colors.Sidebar
    DummyBtn.Text = "  " .. tabName
    DummyBtn.Font = Enum.Font.SourceSans
    DummyBtn.TextSize = 13
    DummyBtn.TextColor3 = (tabName == "Reach") and Colors.TextWhite or Colors.TextMuted
    DummyBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", DummyBtn).CornerRadius = UDim.new(0, 4)
    DummyBtn.Parent = NavigationSidebar
end

-- [4] SAĞ İÇERİK ALANI (Siyah Ekranı Bitirmek İçin Tek Bir Büyük Liste Yapıldı!)
local MainContentScroll = Instance.new("ScrollingFrame")
MainContentScroll.Name = "MainContentScroll"
MainContentScroll.Size = UDim2.new(1, -135, 1, -48)
MainContentScroll.Position = UDim2.new(0, 130, 0, 43)
MainContentScroll.BackgroundTransparency = 1
MainContentScroll.BorderSizePixel = 0
MainContentScroll.CanvasSize = UDim2.new(0, 0, 0, 550)
MainContentScroll.ScrollBarThickness = 4
MainContentScroll.ScrollBarImageColor3 = Colors.AccentPurple
MainContentScroll.Visible = true
MainContentScroll.Parent = MainFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ContentLayout.Parent = MainContentScroll

-- Yardımcı Fonksiyonlar (Arayüz Elemanları İçin)
local function AddHeader(txt)
    local Lbl = Instance.new("TextLabel")
    Lbl.Text = " " .. txt:upper()
    Lbl.Font = Enum.Font.SourceSansBold
    Lbl.TextSize = 14
    Lbl.TextColor3 = Colors.AccentPurple
    Lbl.Size = UDim2.new(1, -10, 0, 25)
    Lbl.BackgroundTransparency = 1
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = MainContentScroll
end

local function AddInfo(txt)
    local Box = Instance.new("Frame")
    Box.Size = UDim2.new(1, -15, 0, 32)
    Box.BackgroundColor3 = Colors.ComponentBg
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
    Box.Parent = MainContentScroll

    local Lbl = Instance.new("TextLabel")
    Lbl.Text = "  " .. txt
    Lbl.Font = Enum.Font.SourceSans
    Lbl.TextSize = 13
    Lbl.TextColor3 = Colors.TextWhite
    Lbl.Size = UDim2.new(1, 0, 1, 0)
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.BackgroundTransparency = 1
    Lbl.Parent = Box
end

local function AddToggle(txt, configKey)
    local Box = Instance.new("Frame")
    Box.Size = UDim2.new(1, -15, 0, 36)
    Box.BackgroundColor3 = Colors.ComponentBg
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
    Box.Parent = MainContentScroll

    local Lbl = Instance.new("TextLabel")
    Lbl.Text = "  " .. txt
    Lbl.Font = Enum.Font.SourceSans
    Lbl.TextSize = 13
    Lbl.TextColor3 = Colors.TextWhite
    Lbl.Size = UDim2.new(0, 200, 1, 0)
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.BackgroundTransparency = 1
    Lbl.Parent = Box

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 40, 0, 20)
    Btn.Position = UDim2.new(1, -50, 0.5, -10)
    Btn.BackgroundColor3 = SystemConfig[configKey] and Colors.AccentPurple or Color3.fromRGB(60, 60, 60)
    Btn.Text = SystemConfig[configKey] and "ON" or "OFF"
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextSize = 11
    Btn.TextColor3 = Colors.TextWhite
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
    Btn.Parent = Box

    Btn.MouseButton1Click:Connect(function()
        SystemConfig[configKey] = not SystemConfig[configKey]
        Btn.BackgroundColor3 = SystemConfig[configKey] and Colors.AccentPurple or Color3.fromRGB(60, 60, 60)
        Btn.Text = SystemConfig[configKey] and "ON" or "OFF"
    end)
end

local function AddSlider(txt, min, max, start, configKey)
    local Box = Instance.new("Frame")
    Box.Size = UDim2.new(1, -15, 0, 45)
    Box.BackgroundColor3 = Colors.ComponentBg
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
    Box.Parent = MainContentScroll

    local Lbl = Instance.new("TextLabel")
    Lbl.Text = "  " .. txt .. " (" .. tostring(start) .. ")"
    Lbl.Font = Enum.Font.SourceSans
    Lbl.TextSize = 13
    Lbl.TextColor3 = Colors.TextWhite
    Lbl.Size = UDim2.new(1, 0, 0, 20)
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.BackgroundTransparency = 1
    Lbl.Parent = Box

    local Track = Instance.new("TextButton")
    Track.Size = UDim2.new(1, -24, 0, 4)
    Track.Position = UDim2.new(0, 12, 0, 28)
    Track.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Track.Text = ""
    Track.Parent = Box

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new((start - min) / (max - min), 0, 1, 0)
    Bar.BackgroundColor3 = Colors.AccentPurple
    Bar.BorderSizePixel = 0
    Bar.Parent = Track

    Track.MouseButton1Down:Connect(function()
        local moveConn, upConn
        local function update()
            local mousePos = UserInputService:GetMouseLocation().X
            local relPos = math.clamp((mousePos - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
            local val = math.floor((min + (relPos * (max - min))) * 10) / 10
            Bar.Size = UDim2.new(relPos, 0, 1, 0)
            Lbl.Text = "  " .. txt .. " (" .. tostring(val) .. ")"
            SystemConfig[configKey] = val
        end
        update()
        moveConn = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
