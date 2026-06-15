--[[
    DEVLABS - TOUCHLINE PREMIUM EDITION (ULTRA COMPATIBLE MOB-V4)
    Fixed: Toggle Button Overlay Bug & Persistent Black Screen
--]]

local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local SystemConfig = {
    LegReachEnabled = true,
    LegReachSize = 5.0,
    LegVisualizer = true,
    BallReachEnabled = true,
    BallReachSize = 5.0,
    BallVisualizer = true,
    BallCollision = false,
    AirDribbleHelper = false,
    AirDribbleSize = 4.5,
    AvatarStealerUser = "",
    TargetTimeDelay = "DFIntTargetTimeDelayFactorTenths",
    Interpolation = "FIntInterpolationMaxDelayMSec",
    ConfigName = ""
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

-- MOBILE TOGGLE BUTTON (Yıldırım Butonunun Katman Seviyesi En Üste Alındı)
local MobileToggleButton = Instance.new("TextButton")
MobileToggleButton.Name = "DevLabs_MobileToggle"
MobileToggleButton.Size = UDim2.new(0, 44, 0, 44)
MobileToggleButton.Position = UDim2.new(0, 20, 0, 120)
MobileToggleButton.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
MobileToggleButton.Text = "⚡"
MobileToggleButton.TextColor3 = Color3.fromRGB(160, 90, 255)
MobileToggleButton.TextSize = 20
MobileToggleButton.Font = Enum.Font.GothamBold
MobileToggleButton.ZIndex = 100 -- Menünün üzerine binmesini engellemek için en yüksek katman
MobileToggleButton.Parent = ScreenGui
Instance.new("UICorner", MobileToggleButton).CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", MobileToggleButton)
Stroke.Color = Colors.AccentPurple
Stroke.Width = 2

-- Main UI Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 540, 0, 340)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -170)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Visible = true
MainFrame.ZIndex = 1
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)
MainFrame.Parent = ScreenGui

-- Top Header Bar
local TopHeader = Instance.new("Frame")
TopHeader.Name = "TopHeader"
TopHeader.Size = UDim2.new(1, 0, 0, 38)
TopHeader.BackgroundColor3 = Colors.Sidebar
TopHeader.BorderSizePixel = 0
Instance.new("UICorner", TopHeader).CornerRadius = UDim.new(0, 6)
TopHeader.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "  PHASE - TOUCHLINE"
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 14
TitleLabel.TextColor3 = Colors.TextWhite
TitleLabel.Size = UDim2.new(0, 200, 1, 0)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = TopHeader

