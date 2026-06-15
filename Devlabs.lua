--[[
    DEVLABS - TOUCHLINE PREMIUM EDITION (ALL-IN-ONE FIXED SYSTEM)
    Optimized perfectly for Delta Executor (Android, iOS & PC)
    Fully verified core UI elements with stable mobile visibility toggling.
--]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--------------------------------------------------------------------------------
-- [CORE INTEGRITY & ANCHOR CLEANER]
--------------------------------------------------------------------------------
local TargetParent = nil
local ok, res = pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("RobloxGui") then
        return game:GetService("CoreGui")
    else
        return LocalPlayer:WaitForChild("PlayerGui")
    end
end)
TargetParent = ok and res or LocalPlayer:WaitForChild("PlayerGui")

if TargetParent:FindFirstChild("Phase_Touchline") then
    TargetParent:FindFirstChild("Phase_Touchline"):Destroy()
end

--------------------------------------------------------------------------------
-- [EXACT COLOR & STATE SPECIFICATIONS]
--------------------------------------------------------------------------------
local Colors = {
    Background = Color3.fromRGB(11, 11, 11),
    Sidebar = Color3.fromRGB(6, 6, 6),
    ComponentBg = Color3.fromRGB(18, 18, 18),
    AccentPurple = Color3.fromRGB(105, 55, 215),
    TextWhite = Color3.fromRGB(245, 245, 245),
    TextMuted = Color3.fromRGB(130, 130, 130),
    Border = Color3.fromRGB(28, 28, 28)
}

local SystemConfig = {
    -- Reach States
    LegReachEnabled = false,
    LegReachSize = 5.0,
    LegVisualizer = false,
    -- Ball States
    BallReachEnabled = false,
    BallReachSize = 5.0,
    BallVisualizer = false,
    BallCollision = false,
    -- Helper States
    AirDribbleHelper = false,
    AirDribbleSize = 4.5,
    -- Customization States
    AvatarStealerUser = "",
    -- FFlags Fields
    TargetTimeDelay = "DFIntTargetTimeDelayFactorTenths",
    Interpolation = "FIntInterpolationMaxDelayMSec",
    PhysicsSenderRate1 = "DFIntS2PhysicsSenderRate",
    PhysicsSenderRate2 = "DFIntS2PhysicsSenderRate",
    -- Settings
    ConfigName = ""
}

--------------------------------------------------------------------------------
-- [MAIN APPLICATION SHELL ELEMENTS]
--------------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Phase_Touchline"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = TargetParent

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 640, 0, 410)
MainFrame.Position = UDim2.new(0.5, -320, 0.5, -205)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Visible = true -- İlk çalıştırmada açık gelir
local CornerRadius = Instance.new("UICorner")
CornerRadius.CornerRadius = UDim.new(0, 6)
CornerRadius.Parent = MainFrame
MainFrame.Parent = ScreenGui

-- App Window Header Line
local TopHeader = Instance.new("Frame")
TopHeader.Name = "TopHeader"
TopHeader.Size = UDim2.new(1, 0, 0, 42)
TopHeader.BackgroundColor3 = Colors.Sidebar
TopHeader.BorderSizePixel = 0
local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 6)
HeaderCorner.Parent = TopHeader
TopHeader.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "  PHASE - TOUCHLINE"
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 14
TitleLabel.TextColor3 = Colors.TextWhite
TitleLabel.Size = UDim2.new(0, 250, 1, 0)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = TopHeader

local MiniBadge = Instance.new("Frame")
MiniBadge.Size = UDim2.new(0, 20, 0, 20)
MiniBadge.Position = UDim2.new(0.5, -10, 0.5, -10)
MiniBadge.BackgroundColor3 = Colors.ComponentBg
MiniBadge.BorderColor3 = Colors.AccentPurple
MiniBadge.BorderSizePixel = 1
local BadgeCorner = Instance.new("UICorner")
BadgeCorner.CornerRadius = UDim.new(1, 0)
BadgeCorner.Parent = MiniBadge
MiniBadge.Parent = TopHeader

