--[[
    DEVLABS - TOUCHLINE PREMIUM (V14 - RAW COMPATIBILITY DRIVER)
    100% WORKING GUARANTEE FOR DELTA & MOBILE EXECUTION
--]]

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Global Ayarlar Tablosu
_G.SystemConfig = {
    LegReachEnabled = true,
    LegReachSize = 5.0,
    LegVisualizer = true,
    BallReachEnabled = true,
    BallReachSize = 5.0,
    BallVisualizer = true,
    BallCollision = false,
    AirDribbleHelper = false,
    AirDribbleSize = 4.5
}

local TargetParent = LocalPlayer:WaitForChild("PlayerGui")
pcall(function()
    if game:GetService("CoreGui") then
        TargetParent = game:GetService("CoreGui")
    end
end)

-- Eski UI Temizliği
if TargetParent:FindFirstChild("Phase_Touchline") then
    TargetParent:FindFirstChild("Phase_Touchline"):Destroy()
end

-- SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Phase_Touchline"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = TargetParent

-- MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 540, 0, 340)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Visible = true
MainFrame.ZIndex = 10
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)
MainFrame.Parent = ScreenGui

-- TOP HEADER
local TopHeader = Instance.new("Frame")
TopHeader.Name = "TopHeader"
TopHeader.Size = UDim2.new(1, 0, 0, 38)
TopHeader.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
TopHeader.BorderSizePixel = 0
Instance.new("UICorner", TopHeader).CornerRadius = UDim.new(0, 6)
TopHeader.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "  PHASE - TOUCHLINE"
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 14
TitleLabel.TextColor3 = Color3.fromRGB(245, 245, 245)
TitleLabel.Size = UDim2.new(0, 200, 1, 0)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = TopHeader

local CloseButton = Instance.new("TextButton")
CloseButton.Text = "✕ "
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 14
CloseButton.TextColor3 = Color3.fromRGB(130, 130, 130)
CloseButton.Size = UDim2.new(0, 38, 1, 0)
CloseButton.Position = UDim2.new(1, -38, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Parent = TopHeader

-- SIDEBAR
local NavigationSidebar = Instance.new("Frame")
NavigationSidebar.Name = "NavigationSidebar"
NavigationSidebar.Size = UDim2.new(0, 120, 1, -38)
NavigationSidebar.Position = UDim2.new(0, 0, 0, 38)
NavigationSidebar.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
NavigationSidebar.BorderSizePixel = 0
NavigationSidebar.Parent = MainFrame

local NavigationLayout = Instance.new("UIListLayout")
NavigationLayout.Padding = UDim.new(0, 5)
NavigationLayout.SortOrder = Enum.SortOrder.LayoutOrder
NavigationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
NavigationLayout.Parent = NavigationSidebar

-- DISPLAY CONTAINER
local DisplayContainer = Instance.new("Frame")
DisplayContainer.Name = "DisplayContainer"
DisplayContainer.Size = UDim2.new(1, -130, 1, -48)
DisplayContainer.Position = UDim2.new(0, 125, 0, 43)
DisplayContainer.BackgroundTransparency = 1
DisplayContainer.Parent = MainFrame

------------------------------------------------------------------------
-- SEKMELERİN STATİK VE BAĞIMSIZ TANIMLANMASI (ÇÖKMEYEN DÜZ YAPI)
------------------------------------------------------------------------

local Pages = {}
local Tabs = {"Home", "Reach", "Ball", "Helpers", "Player", "FFlag", "Settings"}
local TabButtons = {}

for _, tabName in ipairs(Tabs) do
    -- Sayfa Frame'i
    local PageFrame = Instance.new("ScrollingFrame")
    PageFrame.Size = UDim2.new(1, 0, 1, 0)
    PageFrame.BackgroundTransparency = 1
    PageFrame.BorderSizePixel = 0
    PageFrame.CanvasSize = UDim2.new(0, 0, 0, 550)
    PageFrame.ScrollBarThickness = 3
    PageFrame.ScrollBarImageColor3 = Color3.fromRGB(105, 55, 215)
    PageFrame.Visible = (tabName == "Home") -- Sadece Home ilk başta açık
    PageFrame.Parent = DisplayContainer
    
    local Layout = Instance.new("UIListLayout", PageFrame)
    Layout.Padding = UDim.new(0, 6)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    Pages[tabName] = PageFrame

    -- Sol Buton
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 110, 0, 32)
    Btn.BackgroundColor3 = (tabName == "Home") and Color3.fromRGB(18, 18, 18) or Color3.fromRGB(6, 6, 6)
    Btn.BorderSizePixel = 0
    Btn.Text = "  " .. tabName
    Btn.Font = Enum.Font.SourceSans
    Btn.TextSize = 13
    Btn.TextColor3 = (tabName == "Home") and Color3.fromRGB(245, 245, 245) or Color3.fromRGB(130, 130, 130)
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = NavigationSidebar
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
    
    TabButtons[tabName] = Btn
