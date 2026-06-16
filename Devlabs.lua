--[=[
	PHASE - TOUCHLINE Open Source Edition
	Full GUI + All Tabs + Mobile Toggle
	GitHub Version
]=]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ================== CONFIG ==================
local Config = {
	LegReach = {Enabled = true, Size = 5},
	BallReach = {Enabled = true, Size = 8},
	BallMagnet = {Enabled = true, Power = 40},
	AutoKick = {Enabled = true},
	GoalAim = {Enabled = true},
	AirDribble = {Enabled = true, Size = 4.5},
	AvatarStealer = {Enabled = true},
}

local guiOpen = true

-- ================== GUI ==================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DEVLABS_TOUCHLINE"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 460)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -230)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
Title.Text = "DEVLABS- TOUCHLINE"
Title.TextColor3 = Color3.fromRGB(180, 100, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22,