local CloseButton = Instance.new("TextButton")
CloseButton.Text = "✕ "
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 15
CloseButton.TextColor3 = Colors.TextMuted
CloseButton.Size = UDim2.new(0, 42, 1, 0)
CloseButton.Position = UDim2.new(1, -42, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Parent = TopHeader
CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

--------------------------------------------------------------------------------
-- [MOBİL AÇMA/KAPAMA BUTONU (TAM KORUMALI SABİTLEME)]
--------------------------------------------------------------------------------
local MobileToggleButton = Instance.new("TextButton")
MobileToggleButton.Name = "DevLabs_MobileToggle"
MobileToggleButton.Size = UDim2.new(0, 50, 0, 50)
MobileToggleButton.Position = UDim2.new(0, 15, 0, 15) -- Sol üst köşeye güvenli alan
MobileToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MobileToggleButton.Text = "⚡"
MobileToggleButton.TextColor3 = Color3.fromRGB(0, 255, 255)
MobileToggleButton.TextSize = 24
MobileToggleButton.Font = Enum.Font.GothamBold
MobileToggleButton.ZIndex = 10 -- Menünün üstünde kalması için
MobileToggleButton.Parent = ScreenGui

local MobileCorner = Instance.new("UICorner", MobileToggleButton)
MobileCorner.CornerRadius = UDim.new(0, 12)
local MobileBorder = Instance.new("UIStroke", MobileToggleButton)
MobileBorder.Color = Colors.AccentPurple
MobileBorder.Width = 2

-- Mobil Buton Sürükleme Sistemi
local toggleDragging, toggleInput, toggleStart, toggleStartPos
MobileToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        toggleDragging = true
        toggleStart = input.Position
        toggleStartPos = MobileToggleButton.Position
    end
end)
MobileToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        toggleInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == toggleInput and toggleDragging then
        local delta = input.Position - toggleStart
        MobileToggleButton.Position = UDim2.new(toggleStartPos.X.Scale, toggleStartPos.X.Offset + delta.X, toggleStartPos.Y.Scale, toggleStartPos.Y.Offset + delta.Y)
    end
end)
MobileToggleButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        toggleDragging = false
    end
end)

-- Kesin Görünürlük Tetikleyicisi
MobileToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

--------------------------------------------------------------------------------
-- [SIDEBAR SECTIONS GENERATOR]
--------------------------------------------------------------------------------
local NavigationSidebar = Instance.new("Frame")
NavigationSidebar.Name = "NavigationSidebar"
NavigationSidebar.Size = UDim2.new(0, 140, 1, -42)
NavigationSidebar.Position = UDim2.new(0, 0, 0, 42)
NavigationSidebar.BackgroundColor3 = Colors.Sidebar
NavigationSidebar.BorderSizePixel = 0
NavigationSidebar.Parent = MainFrame

local NavigationLayout = Instance.new("UIListLayout")
NavigationLayout.Padding = UDim.new(0, 5)
NavigationLayout.SortOrder = Enum.SortOrder.LayoutOrder
NavigationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
NavigationLayout.Parent = NavigationSidebar

local NavigationPadding = Instance.new("UIPadding")
NavigationPadding.PaddingTop = UDim.new(0, 10)
NavigationPadding.Parent = NavigationSidebar

local DisplayContainer = Instance.new("Frame")
DisplayContainer.Name = "DisplayContainer"
DisplayContainer.Size = UDim2.new(1, -145, 1, -42)
DisplayContainer.Position = UDim2.new(0, 145, 0, 42)
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
    WindowPage.CanvasSize = UDim2.new(0, 0, 0, 500)
    WindowPage.ScrollBarThickness = 1
    WindowPage.ScrollBarImageColor3 = Colors.AccentPurple
    WindowPage.Visible = false
    WindowPage.Parent = DisplayContainer

    local WindowLayout = Instance.new("UIListLayout")
    WindowLayout.Padding = UDim.new(0, 8)
    WindowLayout.SortOrder = Enum.SortOrder.LayoutOrder
    WindowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    WindowLayout.Parent = WindowPage

    local WindowPadding = Instance.new("UIPadding")
    WindowPadding.PaddingTop = UDim.new(0, 12)
    WindowPadding.PaddingLeft = UDim.new(0, 10)
    WindowPadding.PaddingRight = UDim.new(0, 15)
    WindowPadding.Parent = WindowPage

    PageViews[TabTitle] = WindowPage

    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0, 125, 0, 32)
    TabButton.BackgroundColor3 = Colors.Sidebar
    TabButton.BorderSizePixel = 0
    TabButton.Text = "   " .. TabTitle
    TabButton.Font = Enum.Font.SourceSans
    TabButton.TextSize = 13
    TabButton.TextColor3 = Colors.TextMuted
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.Parent = NavigationSidebar
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 4)
    BtnCorner.Parent = TabButton

    TabButton.MouseButton1Click:Connect(function()
        for pName, pObj in pairs(PageViews) do pObj.Visible = (pName == TabTitle) end
        for bName, bObj in pairs(TabClickers) do
            bObj.BackgroundColor3 = (bName == TabTitle) and Colors.ComponentBg or Colors.Sidebar
            bObj.TextColor3 = (bName == TabTitle) and Colors.TextWhite or Colors.TextMuted
            bObj.Font = (bName == TabTitle) and Enum.Font.SourceSansBold or Enum.Font.SourceSans
        end
    end)
    TabClickers[TabTitle] = TabButton
