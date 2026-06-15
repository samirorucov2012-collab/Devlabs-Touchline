-- [[ DEVLABS - TOUCHLINE PREMIUM EDITION ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Sistem Ayarları ve Hafıza (Gönderdiğin Yapı)
local SystemConfig = {
    LegReachEnabled = true,
    LegReachSize = 5, -- Slider değeri
    LegVisualizer = true,
    
    BallReachEnabled = true,
    BallReachSize = 5,
    BallVisualizer = true,
    BallCollision = false
}

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

local RuntimeLegPart = nil
local RuntimeBallPart = nil

-- Karakter Yenilenince Bağlantıları Tazele
LocalPlayer.CharacterAdded:Connect(function(NewChar)
    Character = NewChar
    RootPart = NewChar:WaitForChild("HumanoidRootPart")
    Humanoid = NewChar:WaitForChild("Humanoid")
end)

----------------------------------------------------
-- 1. MOBİL AÇMA/KAPAMA BUTONU (TOGGLE)
----------------------------------------------------
local ScreenGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("PHASE - TOUCHLINE") or Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "PHASE - TOUCHLINE"

-- Eğer eski ana menü çerçeven varsa onun adını "MainMenu" yap, yoksa kod otomatik eşler
local MainMenu = ScreenGui:FindFirstChild("MainFrame") -- Kendi UI Çerçevenin adı ile değiştirebilirsin

local MobileToggleButton = Instance.new("TextButton")
MobileToggleButton.Name = "DevLabs_MobileToggle"
MobileToggleButton.Size = UDim2.new(0, 50, 0, 50)
MobileToggleButton.Position = UDim2.new(0, 10, 0.5, -25) -- Sol orta ekran
MobileToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MobileToggleButton.Text = "⚡"
MobileToggleButton.TextColor3 = Color3.fromRGB(0, 255, 255)
MobileToggleButton.TextSize = 24
MobileToggleButton.Font = Enum.Font.GothamBold
MobileToggleButton.Parent = ScreenGui

-- Köşeleri yuvarla ve neon çizgi ekle
local UICorner = Instance.new("UICorner", MobileToggleButton)
UICorner.CornerRadius = UDim.new(0, 12)
local UIBorder = Instance.new("UIStroke", MobileToggleButton)
UIBorder.Color = Color3.fromRGB(130, 40, 230)
UIBorder.Width = 2

-- Sürükleme Özelliği (Mobilde taşınabilsin diye)
local dragging, dragInput, dragStart, startPos
MobileToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MobileToggleButton.Position
    end
end)
MobileToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MobileToggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
MobileToggleButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Açma/Kapama Tetikleyicisi
MobileToggleButton.MouseButton1Click:Connect(function()
    if MainMenu then
        MainMenu.Visible = not MainMenu.Visible
    else
        -- Eğer kodda MainMenu henüz tanımlanmadıysa otomatik ilk Frame'i bulur
        local FoundFrame = ScreenGui:FindFirstChildOfClass("Frame")
        if FoundFrame then
            FoundFrame.Visible = not FoundFrame.Visible
            MainMenu = FoundFrame
        end
    end
end)

----------------------------------------------------
-- 2. AVATAR STEALER FONKSİYONU
----------------------------------------------------
-- UI'daki TextBox'ına ve Button'ına bu fonksiyonu bağlayabilirsin
_G.AvatarStealer = function(TargetUsername)
    if TargetUsername == "" then return end
    local Success, TargetUserId = pcall(function()
        return Players:GetUserIdFromNameAsync(TargetUsername)
    end)
    
    if Success and TargetUserId then
        local CurrentHumanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if CurrentHumanoid then
            local Description = Players:GetHumanoidDescriptionFromUserId(TargetUserId)
            CurrentHumanoid:ApplyDescription(Description)
            print("[DevLabs] " .. TargetUsername .. " adlı oyuncunun kıyafetleri çalındı!")
        end
    else
        warn("[DevLabs] Kullanıcı adı bulunamadı.")
    end
end

----------------------------------------------------
-- 3. LEG REACH & BALL REACH PHYSICS ENGINE (Senin Kodun + Fix)
----------------------------------------------------
RunService.Heartbeat:Connect(function()
    if not RootPart or not Character:FindFirstChild("Humanoid") then return end

    -- Leg Reach Physics Engine Logic
    if SystemConfig.LegReachEnabled and SystemConfig.LegVisualizer then
        if not RuntimeLegPart or not RuntimeLegPart.Parent then
            RuntimeLegPart = Instance.new("Part")
            RuntimeLegPart.Name = "Touchline_LegReachPart"
            RuntimeLegPart.Shape = Enum.PartType.Ball
            RuntimeLegPart.Material = Enum.Material.ForceField
            RuntimeLegPart.Color = Color3.fromRGB(130, 40, 230) -- Neon Purple
            RuntimeLegPart.CastShadow = false
            RuntimeLegPart.CanCollide = false
            RuntimeLegPart.Anchored = false
            RuntimeLegPart.Parent = Character
            
            local ConnectionWeld = Instance.new("WeldConstraint")
            ConnectionWeld.Part0 = RootPart
            ConnectionWeld.Part1 = RuntimeLegPart
            ConnectionWeld.Parent = RuntimeLegPart

            -- Topa Dokunma Algılayıcısı (Leg Reach Hitbox Aktifleştirme)
            RuntimeLegPart.Touched:Connect(function(HitPart)
                if HitPart.Name == "Ball" or HitPart:SetAttribute("IsBall", true) or HitPart.Parent:FindFirstChild("Ball") then
                    -- Oyundaki topa vurma mekaniğini tetikler (Hitbox hitbox genişletme)
                    firetouchinterest(HitPart, Character:FindFirstChild("Right Foot") or RootPart, 0)
                    firetouchinterest(HitPart, Character:FindFirstChild("Right Foot") or RootPart, 1)
                end
            end)
        end
        RuntimeLegPart.Size = Vector3.new(SystemConfig.LegReachSize, SystemConfig.LegReachSize, SystemConfig.LegReachSize)
        RuntimeLegPart.Transparency = 0.7
    else
        if RuntimeLegPart then RuntimeLegPart:Destroy() RuntimeLegPart = nil end
    end

    -- Ball Reach Physics Engine Logic
    if SystemConfig.BallReachEnabled and SystemConfig.BallVisualizer then
        if not RuntimeBallPart or not RuntimeBallPart.Parent then
            RuntimeBallPart = Instance.new("Part")
            RuntimeBallPart.Name = "Touchline_BallReachPart"
            RuntimeBallPart.Shape = Enum.PartType.Ball
            RuntimeBallPart.Material = Enum.Material.ForceField
            RuntimeBallPart.Color = Color3.fromRGB(230, 40, 105) -- Distinct Pink/Red tone
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

print("[Phase System] Environment successfully initiated from strict imagery specifications.")
