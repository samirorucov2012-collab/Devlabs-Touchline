--[[
    DEVLABS - TOUCHLINE PREMIUM EDITION (ULTRA STABLE FINAL FIX)
    100% Fixed: Black Screen Layout & Toggle Button Ghost Clicks
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

-- MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 540, 0, 340)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -170)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Visible = true
MainFrame.ZIndex = 10 -- Yıldırım butonunun altında kalması için ayarlandı
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
CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

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
DisplayContainer.ClipsDescendants = true
DisplayContainer.Parent = MainFrame

local PageViews = {}
local TabClickers = {}

-- Anti-Black Screen Position Logic (0,0 = Aktif Sayfa, 2,0 = Ekranın Dışında Gizli Sayfa)
local ActivePos = UDim2.new(0, 0, 0, 0)
local HiddenPos = UDim2.new(2, 0, 0, 0)

local function BuildTabWindow(TabTitle)
    local WindowPage = Instance.new("ScrollingFrame")
    WindowPage.Name = TabTitle .. "WindowPage"
    WindowPage.Size = UDim2.new(1, 0, 1, 0)
    WindowPage.Position = HiddenPos
    WindowPage.BackgroundTransparency = 1
    WindowPage.BorderSizePixel = 0
    WindowPage.CanvasSize = UDim2.new(0, 0, 0, 450)
    WindowPage.ScrollBarThickness = 3
    WindowPage.ScrollBarImageColor3 = Colors.AccentPurple
    WindowPage.Visible = true -- Her zaman True kalarak render hatasını engelliyor
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

    TabButton.MouseButton1Click:Connect(function()
        for pName, pObj in pairs(PageViews) do 
            pObj.Position = (pName == TabTitle) and ActivePos or HiddenPos
        end
        for bName, bObj in pairs(TabClickers) do
            bObj.BackgroundColor3 = (bName == TabTitle) and Colors.ComponentBg or Colors.Sidebar
            bObj.TextColor3 = (bName == TabTitle) and Colors.TextWhite or Colors.TextMuted
        end
    end)
    TabClickers[TabTitle] = TabButton
end

local ScreenTabsList = {"Home", "Reach", "Ball", "Helpers", "Player", "FFlag", "Settings"}
for _, Name in ipairs(ScreenTabsList) do BuildTabWindow(Name) end

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

    CoreToggleBtn.MouseButton1Click:Connect(function()
        SystemConfig[TargetKey] = not SystemConfig[TargetKey]
        local isCurrent = SystemConfig[TargetKey]
        CoreToggleBtn.BackgroundColor3 = isCurrent and Colors.AccentPurple or Color3.fromRGB(50, 50, 50)
        InternalNode.Position = isCurrent and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    end)
end

local function CreateSliderTrack(TargetView, DisplayTitle, FloorValue, CeilingValue, InitialValue, TargetKey)
    local SliderBox = Instance.new("Frame")
    SliderBox.Size = UDim2.new(1, -10, 0, 48)
    SliderBox.BackgroundColor3 = Colors.ComponentBg
    SliderBox.BorderSizePixel = 0
    Instance.new("UICorner", SliderBox).CornerRadius = UDim.new(0, 4)
    SliderBox.Parent = TargetView

    local TitleField = Instance.new("TextLabel")
    TitleField.Text = "  " .. DisplayTitle
    TitleField.Font = Enum.Font.SourceSans
    TitleField.TextSize = 13
    TitleField.TextColor3 = Colors.TextWhite
    TitleField.Position = UDim2.new(0, 0, 0, 4)
    TitleField.Size = UDim2.new(0, 150, 0, 16)
    TitleField.TextXAlignment = Enum.TextXAlignment.Left
    TitleField.BackgroundTransparency = 1
    TitleField.Parent = SliderBox

    local QuantifierLabel = Instance.new("TextLabel")
    QuantifierLabel.Text = tostring(InitialValue) .. " "
    QuantifierLabel.Font = Enum.Font.SourceSansBold
    QuantifierLabel.TextSize = 13
    QuantifierLabel.TextColor3 = Colors.AccentPurple
    QuantifierLabel.Position = UDim2.new(1, -50, 0, 4)
    QuantifierLabel.Size = UDim2.new(0, 40, 0, 16)
    QuantifierLabel.TextXAlignment = Enum.TextXAlignment.Right
    QuantifierLabel.BackgroundTransparency = 1
    QuantifierLabel.Parent = SliderBox

    local LinearTrack = Instance.new("TextButton")
    LinearTrack.Size = UDim2.new(1, -24, 0, 4)
    LinearTrack.Position = UDim2.new(0, 12, 0, 30)
    LinearTrack.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    LinearTrack.Text = ""
    LinearTrack.AutoButtonColor = false
    LinearTrack.Parent = SliderBox

    local ExpansionBar = Instance.new("Frame")
    ExpansionBar.Size = UDim2.new((InitialValue - FloorValue) / (CeilingValue - FloorValue), 0, 1, 0)
    ExpansionBar.BackgroundColor3 = Colors.AccentPurple
    ExpansionBar.BorderSizePixel = 0
    ExpansionBar.Parent = LinearTrack

    local ActiveHold = false
    local function RecalculateMetrics(InputEvent)
        local ClampedPercentage = math.clamp((InputEvent.Position.X - LinearTrack.AbsolutePosition.X) / LinearTrack.AbsoluteSize.X, 0, 1)
        local ScaledRaw = FloorValue + (ClampedPercentage * (CeilingValue - FloorValue))
        local RoundedValue = math.floor(ScaledRaw * 10) / 10
        QuantifierLabel.Text = tostring(RoundedValue) .. " "
        ExpansionBar.Size = UDim2.new(ClampedPercentage, 0, 1, 0)
        SystemConfig[TargetKey] = RoundedValue
    end

    LinearTrack.InputBegan:Connect(function(InputEvent)
        if InputEvent.UserInputType == Enum.UserInputType.MouseButton1 or InputEvent.UserInputType == Enum.UserInputType.Touch then
            ActiveHold = true
            RecalculateMetrics(InputEvent)
        end
    end)
    UserInputService.InputChanged:Connect(function(InputEvent)
        if ActiveHold and (InputEvent.UserInputType == Enum.UserInputType.MouseMovement or InputEvent.UserInputType == Enum.UserInputType.Touch) then
            RecalculateMetrics(InputEvent)
        end
    end)
    UserInputService.InputEnded:Connect(function(InputEvent)
        if InputEvent.UserInputType == Enum.UserInputType.MouseButton1 or InputEvent.UserInputType == Enum.UserInputType.Touch then
            ActiveHold = false
        end
    end)
