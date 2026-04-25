--[[
    ARAS ULTIMATE V2: THE BEAST EDITION
    Özellikler: 
    - Kick-Safe Teleport Bypass (Replication Focus)
    - Havalı Progress GUI
    - Anti-AFK (20 Dakika Koruması)
    - Remote Event Logger
    - Delta Optimized Smart Decompile
]]

local repo = "https://raw.githubusercontent.com/aras737/CustomSaveInstance/main/"
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [1. HAVALI & BİLGİLENDİRİCİ GUI]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 160)
MainFrame.Position = UDim2.new(0.5, -160, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Paneli ekranda sürükleyebilirsin

local corner = Instance.new("UICorner", MainFrame)
corner.CornerRadius = UDim.new(0, 12)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 170, 255)
Stroke.Thickness = 2

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "ARAS ULTIMATE V2"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Position = UDim2.new(0, 15, 0, 50)
StatusLabel.Size = UDim2.new(1, -30, 0, 25)
StatusLabel.Text = "Durum: Hazırlanıyor..."
StatusLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
StatusLabel.TextSize = 14
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

local ProgressLabel = Instance.new("TextLabel", MainFrame)
ProgressLabel.Position = UDim2.new(0, 15, 0, 80)
ProgressLabel.Size = UDim2.new(1, -30, 0, 25)
ProgressLabel.Text = "Obje: 0 | Yüzde: %0"
ProgressLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
ProgressLabel.TextSize = 14
ProgressLabel.Font = Enum.Font.GothamSemibold
ProgressLabel.BackgroundTransparency = 1
ProgressLabel.TextXAlignment = Enum.TextXAlignment.Left

local CreditLabel = Instance.new("TextLabel", MainFrame)
CreditLabel.Position = UDim2.new(0, 15, 1, -25)
CreditLabel.Size = UDim2.new(1, -30, 0, 20)
CreditLabel.Text = "aras737 Custom SaveInstance"
CreditLabel.TextColor3 = Color3.new(0.4, 0.4, 0.4)
CreditLabel.TextSize = 11
CreditLabel.BackgroundTransparency = 1
CreditLabel.TextXAlignment = Enum.TextXAlignment.Right

-- [2. ANTI-AFK SİSTEMİ]
local function StartAntiAfk()
    if getgenv().ArasAntiAfk then return end
    getgenv().ArasAntiAfk = true
    LocalPlayer.Idled:Connect(function()
        local vu = game:GetService("VirtualUser")
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end)
    print("✅ Anti-AFK Aktif")
end

-- [3. REMOTE EVENT LOGGER]
local function StartRemoteLog()
    local remotes = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            table.insert(remotes, {Name = v.Name, Path = v:GetFullName(), Class = v.ClassName})
        end
    end
    if writefile then
        writefile("Aras_Remotes_" .. game.PlaceId .. ".json", HttpService:JSONEncode(remotes))
        print("✅ Remote'lar Kaydedildi")
    end
end

-- [4. ANA SÜREÇ]
local function Main()
    StartAntiAfk()
    StartRemoteLog()

    -- TELEPORT BYPASS (KICK-SAFE)
    StatusLabel.Text = "Durum: Harita Taranıyor (Kick-Safe)..."
    local successTP, TPModule = pcall(function()
        return loadstring(game:HttpGet(repo .. "modules/TeleportBypass.lua"))()
    end)
    
    if successTP and TPModule then
        TPModule.ScanFullMap()
    else
        warn("Teleport Bypass modülü yüklenemedi, normal kopyalamaya geçiliyor.")
    end

    -- KAYDETME MOTORU (UniversalSynSaveInstance)
    StatusLabel.Text = "Durum: Motor Yükleniyor..."
    local ssi_url = "https://raw.githubusercontent.com/luau/SynSaveInstance/main/saveinstance.luau"
    local synsaveinstance = loadstring(game:HttpGet(ssi_url, true))()

    local Options = {
        Mode = "full",
        FilePath = "Aras_TheBeast_" .. game.PlaceId .. ".rbxl",
        Decompile = true, 
        DecompileIgnore = {"Chat", "ControlScript", "RbxCharacterSounds"}, -- Delta'yı yormaz
        DecompileTimeout = 10,
        NilInstances = true,
        SaveTerrain = true,
        IncludePlayerGui = true,
        IgnoreSlowInstances = false,
        Callback = function(data)
            -- GUI GÜNCELLEME
            local count = data.Count or 0
            local status = data.Status or "İşleniyor"
            ProgressLabel.Text = "Obje: " .. count .. " | Durum: " .. status
            StatusLabel.Text = "Durum: Kopyalanıyor..."
        end
    }

    StatusLabel.Text = "Durum: KOPYALAMA BAŞLADI!"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)

    local success, err = pcall(function()
        synsaveinstance(Options)
    end)

    if success then
        StatusLabel.Text = "Durum: TAMAMLANDI!"
        StatusLabel.TextColor3 = Color3.new(0, 1, 0)
        ProgressLabel.Text = "Dosya 'workspace' klasörüne atıldı."
    else
        StatusLabel.Text = "HATA: " .. tostring(err)
        StatusLabel.TextColor3 = Color3.new(1, 0, 0)
        warn("Kopyalama Hatası: " .. err)
    end
end

-- ÇALIŞTIR
task.spawn(Main)
