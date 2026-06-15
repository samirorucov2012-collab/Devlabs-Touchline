--[[
    DEVLABS - TOUCHLINE PREMIUM EDITION (V10 FIXED)
    - Helpers + sonrası içerik eklendi
    - Yıldırım butonu kapanma sorunu %100 çözüldü
    - Daha stabil tab sistemi
--]]

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local SystemConfig = {
    LegReachEnabled = true, LegReachSize = 5.0,
    BallReachEnabled = true, BallReachSize = 5.0,
    AirDribbleHelper = false,
}

local Colors = {
    Background = Color3.fromRGB(11, 11, 11),
    Sidebar = Color3.fromRGB(6, 6, 6),
    ComponentBg = Color3.fromRGB(18, 18, 18),
    AccentPurple = Color3.fromRGB(105, 55, 215),
    TextWhite = Color3.fromRGB(245, 245, 245),
    TextMuted = Color3.fromRGB(130, 130, 130)
}

-- CoreGui temizliği
local TargetParent = game:GetService("CoreGui")
if TargetParent:FindFirstChild("Phase_Touchline") then
    TargetParent:FindFirstChild("Phase_Touchline"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Phase_Touchline"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = TargetParent

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 360)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -180)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.Active = true
MainFrame.Visible = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
MainFrame.Parent = ScreenGui

-- Header
local TopHeader = Instance.new("Frame")
TopHeader.Size = UDim2.new(1, 0, 0, 40)
TopHeader.BackgroundColor3 = Colors.Sidebar
Instance.new("UICorner", TopHeader).CornerRadius = UDim.new(0, 8)
TopHeader.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "  PHASE - TOUCHLINE"
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 15
TitleLabel.TextColor3 = Colors.TextWhite
TitleLabel.Size = UDim2.new(0, 220, 1, 0)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = TopHeader

local CloseButton = Instance.new("TextButton")
CloseButton.Text = "✕"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 18
CloseButton.TextColor3 = Colors.TextMuted
CloseButton.Size = UDim2