local CloseButton = Instance.new("TextButton")
CloseButton.Text = "✕ "
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 14
CloseButton.TextColor3 = Colors.TextMuted
CloseButton.Size = UDim2.new(0, 38, 1, 0)
CloseButton.Position = UDim2.new(1, -38, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Parent = TopHeader

-- Left Sidebar Navigation
local NavigationSidebar = Instance.new("Frame")
NavigationSidebar.Name = "NavigationSidebar"
NavigationSidebar.Size = UDim2.new(0, 120, 1, -38)
NavigationSidebar.Position = UDim2.new(0, 0, 0, 38)
NavigationSidebar.BackgroundColor3 = Colors.Sidebar
NavigationSidebar.BorderSizePixel = 0
NavigationSidebar.Parent = MainFrame

local NavigationLayout = Instance.new("UIListLayout")
NavigationLayout.Padding = UDim.new(0, 5)
NavigationLayout.SortOrder = Enum.SortOrder.LayoutOrder
NavigationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
NavigationLayout.Parent = NavigationSidebar

-- Right Content Container
local DisplayContainer = Instance.new("Frame")
DisplayContainer.Name = "DisplayContainer"
DisplayContainer.Size = UDim2.new(1, -130, 1, -48)
DisplayContainer.Position = UDim2.new(0, 125, 0, 43)
DisplayContainer.BackgroundTransparency = 1
DisplayContainer.Parent = MainFrame

local PageViews = {}
local TabClickers = {}

local function BuildTabWindow(TabTitle)
    local WindowPage = Instance.new("ScrollingFrame")
    WindowPage.Name = TabTitle .. "WindowPage"
    WindowPage.Size = UDim2.new(1, 0, 1, 0)
    WindowPage.BackgroundTransparency = 1
    WindowPage.BorderSizePixel = 0
    WindowPage.CanvasSize = UDim2.new(0, 0, 0, 450)
    WindowPage.ScrollBarThickness = 3
    WindowPage.ScrollBarImageColor3 = Colors.AccentPurple
    WindowPage.Visible = false
    WindowPage.Parent = DisplayContainer

    local WindowLayout = Instance.new("UIListLayout")
    WindowLayout.Padding = UDim.new(0, 6)
    WindowLayout.SortOrder = Enum.SortOrder.LayoutOrder
    WindowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    WindowLayout.Parent = WindowPage

    PageViews[TabTitle] = WindowPage

    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0, 110, 0, 32)
    TabButton.BackgroundColor3 = Colors.Sidebar
    TabButton.BorderSizePixel = 0
    TabButton.Text = "  " .. TabTitle
    TabButton.Font = Enum.Font.SourceSans
    TabButton.TextSize = 13
    TabButton.TextColor3 = Colors.TextMuted
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.Parent = NavigationSidebar
    Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 4)

    -- Mobile Touch Safe Navigation Fix
    TabButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            for pName, pObj in pairs(PageViews) do 
                pObj.Visible = (pName == TabTitle) 
            end
            for bName, bObj in pairs(TabClickers) do
                bObj.BackgroundColor3 = (bName == TabTitle) and Colors.ComponentBg or Colors.Sidebar
                bObj.TextColor3 = (bName == TabTitle) and Colors.TextWhite or Colors.TextMuted
            end
        end
    end)
    TabClickers[TabTitle] = TabButton
end

local ScreenTabsList = {"Home", "Reach", "Ball", "Helpers", "Player", "FFlag", "Settings"}
for _, Name in ipairs(ScreenTabsList) do BuildTabWindow(Name) end

-- Element Factories
local function CreateCategoryHeader(TargetView, HeadingText)
    local Label = Instance.new("TextLabel")
    Label.Text = " " .. HeadingText
    Label.Font = Enum.Font.SourceSansBold
    Label.TextSize = 14
    Label.TextColor3 = Colors.AccentPurple
    Label.Size = UDim2.new(1, 0, 0, 24)
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = TargetView
end

local function CreateDataDisplayStrip(TargetView, FieldText)
    local Wrapper = Instance.new("Frame")
    Wrapper.Size = UDim2.new(1, -10, 0, 32)
    Wrapper.BackgroundColor3 = Colors.ComponentBg
    Wrapper.BorderSizePixel = 0
    Instance.new("UICorner", Wrapper).CornerRadius = UDim.new(0, 4)
    Wrapper.Parent = TargetView

    local Context = Instance.new("TextLabel")
    Context.Text = "  " .. FieldText
    Context.Font = Enum.Font.SourceSans
    Context.TextSize = 13
    Context.TextColor3 = Colors.TextWhite
    Context.Size = UDim2.new(1, 0, 1, 0)
    Context.TextXAlignment = Enum.TextXAlignment.Left
    Context.BackgroundTransparency = 1
    Context.Parent = Wrapper
    return Context
end

local function CreateToggleSwitch(TargetView, ActionText, TargetKey)
    local RowWrapper = Instance.new("Frame")
    RowWrapper.Size = UDim2.new(1, -10, 0, 34)
    RowWrapper.BackgroundColor3 = Colors.ComponentBg
    RowWrapper.BorderSizePixel = 0
    Instance.new("UICorner", RowWrapper).CornerRadius = UDim.new(0, 4)
    RowWrapper.Parent = TargetView

    local DescriptiveText = Instance.new("TextLabel")
    Descriptive
