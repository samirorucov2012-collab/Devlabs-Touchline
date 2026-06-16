--[=[
    DEVLABS / PHASE - TOUCHLINE Open Source
    Full GUI + Reach + Ball + Avatar Stealer
    GitHub Version
]=]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ================== CONFIG ==================
local Config = {
    LegReach = {Enabled = true, Size = 5},
    BallReach = {Enabled = true, Size = 8},
    BallMagnet = {Enabled = false, Power = 45},
    AutoKick = {Enabled = false},
    GoalAim = {Enabled = false},
    AirDribble = {Enabled = false, Size = 4.5},
}

-- ================== GUI ==================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DEVLABS_TOUCHLINE"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 540, 0, 480)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
Title.Text = "DEVLABS - TOUCHLINE"
Title.TextColor3 = Color3.fromRGB(180, 100, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Sidebar.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 4)
UIList.Parent = Sidebar

-- Tablar
local tabs = {"Reach", "Ball", "Player", "Helpers"}
for _, tab in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB()
