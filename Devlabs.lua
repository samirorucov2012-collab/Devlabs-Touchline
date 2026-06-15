--[[
    DEVLABS - TOUCHLINE PREMIUM (V16 - ULTIMATE FIX BUILD)
    FIXED: Mobile Toggle/Close Responsiveness (.Activated Engine)
    ADDED: Fully Functioning Avatar Changer in Player Tab
--]]

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Global Ayarlar Tablosu
_G.SystemConfig = {
    LegReachEnabled = true,
    LegReachSize = 5.0,
    LegVisualizer = true,
    BallReachEnabled = true,
    BallReachSize = 5.0,
    BallVisualizer = true,
    BallCollision = false,
    AirDribbleHelper = false,
    AirDribbleSize = 4.5
}

-- Delta ve Mobil Cihazlar İçin En Üst Katman Seçimi
local TargetParent = LocalPlayer:WaitForChild("PlayerGui")
local coreGuiSuccess, coreGuiInstance = pcall(function() return game:GetService("CoreGui") end)
if coreGuiSuccess and coreGuiInstance then
    TargetParent = coreGuiInstance
end

-- Eski Arayüz Kalıntılarını Tamamen Temizle
if TargetParent:FindFirstChild("Phase_Touchline") then
    TargetParent:FindFirstChild("Phase_Touchline"):Destroy()
end

-- SCREEN GUI INJECT (En Üst Sırada Görünmesi İçin DisplayOrder Eklendi)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Phase_Touchline"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 9999999
ScreenGui.Parent = TargetParent

-- MAIN FRAME (ANA PANEL)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 540, 0, 340)
MainFrame.Position = UDim2.new(0.5, -270, 0.5
