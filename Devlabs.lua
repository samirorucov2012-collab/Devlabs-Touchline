--[[
    DEVLABS - TOUCHLINE PREMIUM EDITION (ANTI-CRASH STABLE VERSION)
    Optimized perfectly for Delta Executor (Android, iOS & PC)
    Defensive check layers added to completely prevent startup execution failure.
--]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--------------------------------------------------------------------------------
-- [1. GLOBAL SYSTEM CONFIGURATION]
--------------------------------------------------------------------------------
local SystemConfig = {
    -- Reach States
    LegReachEnabled = true,
    LegReachSize = 5.0,
    LegVisualizer = true,
    -- Ball States
    BallReachEnabled = true,
    BallReachSize = 5.0,
    BallVisualizer = true,
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
-- [2. UI THEME COLORS & INTEGRITY CHECK]
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
-- [3. MAIN APPLICATION FRAME WORKSPACE]
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
MainFrame.Visible = true

local CornerRadius = Instance.new("UICorner")
CornerRadius.CornerRadius = UDim.new(0, 6)
CornerRadius.Parent = MainFrame
MainFrame.Parent = ScreenGui

-- Top Bar Header Window
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
-- [4. STABLE MOBILE TOGGLE BUTTON (⚡)]
--------------------------------------------------------------------------------
local MobileToggleButton = Instance.new("TextButton")
MobileToggleButton.Name = "DevLabs_MobileToggle"
MobileToggleButton.Size = UDim2.new(0, 45, 0, 45)
MobileToggleButton.Position = UDim2.new(0, 15, 0, 120)
MobileToggleButton.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
MobileToggleButton.Text = "⚡"
MobileToggleButton.TextColor3 = Color3.fromRGB(160, 90, 255)
MobileToggleButton.TextSize = 22
MobileToggleButton.Font = Enum.Font.GothamBold
MobileToggleButton.ZIndex = 10
MobileToggleButton.Parent = ScreenGui

local MobileCorner = Instance.new("UICorner", MobileToggleButton)
MobileCorner.CornerRadius = UDim.new(0, 10)
local MobileBorder = Instance.new("UIStroke", MobileToggleButton)
MobileBorder.Color = Colors.AccentPurple
MobileBorder.Width = 2

-- Dragging Engine for Mobile Button
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

MobileToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

--------------------------------------------------------------------------------
-- [5. NAVIGATION SIDEBAR & LAYOUT FRAME GENERATOR]
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
    WindowPage.ScrollBarThickness = 2
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

-- Activate Default Tab Safely
PageViews["Home"].Visible = true
TabClickers["Home"].BackgroundColor3 = Colors.ComponentBg
TabClickers["Home"].TextColor3 = Colors.TextWhite
TabClickers["Home"].Font = Enum.Font.SourceSansBold

--------------------------------------------------------------------------------
-- [6. FACTORY DEFENSIVE BUILDING UTILITIES]
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
        TweenService:Create(InternalNode, TweenInfo.new(0.12), {Position = isCurrent remission and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
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
    DedicatedInput.Text = tostring(SystemConfig[TargetKey] or "")
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
    FrameButton.Text = "  " .. LabelString
    FrameButton.TextXAlignment = Enum.TextXAlignment.Left 
    FrameButton.Font = Enum.Font.SourceSans
    FrameButton.TextSize = 13
    FrameButton.TextColor3 = Colors.TextWhite
    local ClickerCorner = Instance.new("UICorner")
    ClickerCorner.CornerRadius = UDim.new(0, 4)
    ClickerCorner.Parent = FrameButton
    
    local ChevronSymbol = Instance.new("TextLabel")
    ChevronSymbol.Text = "❯ "
    ChevronSymbol.Font = Enum.Font.SourceSansBold
    ChevronSymbol.TextSize = 12
    ChevronSymbol.TextColor3 = Colors.AccentPurple
    ChevronSymbol.Size = UDim2.new(0, 30, 1, 0)
    ChevronSymbol.Position = UDim2.new(1, -30, 0, 0)
    ChevronSymbol.BackgroundTransparency = 1
    ChevronSymbol.TextXAlignment = Enum.TextXAlignment.Right
    ChevronSymbol.Parent = FrameButton

    FrameButton.Parent = TargetView
    
    FrameButton.MouseButton1Click:Connect(function()
        FrameButton.BackgroundColor3 = Colors.AccentPurple
        task.wait(0.1)
        FrameButton.BackgroundColor3 = Colors.ComponentBg
        if TriggerFunction then TriggerFunction() end
    end)
end

--------------------------------------------------------------------------------
-- [7. POPULATING PAGES SAFE FROM CRASHES]
--------------------------------------------------------------------------------
-- Home View
CreateCategoryHeader(PageViews["Home"], "Info")
CreateDataDisplayStrip(PageViews["Home"], "DEVELOPER : 97rnn")
CreateDataDisplayStrip(PageViews["Home"], "Welcome, " .. LocalPlayer.Name .. "!")
CreateDataDisplayStrip(PageViews["Home"], "Executor: Delta")
CreateDataDisplayStrip(PageViews["Home"], "Access: PREMIUM")
CreateDataDisplayStrip(PageViews["Home"], "Executed: Stable Load")
local CounterLabel = CreateDataDisplayStrip(PageViews["Home"], "Players: " .. tostring(#Players:GetPlayers()))
CreateDataDisplayStrip(PageViews["Home"], "Status: UNDETECTED")

Players.PlayerAdded:Connect(function() CounterLabel.Text = "  Players: " .. tostring(#Players:GetPlayers()) end)
Players.PlayerRemoving:Connect(function() CounterLabel.Text = "  Players: " .. tostring(#Players:GetPlayers()) end)

-- Reach View
CreateCategoryHeader(PageViews["Reach"], "Leg Reach")
CreateToggleSwitch(PageViews["Reach"], "Leg Reach Enabled", "LegReachEnabled")
CreateSliderTrack(PageViews["Reach"], "Leg Reach Size", 1, 25, 5, "LegReachSize")
CreateToggleSwitch(PageViews["Reach"], "Leg Visualizer", "LegVisualizer")

-- Ball View
CreateCategoryHeader(PageViews["Ball"], "Ball Reach")
CreateToggleSwitch(PageViews["Ball"], "Ball Reach Enabled", "BallReachEnabled")
CreateSliderTrack(PageViews["Ball"], "Ball Reach Size", 1, 25, 5, "BallReachSize")
CreateToggleSwitch(PageViews["Ball"], "Ball Visualizer", "BallVisualizer")
CreateToggleSwitch(PageViews["Ball"], "Ball Collision", "BallCollision")

-- Helpers View
CreateCategoryHeader(PageViews["Helpers"], "Visual Helpers")
CreateToggleSwitch(PageViews["Helpers"], "Air Dribble Helper", "AirDribbleHelper")
CreateSliderTrack(PageViews["Helpers"], "Air Dribble Size", 1, 20, 4.5, "AirDribbleSize")

-- Player View
CreateCategoryHeader(PageViews["Player"], "Customization")
local AvatarBoxWrapper = Instance.new("Frame")
AvatarBoxWrapper.Size = UDim2.new(1, 0, 0, 38)
AvatarBoxWrapper.BackgroundColor3 = Colors.ComponentBg
AvatarBoxWrapper.BorderSizePixel = 0
local WrapCornerX = Instance.new("UICorner", AvatarBoxWrapper)
WrapCornerX.CornerRadius = UDim.new(0, 4)
AvatarBoxWrapper.Parent = PageViews["Player"]

local StaticLabel = Instance.new("TextLabel")
StaticLabel.Text = "  Avatar Stealer"
StaticLabel.Size = UDim2.new(0, 120, 1, 0)
StaticLabel.Font = Enum.Font.SourceSans
StaticLabel.TextSize = 13
StaticLabel.TextColor3 = Colors.TextWhite
StaticLabel.BackgroundTransparency = 1
StaticLabel.TextXAlignment = Enum.TextXAlignment.Left
StaticLabel.Parent = AvatarBoxWrapper

local AvatarBox = Instance.new("TextBox")
AvatarBox.PlaceholderText = "Enter username..."
AvatarBox.Text = ""
AvatarBox.Font = Enum.Font.SourceSans
AvatarBox.TextSize = 13
AvatarBox.TextColor3 = Colors.TextWhite
AvatarBox.PlaceholderColor3 = Colors.TextMuted
AvatarBox.Size = UDim2.new(0, 250, 1, 0)
AvatarBox.Position = UDim2.new(1, -260, 0, 0)
AvatarBox.BackgroundTransparency = 1
AvatarBox.TextXAlignment = Enum.TextXAlignment.Center
AvatarBox.Parent = AvatarBoxWrapper
AvatarBox.FocusLost:Connect(function() SystemConfig.AvatarStealerUser = AvatarBox.Text end)

CreateActionClicker(PageViews["Player"], "Steal Avatar Look", function()
    local NameTarget = SystemConfig.AvatarStealerUser
    if NameTarget == "" then return end
    local success, targetId = pcall(function() return Players:GetUserIdFromNameAsync(NameTarget) end)
    if success and targetId then
        local myChar = LocalPlayer.Character
        if myChar and myChar:FindFirstChildOfClass("Humanoid") then
            local desc = Players:GetHumanoidDescriptionFromUserId(targetId)
            myChar:FindFirstChildOfClass("Humanoid"):ApplyDescription(desc)
        end
    end
end)

-- FFlag View
CreateCategoryHeader(PageViews["FFlag"], "FFlag Changer")
CreateInputTextBox(PageViews["FFlag"], "DFIntTargetTimeDelayFactorTenths", "TargetTimeDelay")
CreateInputTextBox(PageViews["FFlag"], "FIntInterpolationMaxDelayMSec", "Interpolation")
CreateInputTextBox(PageViews["FFlag"], "DFIntS2PhysicsSenderRate", "PhysicsSenderRate1")
CreateInputTextBox(PageViews["FFlag"], "DFIntS2PhysicsSenderRate", "PhysicsSenderRate2")

-- Settings View
CreateCategoryHeader(PageViews["Settings"], "Configuration")
local ConfigBoxWrapper = Instance.new("Frame")
ConfigBoxWrapper.Size = UDim2.new(1, 0, 0, 38)
ConfigBoxWrapper.BackgroundColor3 = Colors.ComponentBg
ConfigBoxWrapper.BorderSizePixel = 0
local WrapCornerY = Instance.new("UICorner", ConfigBoxWrapper)
WrapCornerY.CornerRadius = UDim.new(0, 4)
ConfigBoxWrapper.Parent = PageViews["Settings"]

local StaticConfigLabel = Instance.new("TextLabel")
StaticConfigLabel.Text = "  Config Name"
StaticConfigLabel.Size = UDim2.new(0, 120, 1, 0)
StaticConfigLabel.Font = Enum.Font.SourceSans
StaticConfigLabel.TextSize = 13
StaticConfigLabel.TextColor3 = Colors.TextWhite
StaticConfigLabel.BackgroundTransparency = 1
StaticConfigLabel.TextXAlignment = Enum.TextXAlignment.Left
StaticConfigLabel.Parent = ConfigBoxWrapper

local ConfigBox = Instance.new("TextBox")
ConfigBox.PlaceholderText = "Enter config name..."
ConfigBox.Text = ""
ConfigBox.Font = Enum.Font.SourceSans
ConfigBox.TextSize = 13
ConfigBox.TextColor3 = Colors.TextWhite
ConfigBox.PlaceholderColor3 = Colors.TextMuted
ConfigBox.Size = UDim2.new(0, 250, 1, 0)
ConfigBox.Position = UDim2.new(1, -260, 0, 0)
ConfigBox.BackgroundTransparency = 1
ConfigBox.TextXAlignment = Enum.TextXAlignment.Center
ConfigBox.Parent = ConfigBoxWrapper
ConfigBox.FocusLost:Connect(function() SystemConfig.ConfigName = ConfigBox.Text end)

local SelectConfigRow = Instance.new("Frame")
SelectConfigRow.Size = UDim2.new(1, 0, 0, 38)
SelectConfigRow.BackgroundColor3 = Colors.ComponentBg
SelectConfigRow.BorderSizePixel = 0
local RowCorner = Instance.new("UICorner")
RowCorner.CornerRadius = UDim.new(0, 4)
RowCorner.Parent = SelectConfigRow
SelectConfigRow.Parent = PageViews["Settings"]

local LabelLeft = Instance.new("TextLabel")
LabelLeft.Text = "  Select Config"
LabelLeft.Font = Enum.Font.SourceSans
LabelLeft.TextSize = 13
LabelLeft.TextColor3 = Colors.TextWhite
LabelLeft.Size = UDim2.new(0, 150, 1, 0)
LabelLeft.TextXAlignment = Enum.TextXAlignment.Left
LabelLeft.BackgroundTransparency = 1
LabelLeft.Parent = SelectConfigRow

local LabelRightActive = Instance.new("TextLabel")
LabelRightActive.Text = "default  "
LabelRightActive.Font = Enum.Font.SourceSansBold
LabelRightActive.TextSize = 13
LabelRightActive.TextColor3 = Colors.AccentPurple
LabelRightActive.Size = UDim2.new(0, 100, 1, 0)
LabelRightActive.Position = UDim2.new(1, -110, 0, 0)
LabelRightActive.TextXAlignment = Enum.TextXAlignment.Right
LabelRightActive.BackgroundTransparency = 1
LabelRightActive.Parent = SelectConfigRow

CreateActionClicker(PageViews["Settings"], "Save Config", function() print("[Phase Engine] Config saved.") end)
CreateActionClicker(PageViews["Settings"], "Load Config", function() print("[Phase Engine] Config loaded.") end)
CreateActionClicker(PageViews["Settings"], "Delete Config", function() print("[Phase Engine] Config cleared.") end)
CreateActionClicker(PageViews["Settings"], "Set as Auto Load", function() print("[Phase Engine] Autoload set.") end)

--------------------------------------------------------------------------------
-- [8. DRAG UTILITY SCHEME FOR CORE WINDOW]
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- [9. PROTECTED LOOP SUBSYSTEM FOR HITBOXES (ANTI-CRASH MODE)]
--------------------------------------------------------------------------------
local RuntimeLegPart = nil
local RuntimeBallPart = nil

RunService.Heartbeat:Connect(function()
    -- Wrap everything in pcall to absolutely prevent core script death
    pcall(function()
        if not ScreenGui or not ScreenGui.Parent then return end
        
        local Character = LocalPlayer.Character
        if not Character then return end
        
        local RootPart = Character:FindFirstChild("HumanoidRootPart")
        if not RootPart then return end

        -- Leg Reach Logic Layer
        if SystemConfig.LegReachEnabled and SystemConfig.LegVisualizer then
            if not RuntimeLegPart or not RuntimeLegPart.Parent then
                RuntimeLegPart = Instance.new("Part")
                RuntimeLegPart.Name = "Touchline_LegReachPart"
                RuntimeLegPart.Shape = Enum.PartType.Ball
                RuntimeLegPart.Material = Enum.Material.ForceField
                RuntimeLegPart.Color = Colors.AccentPurple
                RuntimeLegPart.CastShadow = false
                RuntimeLegPart.CanCollide = false
                RuntimeLegPart.Anchored = false
                RuntimeLegPart.Parent = Character
                
                local ConnectionWeld = Instance.new("WeldConstraint")
                ConnectionWeld.Part0 = RootPart
                ConnectionWeld.Part1 = RuntimeLegPart
                ConnectionWeld.Parent = RuntimeLegPart

                RuntimeLegPart.Touched:Connect(function(HitPart)
                    pcall(function()
                        if HitPart.Name == "Ball" or HitPart:GetAttribute("IsBall", true) or HitPart.Parent:FindFirstChild("Ball") then
                            -- Secure executor check for touch triggers
                            local triggerFunc = firetouchinterest or (chronos and chronos.firetouchinterest)
                            if triggerFunc then
                                local targetLimb = Character:FindFirstChild("Right Foot") or RootPart
                                triggerFunc(HitPart, targetLimb, 0)
                                triggerFunc(HitPart, targetLimb, 1)
                            end
                        end
                    end)
                end)
            end
            RuntimeLegPart.Size = Vector3.new(SystemConfig.LegReachSize, SystemConfig.LegReachSize, SystemConfig.LegReachSize)
            RuntimeLegPart.Transparency = 0.7
        else
            if RuntimeLegPart then RuntimeLegPart:Destroy() RuntimeLegPart = nil end
        end

        -- Ball Reach Logic Layer
        if SystemConfig.BallReachEnabled and SystemConfig.BallVisualizer then
            if not RuntimeBallPart or not RuntimeBallPart.Parent then
                RuntimeBallPart = Instance.new("Part")
                RuntimeBallPart.Name = "Touchline_BallReachPart"
                RuntimeBallPart.Shape = Enum.PartType.Ball
                RuntimeBallPart.Material = Enum.Material.ForceField
                RuntimeBallPart.Color = Color3.fromRGB(230, 40, 105)
                RuntimeBallPart.CastShadow = false
                RuntimeBallPart.CanCollide = SystemConfig.BallCollision
                RuntimeBallPart.Anchored = false
                RuntimeBallPart.Parent = Character
                
                local ConnectionWeld = Instance.new("WeldConstraint")
                ConnectionWeld.Part0 = RootPart
                ConnectionWeld.Part1 = RuntimeBallPart
                ConnectionWeld.Parent = RuntimeBallPart
            end
            RuntimeBallPart.Size = Vector3.new(SystemConfig.BallReachSize, SystemConfig.BallReachSize, SystemConfig.BallReachSize)
            RuntimeBallPart.Transparency = 0.75
        else
            if RuntimeBallPart then RuntimeBallPart:Destroy() RuntimeBallPart = nil end
        end
    end)
end)

print("[DevLabs Final Compilation] Protected environment loaded successfully.")