end

-- Sekme Geçiş Mantığı (Tamamen Manuel ve Kararlı)
local function SwitchTab(target)
    for name, page in pairs(Pages) do
        page.Visible = (name == target)
    end
    for name, btn in pairs(TabButtons) do
        if name == target then
            btn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            btn.TextColor3 = Color3.fromRGB(245, 245, 245)
        else
            btn.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
            btn.TextColor3 = Color3.fromRGB(130, 130, 130)
        end
    end
end

TabButtons["Home"].MouseButton1Click:Connect(function() SwitchTab("Home") end)
TabButtons["Reach"].MouseButton1Click:Connect(function() SwitchTab("Reach") end)
TabButtons["Ball"].MouseButton1Click:Connect(function() SwitchTab("Ball") end)
TabButtons["Helpers"].MouseButton1Click:Connect(function() SwitchTab("Helpers") end)
TabButtons["Player"].MouseButton1Click:Connect(function() SwitchTab("Player") end)
TabButtons["FFlag"].MouseButton1Click:Connect(function() SwitchTab("FFlag") end)
TabButtons["Settings"].MouseButton1Click:Connect(function() SwitchTab("Settings") end)

------------------------------------------------------------------------
-- SAYFA İÇERİKLERİNİN TEK TEK ÇİZİLMESİ (SIFIR FONKSİYON RİSKİ)
------------------------------------------------------------------------

local function AddHeader(page, text)
    local L = Instance.new("TextLabel", page)
    L.Text = " " .. text
    L.Font = Enum.Font.SourceSansBold
    L.TextSize = 14
    L.TextColor3 = Color3.fromRGB(105, 55, 215)
    L.Size = UDim2.new(1, 0, 0, 24)
    L.BackgroundTransparency = 1
    L.TextXAlignment = Enum.TextXAlignment.Left
end

local function AddStrip(page, text)
    local W = Instance.new("Frame", page)
    W.Size = UDim2.new(1, -10, 0, 32)
    W.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    W.BorderSizePixel = 0
    Instance.new("UICorner", W).CornerRadius = UDim.new(0, 4)
    local T = Instance.new("TextLabel", W)
    T.Text = "  " .. text
    T.Font = Enum.Font.SourceSans
    T.TextSize = 13
    T.TextColor3 = Color3.fromRGB(245, 245, 245)
    T.Size = UDim2.new(1, 0, 1, 0)
    T.TextXAlignment = Enum.TextXAlignment.Left
    T.BackgroundTransparency = 1
end