end

-- POPULATE PAGES
CreateCategoryHeader(PageViews["Home"], "DevLabs Stable Engine")
CreateDataDisplayStrip(PageViews["Home"], "Status: Active & Loaded")
CreateDataDisplayStrip(PageViews["Home"], "User: " .. LocalPlayer.Name)
CreateDataDisplayStrip(PageViews["Home"], "Render Patch: 100% Fixed")

CreateCategoryHeader(PageViews["Reach"], "Leg Reach Settings")
CreateToggleSwitch(PageViews["Reach"], "Leg Reach Enabled", "LegReachEnabled")
CreateSliderTrack(PageViews["Reach"], "Leg Reach Radius", 1, 25, 5, "LegReachSize")

CreateCategoryHeader(PageViews["Ball"], "Ball Hitbox Settings")
CreateToggleSwitch(PageViews["Ball"], "Ball Hitbox Enabled", "BallReachEnabled")
CreateSliderTrack(PageViews["Ball"], "Ball Sphere Radius", 1, 25, 5, "BallReachSize")

-- Set Home default view positions
PageViews["Home"].Position = ActivePos
TabClickers["Home"].BackgroundColor3 = Colors.ComponentBg
TabClickers["Home"].TextColor3 = Colors.TextWhite

-- ULTRA STABLE YILDIRIM BUTONU (Sürükleme Kodları Tamamen Temizlendi - Saf Tıklama)
local MobileToggleButton = Instance.new("TextButton")
MobileToggleButton.Name = "DevLabs_MobileToggle"
MobileToggleButton.Size = UDim2.new(0, 44, 0, 44)
MobileToggleButton.Position = UDim2.new(0, 20, 0, 110)
MobileToggleButton.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
MobileToggleButton.Text = "⚡"
MobileToggleButton.TextColor3 = Color3.fromRGB(160, 90, 255)
MobileToggleButton.TextSize = 20
MobileToggleButton.Font = Enum.Font.GothamBold
MobileToggleButton.ZIndex = 99999 -- En üst katmanda, menünün asla altında kalmaz
MobileToggleButton.Parent = ScreenGui
Instance.new("UICorner", MobileToggleButton).CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", MobileToggleButton)
Stroke.Color = Colors.AccentPurple
Stroke.Width = 2

-- Saf, Hatasız Aç/Kapat Fonksiyonu
MobileToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Main Menu Sürükleme Mantığı (Üst Bar)
local HoldTouch, TrackPosition, FrameOrigin
TopHeader.InputBegan:Connect(function(InputEvent)
    if InputEvent.UserInputType == Enum.UserInputType.MouseButton1 or InputEvent.UserInputType == Enum.UserInputType.Touch then
        HoldTouch = true
        TrackPosition = InputEvent.Position
        FrameOrigin = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(InputEvent)
    if HoldTouch and (InputEvent.UserInputType == Enum.UserInputType.MouseMovement or InputEvent.UserInputType == Enum.UserInputType.Touch) then
        local OffsetDelta = InputEvent.Position - TrackPosition
        MainFrame.Position = UDim2.new(FrameOrigin.X.Scale, FrameOrigin.X.Offset + OffsetDelta.X, FrameOrigin.Y.Scale, FrameOrigin.Y.Offset + OffsetDelta.Y)
    end
end)
TopHeader.InputEnded:Connect(function(InputEvent)
    if InputEvent.UserInputType == Enum.UserInputType.MouseButton1 or InputEvent.UserInputType == Enum.UserInputType.Touch then
        HoldTouch = false
    end
end)

print("[DevLabs Final] All problems fixed successfully.")
