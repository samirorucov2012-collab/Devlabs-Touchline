--[[
    DEVLABS - TOUCHLINE PREMIUM EDITION (V13 - ULTIMATE UNIFIED BUILD)
    100% FIXED & COMBINED: Loop Crashes, Mobile Deadlocks, Missing Tab Contents & Freeze
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
Main