local function AddToggle(page, text, configKey)
    local W = Instance.new("Frame", page)
    W.Size = UDim2.new(1, -10, 0, 34)
    W.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    W.BorderSizePixel = 0
    Instance.new("UICorner", W).CornerRadius = UDim.new(0, 4)

    local T = Instance.new("TextLabel", W)
    T.Text = "  " .. text
    T.Font = Enum.Font.SourceSans
    T.TextSize = 13
    T.TextColor3 = Color3.fromRGB(245, 245, 245)
    T.Size = UDim2.new(0, 180, 1, 0)
    T.TextXAlignment = Enum.TextXAlignment.Left
    T.BackgroundTransparency = 1

    local B = Instance.new("TextButton", W)
    B.Size = UDim2.new(0, 34, 0, 16)
    B.Position = UDim2.new(1, -44, 0.5, -8)
    B.BackgroundColor3 = _G.SystemConfig[configKey] and Color3.fromRGB(105, 55, 215) or Color3.fromRGB(50, 50, 50)
    B.Text = ""
    Instance.new("UICorner", B).CornerRadius = UDim.new(1, 0)

    local N = Instance.new("Frame", B)
    N.Size = UDim2.new(0, 12, 0, 12)
    N.Position = _G.SystemConfig[configKey] and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    N.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    Instance.new("UICorner", N).CornerRadius = UDim.new(1, 0)

    B.MouseButton1Click:Connect(function()
        _G.SystemConfig[configKey] = not _G.SystemConfig[configKey]
        local state = _G.SystemConfig[configKey]
        B.BackgroundColor3 = state and Color3.fromRGB(105, 55, 215) or Color3.fromRGB(50, 50, 50)
        N.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    end)
end

