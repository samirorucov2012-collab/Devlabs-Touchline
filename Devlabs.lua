--[[
    DEVLABS - TOUCHLINE PREMIUM (ENGLISH - V11)
    Fully fixed: Menu closing, empty tabs, stability
    Works perfectly when executed from GitHub raw link
--]]

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Config
local Config = {
    LegReachEnabled = true,
    LegReachSize = 5.0,
    LegVisualizer = true,
    BallReachEnabled = true,
    BallReachSize = 5.0,
    BallVisualizer = true,
    AirDribbleHelper = false,
    AutoPassAssist = false,
}

local Colors = {
    Background = Color3.fromRGB(11, 11, 11),
    Sidebar = Color3.fromRGB(6, 6, 6),
    Component = Color3.fromRGB(18, 18, 18),
    Accent = Color3.fromRGB(105, 55, 215),
    Text = Color3.fromRGB(245, 245, 245),
    Muted = Color3.fromRGB(130, 130, 130)
}

-- Destroy old GUI
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("Phase_Touchline") then
    CoreGui:FindFirstChild("Phase_Touchline"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Phase_Touchline"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 560, 0, 360)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -180)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.Active = true
MainFrame.Visible = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
MainFrame.Parent = ScreenGui

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Colors.Sidebar
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "PHASE - TOUCHLINE"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 15
Title.TextColor3 = Colors.Text
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Lightning Button (Menu Toggle)
local LightningBtn = Instance.new("TextButton")
LightningBtn.Size = UDim2.new(0, 40, 0, 40)
LightningBtn.Position = UDim2.new(0, 8, 0, -45)
LightningBtn.BackgroundColor3 = Colors.Accent
LightningBtn.Text = "⚡"
LightningBtn.TextSize = 20
LightningBtn.Font = Enum.Font.SourceSansBold
LightningBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", LightningBtn).CornerRadius = UDim.new(1, 0)
LightningBtn.Parent = ScreenGui

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 16
CloseBtn.TextColor3 = Colors.Muted
CloseBtn.Size = UDim2.new(0, 40, 1, 0)
CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Parent = Header

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Colors.Sidebar
Sidebar.Parent = MainFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 6)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Parent = Sidebar

-- Content Area
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -140, 1, -50)
Content.Position = UDim2.new(0, 135, 0, 45)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Tab System
local Pages = {}
local Tabs = {}

local function CreateTab(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = Colors.Accent
    Page.CanvasSize = UDim2.new(0, 0, 0, 800)
    Page.Parent = Content
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
    
    Pages[name] = Page

    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, -10, 0, 36)
    TabBtn.BackgroundColor3 = Colors.Sidebar
    TabBtn.Text = "  " .. name
    TabBtn.TextColor3 = Colors.Muted
    TabBtn.Font = Enum.Font.SourceSans
    TabBtn.TextSize = 14
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
    TabBtn.Parent = Sidebar
    Tabs[name] = TabBtn
end

-- Create Tabs
CreateTab("Home")
CreateTab("Reach")
CreateTab("Ball")
CreateTab("Helpers")
CreateTab("Player")
CreateTab("FFlag")
CreateTab("Settings")

-- Tab Switching
local function SwitchTab(selected)
    for name, page in pairs(Pages) do
        page.Visible = (name == selected)
    end
    for name, btn in pairs(Tabs) do
        btn.BackgroundColor3 = (name == selected) and Colors.Component or Colors.Sidebar
        btn.TextColor3 = (name == selected) and Colors.Text or Colors.Muted
    end
end

for name, btn in pairs(Tabs) do
    btn.MouseButton1Click:Connect(function()
        SwitchTab(name)
    end)
end

-- Default tab
SwitchTab("Home")

-- UI Elements
local function HeaderText(parent, text)
    local lbl = Instance.new("TextLabel")
    lbl.Text = " " .. text
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 15
    lbl.TextColor3 = Colors.Accent
    lbl.Size = UDim2.new(1, -10, 0, 28)
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent
end

local function Toggle(parent, text, configKey)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 38)
    frame.BackgroundColor3 = Colors.Component
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Text = "  " .. text
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextColor3 = Colors.Text
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 42, 0, 22)
    toggleBtn.Position = UDim2.new(1, -50, 0.5, -11)
    toggleBtn.BackgroundColor3 = Config[configKey] and Colors.Accent or Color3.fromRGB(60, 60, 60)