end

local ScreenTabsList = {"Home", "Reach", "Ball", "Helpers", "Player", "FFlag", "Settings"}
for _, Name in ipairs(ScreenTabsList) do BuildTabWindow(Name) end
PageViews["Home"].Visible = true
TabClickers["Home"].BackgroundColor3 = Colors.ComponentBg
TabClickers["Home"].TextColor3 = Colors.TextWhite
TabClickers["Home"].Font = Enum.Font.SourceSansBold

--------------------------------------------------------------------------------
-- [SYSTEM OBJECT COMPONENT BUILD FACTORY]
--------------------------------------------------------------------------------
local function CreateCategoryHeader(TargetView, HeadingText)
    local Label = Instance.new("TextLabel")
    Label.Text = HeadingText
    Label.Font = Enum.Font.SourceSansBold
    Label.TextSize = 14
    Label.TextColor3 = Colors.AccentPurple
    Label.Size = UDim2.new(1, 0, 0, 22)
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = TargetView
end

local function CreateDataDisplayStrip(TargetView, FieldText)
    local Wrapper = Instance.new("Frame")
    Wrapper.Size = UDim2.new(1, 0, 0, 34)
    Wrapper.BackgroundColor3 = Colors.ComponentBg
    Wrapper.BorderSizePixel = 0
    local WrapCorner = Instance.new("UICorner")
    WrapCorner.CornerRadius = UDim.new(0, 4)
    WrapCorner.Parent = Wrapper
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
    RowWrapper.Size = UDim2.new(1, 0, 0, 38)
    RowWrapper.BackgroundColor3 = Colors.ComponentBg
    RowWrapper.BorderSizePixel = 0
    local RowCorner = Instance.new("UICorner")
    RowCorner.CornerRadius = UDim.new(0, 4)
    RowCorner.Parent = RowWrapper
    RowWrapper.Parent = TargetView

    local DescriptiveText = Instance.new("TextLabel")
    DescriptiveText.Text = "  " .. ActionText
    DescriptiveText.Font = Enum.Font.SourceSans
    DescriptiveText.TextSize = 13
    DescriptiveText.TextColor3 = Colors.TextWhite
    DescriptiveText.Size = UDim2.new(0, 250, 1, 0)
    DescriptiveText.TextXAlignment = Enum.TextXAlignment.Left
    DescriptiveText.BackgroundTransparency = 1
    DescriptiveText.Parent = RowWrapper

    local CoreToggleBtn = Instance.new("TextButton")
    CoreToggleBtn.Size = UDim2.new(0, 34, 0, 16)
    CoreToggleBtn.Position = UDim2.new(1, -44, 0.5, -8)
    CoreToggleBtn.BackgroundColor3 = SystemConfig[TargetKey] and Colors.AccentPurple or Color3.fromRGB(50, 50, 50)
    CoreToggleBtn.Text = ""
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = CoreToggleBtn
    CoreToggleBtn.Parent = RowWrapper

    local InternalNode = Instance.new("Frame")
    InternalNode.Size = UDim2.new(0, 12, 0, 12)
    InternalNode.Position = SystemConfig[TargetKey] and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    InternalNode.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    local NodeCorner = Instance.new("UICorner")
    NodeCorner.CornerRadius = UDim.new(1, 0)
    NodeCorner.Parent = InternalNode
    InternalNode.Parent = CoreToggleBtn

    CoreToggleBtn.MouseButton1Click:Connect(function()
        SystemConfig[TargetKey] = not SystemConfig[TargetKey]
        local isCurrent = SystemConfig[TargetKey]
        TweenService:Create(CoreToggleBtn, TweenInfo.new(0.12), {BackgroundColor3 = isCurrent and Colors.AccentPurple or Color3.fromRGB(50, 50, 50)}):Play()
        TweenService:Create(InternalNode, TweenInfo.new(0.12), {Position = isCurrent and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
    end)
end

local function CreateSliderTrack(TargetView, DisplayTitle, FloorValue, CeilingValue, InitialValue, TargetKey)
    local SliderBox = Instance.new("Frame")
    SliderBox.Size = UDim2.new(1, 0, 0, 52)
    SliderBox.BackgroundColor3 = Colors.ComponentBg
    SliderBox.BorderSizePixel = 0
    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 4)
    BoxCorner.Parent = SliderBox
    SliderBox.Parent = TargetView

    local TitleField = Instance.new("TextLabel")
    TitleField.Text = "  " .. DisplayTitle
    TitleField.Font = Enum.Font.SourceSans
    TitleField.TextSize = 13
    TitleField.TextColor3 = Colors.TextWhite
    TitleField.Position = UDim2.new(0, 0, 0, 6)
    TitleField.Size = UDim2.new(0, 200, 0, 16)
    TitleField.TextXAlignment = Enum.TextXAlignment.Left
    TitleField.BackgroundTransparency = 1
    TitleField.Parent = SliderBox

    local QuantifierLabel = Instance.new("TextLabel")
    QuantifierLabel.Text = tostring(InitialValue) .. "  "
    QuantifierLabel.Font = Enum.Font.SourceSans
    QuantifierLabel.TextSize = 13
    QuantifierLabel.TextColor3 = Colors.AccentPurple
    QuantifierLabel.Position = UDim2.new(1, -50, 0, 6)
    QuantifierLabel.Size = UDim2.new(0, 40, 0, 16)
    QuantifierLabel.TextXAlignment = Enum.TextXAlignment.Right
    QuantifierLabel.BackgroundTransparency = 1
    QuantifierLabel.Parent = SliderBox

    local LinearTrack = Instance.new("TextButton")
    LinearTrack.Size = UDim2.new(1, -24, 0, 3)
    LinearTrack.Position = UDim2.new(0, 12, 0, 36)
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
        QuantifierLabel.Text = tostring(RoundedValue) .. "  "
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

local function CreateInputTextBox(TargetView, PlaceholderDescriptor, TargetKey)
    local BlockWrapper = Instance.new("Frame")
    BlockWrapper.Size = UDim2.new(1, 0, 0, 38)
    BlockWrapper.BackgroundColor3 = Colors.ComponentBg
    BlockWrapper.BorderSizePixel = 0
    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 4)
    BoxCorner.Parent = BlockWrapper
    BlockWrapper.Parent = TargetView

    local DedicatedInput = Instance.new("TextBox")
    DedicatedInput.PlaceholderText = PlaceholderDescriptor
    DedicatedInput.Text = SystemConfig[TargetKey] or ""
    DedicatedInput.Font = Enum.Font.SourceSans
    DedicatedInput.TextSize = 13
    DedicatedInput.TextColor3 = Colors.TextWhite
    DedicatedInput.PlaceholderColor3 = Colors.TextMuted
    DedicatedInput.Size = UDim2.new(1, -20, 1, 0)
    DedicatedInput.Position = UDim2.new(0, 10, 0, 0)
    DedicatedInput.BackgroundTransparency = 1
    DedicatedInput.TextXAlignment = Enum.TextXAlignment.Left
    DedicatedInput.Parent = BlockWrapper

    DedicatedInput.FocusLost:Connect(function()
        SystemConfig[TargetKey] = DedicatedInput.Text
    end)
    return DedicatedInput
end

local function CreateActionClicker(TargetView, LabelString, TriggerFunction)
    local FrameButton = Instance.new("TextButton")
    FrameButton.Size = UDim2.new(1, 0, 0, 36)
    FrameButton.BackgroundColor3 = Colors.ComponentBg
    FrameButton.
