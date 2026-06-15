--[[
    DEVLABS - TOUCHLINE PREMIUM EDITION (MOBILE FIX V3)
    Fixed: Toggle Button Not Closing & Black Screen Content Bug
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

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Visible = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)
MainFrame.Parent = ScreenGui

-- Top Header Bar
local TopHeader = Instance.new("Frame")
TopHeader.Name = "TopHeader"
TopHeader.Size = UDim2.new(1, 0, 0, 40)
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
CloseButton.Size = UDim2.new(0, 40, 1, 0)
CloseButton.Position = UDim2.new(1, -40, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Parent = TopHeader
CloseButton.Activated:Connect(function() ScreenGui:Destroy() end)

-- Left Sidebar Navigation
local NavigationSidebar = Instance.new("Frame")
NavigationSidebar.Name = "NavigationSidebar"
NavigationSidebar.Size = UDim2.new(0, 120, 1, -40)
NavigationSidebar.Position = UDim2.new(0, 0, 0, 40)
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
DisplayContainer.Size = UDim2.new(1, -135, 1, -50)
DisplayContainer.Position = UDim2.new(0, 130, 0, 45)
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

    -- Fixed Navigation for Mobile Engine
    TabButton.Activated:Connect(function()
        for pName, pObj in pairs(PageViews) do 
            pObj.Visible = (pName == TabTitle) 
        end
        for bName, bObj in pairs(TabClickers) do
            bObj.BackgroundColor3 = (bName == TabTitle) and Colors.ComponentBg or Colors.Sidebar
            bObj.TextColor3 = (bName == TabTitle) and Colors.TextWhite or Colors.TextMuted
        end
    end)
    TabClickers[TabTitle] = TabButton
end

local ScreenTabsList =
