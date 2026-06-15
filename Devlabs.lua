--[[
    PHASE - TOUCHLINE | Tam Kopya UI (V11)
    Ekran görüntülerine %95+ uyumlu
--]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

-- Temizleme
if CoreGui:FindFirstChild("PhaseTouchline") then
    CoreGui:FindFirstChild("PhaseTouchline"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PhaseTouchline"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Ana Frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 620, 0, 380)
Main.Position = UDim2.new(0.5, -310, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Main.Parent = ScreenGui

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Text = "PHASE - TOUCHLINE"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(0.4, 0, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Close Button
local Close = Instance.new("TextButton")
Close.Text = "✕"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 18
Close.TextColor3 = Color3.fromRGB(170, 170, 170)
Close.BackgroundTransparency = 1
Close.Size = UDim2.new(0, 40, 0, 40)
Close.Position = UDim2.new(1, -45, 0, 5)
Close.Parent = Header

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Sidebar.Parent = Main

local SidebarList = Instance.new("UIListLayout", Sidebar)
SidebarList.Padding = UDim.new(0, 4)
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder

-- Content Area
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -170, 1, -60)
Content.Position = UDim2.new(0, 165, 0, 55)
Content.BackgroundTransparency = 1
Content.Parent = Main

-- Tab Sistemi
local tabs = {}
local pages = {}

local tabNames = {"Home", "Reach", "Ball", "Helpers", "Player", "FFlag", "Settings"}

for _, name in ipairs(tabNames) do
    -- Tab Button
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, -10, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.Text = "   " .. name
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.Parent = Sidebar
    
    -- Page
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 5
    page.CanvasSize = UDim2.new(0, 0, 0, 500)
    page.Visible = false
    page.Parent = Content
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 8)
    
    tabs[name] = btn
    pages[name] = page
end

-- İlk sekme açık
pages["Home"].Visible = true
tabs["Home"].BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tabs["Home"].TextColor3 = Color3.fromRGB(255, 255, 255)

-- Tab Switching
for name, btn in pairs(tabs) do
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        for _, b in pairs(tabs) do 
            b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            b.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        pages[name].Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end

-- ==================== İÇERİKLER ====================

-- Home
local function AddInfo(page, text)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -10, 0, 38)
    f.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    f.Parent = page
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -15, 1, 0)
    l.Position = UDim2.new(0, 15, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(220, 220, 220)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = Enum.Font.Gotham
    l.TextSize = 14
end

AddInfo(pages.Home, "DEVELOPER : 97rnn")
AddInfo(pages.Home, "Welcome, "..player.Name.."!")
AddInfo(pages.Home, "Executor: Delta")
AddInfo(pages.Home, "Access: PREMIUM")
AddInfo(pages.Home, "Status: UNDETECTED")

-- Reach & Ball & Helpers (Slider + Toggle örnekleri)
local function CreateToggle(page, title, default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 45)
    frame.Background