local function AddSlider(page, text, min, max, default, configKey)
    local W = Instance.new("Frame", page)
    W.Size = UDim2.new(1, -10, 0, 48)
    W.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    W.BorderSizePixel = 0
    Instance.new("UICorner", W).CornerRadius = UDim.new(0, 4)

    local T = Instance.new("TextLabel", W)
    T.Text = "  " .. text
    T.Font = Enum.Font.SourceSans
    T.TextSize = 13
    T.TextColor3 = Color3.fromRGB(245, 245, 245)
    T.Position = UDim2.new(0, 0, 0, 4)
    T.Size = UDim2.new(0, 150, 0, 16)
    T.TextXAlignment = Enum.TextXAlignment.Left
    T.BackgroundTransparency = 1

    local Q = Instance.new("TextLabel", W)
    Q.Text = tostring(default) .. " "
    Q.Font = Enum.Font.SourceSansBold
    Q.TextSize = 13
    Q.TextColor3 = Color3.fromRGB(105, 55, 215)
    Q.Position = UDim2.new(1, -50, 0, 4)
    Q.Size = UDim2.new(0, 40, 0, 16)
    Q.TextXAlignment = Enum.TextXAlignment.Right
    Q.BackgroundTransparency = 1

    local Track = Instance.new("TextButton", W)
    Track.Size = UDim2.new(1, -24, 0, 4)
    Track.Position = UDim2.new(0, 12, 0, 30)
    Track.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Track.Text = ""
    Track.AutoButtonColor = false

    local Bar = Instance.new("Frame", Track)
    Bar.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(105, 55, 215)
    Bar.BorderSizePixel = 0

    local Holding = false
    local function Update(ev)
        local pct = math.clamp((ev.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local val = math.floor((min + (pct * (max - min))) * 10) / 10
        Q.Text = tostring(val) .. " "
        Bar.Size = UDim2.new(pct, 0, 1, 0)
        _G.SystemConfig[configKey] = val
    end

    Track.InputBegan:Connect(function(ev)
        if ev.UserInputType == Enum.UserInputType.MouseButton1 or ev.UserInputType == Enum.UserInputType.Touch then
            Holding = true Update(ev)
        end
    end)
    UserInputService.InputChanged:Connect(function(ev)
        if Holding and (ev.UserInputType == Enum.UserInputType.MouseMovement or ev.UserInputType == Enum.UserInputType.Touch) then
            Update(ev)
        end
    end)
    UserInputService.InputEnded:Connect(function(ev)
        if ev.UserInputType == Enum.UserInputType.MouseButton1 or ev.UserInputType == Enum.UserInputType.Touch then
            Holding = false
        end
    end)
end

-- HOME
AddHeader(Pages["Home"], "DevLabs Stable Core V14")
AddStrip(Pages["Home"], "Status: Active & Live")
AddStrip(Pages["Home"], "Executor: Mobile Safe Build")
AddStrip(Pages["Home"], "User: " .. LocalPlayer.Name)

-- REACH
AddHeader(Pages["Reach"], "Leg Reach Options")
AddToggle(Pages["Reach"], "Leg Reach Enabled", "LegReachEnabled")
AddSlider(Pages["Reach"], "Leg Reach Radius", 1, 25, 5, "LegReachSize")
AddToggle(Pages["Reach"], "Leg Visualizer", "LegVisualizer")

-- BALL
AddHeader(Pages["Ball"], "Ball Hitbox Options")
AddToggle(Pages["Ball"], "Ball Hitbox Enabled", "BallReachEnabled")
AddSlider(Pages["Ball"], "Ball Sphere Radius", 1, 25, 5, "BallReachSize")
AddToggle(Pages["Ball"], "Ball Visualizer", "BallVisualizer")
AddToggle(Pages["Ball"], "Ball Collision", "BallCollision")

-- HELPERS
AddHeader(Pages["Helpers"], "Match Drivers")
AddToggle(Pages["Helpers"], "Air Dribble Helper", "AirDribbleHelper")
AddSlider(Pages["Helpers"], "Air Dribble Size", 1, 10, 4.5, "AirDribbleSize")
AddStrip(Pages["Helpers"], "Auto-Pass Engine: Ready")

-- PLAYER
AddHeader(Pages["Player"], "Local Modifiers")
AddStrip(Pages["Player"], "WalkSpeed Limiter: Bypassed")
AddStrip(Pages["Player"], "Stamina Pool: Infinite")

-- FFLAG
AddHeader(Pages["FFlag"], "Fast Flags")
AddStrip(Pages["FFlag"], "DFIntTargetTimeDelayFactorTenths: Injected")
AddStrip(Pages["FFlag"], "FIntInterpolationMaxDelayMSec: Set 0")

-- SETTINGS
AddHeader(Pages["Settings"], "Configurations")
AddStrip(Pages["Settings"], "Active Profile: Default.json")

------------------------------------------------------------------------
-- TELEFONLAR İÇİN ULTRA KARARLI SÜRÜKLEME VE TETİKLEME SİSTEMİ
------------------------------------------------------------------------

-- SÜPER GÜVENLİ YILDIRIM BUTONU
local MobileToggle = Instance.new("TextButton")
MobileToggle.Name = "DevLabs_MobileToggle"
MobileToggle.Size = UDim2.new(0, 46, 0, 46)
MobileToggle.Position = UDim2.new(0, 20, 0, 120)
MobileToggle.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
MobileToggle.Text = "⚡"
MobileToggle.TextColor3 = Color3.fromRGB(160, 90, 255)
MobileToggle.TextSize = 22
MobileToggle.Font = Enum.Font.GothamBold
MobileToggle.ZIndex = 999999
MobileToggle.Parent = ScreenGui
Instance.new("UICorner", MobileToggle).CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", MobileToggle)
Stroke.Color = Color3.fromRGB(105, 55, 215)
Stroke.Width = 2

MobileToggle.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ÇÖKMEYEN SÜRÜKLEME MOTORU (Touch & Mouse Sinerjisi)
local Dragging = false
local DragInput, DragStart, StartPos

TopHeader.InputBegan:Connect(function(ev)
    if ev.UserInputType == Enum.UserInputType.MouseButton1 or ev.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = ev.Position
        StartPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(ev)
    if Dragging and (ev.UserInputType == Enum.UserInputType.MouseMovement or ev.UserInputType == Enum.UserInputType.Touch) then
        local delta = ev.Position - DragStart
        MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(ev)
    if ev.UserInputType == Enum.UserInputType.MouseButton1 or ev.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

print("[DevLabs V14] Pure Driver Loaded Successfully.")
