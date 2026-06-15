--[[
    DEVLABS - TOUCHLINE PREMIUM EDITION (ULTRA COMPATIBLE NO-LOOP FIXED)
    100% FIXED: Missing Tabs, Black Screen & Toggle Button Freeze
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

-- MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 540, 0, 340)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -170)
MainFrame.BackgroundColor3 = Colors.Background
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

-- SIDEBAR
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

-- DISPLAY CONTAINER
local DisplayContainer = Instance.new("Frame")
DisplayContainer.Name = "DisplayContainer"
DisplayContainer.Size = UDim2.new(1, -130, 1, -48)
DisplayContainer.Position = UDim2.new(0, 125, 0, 43)
DisplayContainer.BackgroundTransparency = 1
DisplayContainer.Parent = MainFrame

-- FACTORIES
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
    DescriptiveText.Text = "  " .. ActionText
    DescriptiveText.Font = Enum.Font.SourceSans
    DescriptiveText.TextSize = 13
    DescriptiveText.TextColor3 = Colors.TextWhite
    DescriptiveText.Size = UDim2.new(0, 180, 1, 0)
    DescriptiveText.TextXAlignment = Enum.TextXAlignment.Left
    DescriptiveText.BackgroundTransparency = 1
    DescriptiveText.Parent = RowWrapper

    local CoreToggleBtn = Instance.new("TextButton")
    CoreToggleBtn.Size = UDim2.new(0, 34, 0, 16)
    CoreToggleBtn.Position = UDim2.new(1, -44, 0.5, -8)
    CoreToggleBtn.BackgroundColor3 = SystemConfig[TargetKey] and Colors.AccentPurple or Color3.fromRGB(50, 50, 50)
    CoreToggleBtn.Text = ""
    Instance.new("UICorner", CoreToggleBtn).CornerRadius = UDim.new(1, 0)
    CoreToggleBtn.Parent = RowWrapper

    local InternalNode = Instance.new("Frame")
    InternalNode.Size = UDim2.new(0, 12, 0, 12)
    InternalNode.Position = SystemConfig[TargetKey] and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    InternalNode.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    Instance.new("UICorner", InternalNode).CornerRadius = UDim.new(1, 0)
    InternalNode.Parent = CoreToggleBtn

    CoreToggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            SystemConfig[TargetKey] = not SystemConfig[TargetKey]
            local isCurrent = SystemConfig[TargetKey]
            CoreToggleBtn.BackgroundColor3 = isCurrent and Colors.AccentPurple or Color3.fromRGB(50, 50, 50)
            InternalNode.Position = isCurrent and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        end
    end)
end

local function CreateSliderTrack(TargetView, DisplayTitle, FloorValue, CeilingValue, InitialValue, TargetKey)
    local SliderBox = Instance.new("Frame")
    SliderBox.Size = UDim2.new(1, -10, 0, 48)
    SliderBox.BackgroundColor3 = Colors.Component
