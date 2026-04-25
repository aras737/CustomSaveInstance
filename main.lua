-- ARAS V2: THE BEAST EDITION
-- Repo: https://github.com/aras737/CustomSaveInstance

local repo = "https://raw.githubusercontent.com/aras737/CustomSaveInstance/main/"
local HttpService = game:GetService("HttpService")

-- [1. HAVALI & BİLGİLENDİRİCİ GUI]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 150)
MainFrame.Position = UDim2.new(0.5, -150, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0

local corner = Instance.new("UICorner", MainFrame)
corner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "ARAS ULTIMATE V2"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Position = UDim2.new(0, 10, 0, 45)
StatusLabel.Size = UDim2.new(1, -20, 0, 30)
StatusLabel.Text = "Sistem Bekleniyor..."
StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.TextSize = 14
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

local ProgressLabel = Instance.new("TextLabel", MainFrame)
ProgressLabel.Position = UDim2.new(0, 10, 0, 75)
ProgressLabel.Size = UDim2.new(1, -20, 0, 30)
ProgressLabel.Text = "Obje: 0 | Yüzde: %0"
ProgressLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
ProgressLabel.TextSize = 14
ProgressLabel.BackgroundTransparency = 1
ProgressLabel.TextXAlignment = Enum.TextXAlignment.Left

-- [3. ANTI-AFK SİSTEMİ]
local function StartAntiAfk()
    local vu = game:GetService("VirtualUser")
    game.Players.LocalPlayer.Idled:Connect(function()
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
        StatusLabel.Text = "Status: Anti-AFK Tetiklendi!"
    end)
    print("✅ Anti-AFK Aktif")
end

-- [4. REMOTE EVENT LOGGER]
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

-- [2. SMART DECOMPILE & ANA MOTOR]
local function StartCopy()
    StatusLabel.Text = "Status: Harita Yükleniyor (Streaming Bypass)..."
    StartAntiAfk()
    StartRemoteLog()
    
    -- Streaming Bypass modülünü çağır
    pcall(function()
        loadstring(game:HttpGet(repo .. "modules/StreamingBypass.lua"))().LoadMap()
    end)

    StatusLabel.Text = "Status: Kopyalama Başladı..."
    
    local ssi_url = "https://raw.githubusercontent.com/luau/SynSaveInstance/main/saveinstance.luau"
    local synsaveinstance = loadstring(game:HttpGet(ssi_url, true))()

    local Options = {
        Mode = "full",
        FilePath = "Aras_TheBeast_" .. game.PlaceId .. ".rbxl",
        -- SMART DECOMPILE AYARI:
        Decompile = true, 
        DecompileIgnore = {"Chat", "ControlScript", "RbxCharacterSounds"}, -- Gereksizleri atla, çökmeyi engelle
        DecompileTimeout = 15,
        
        NilInstances = true,
        SaveTerrain = true,
        Callback = function(data)
            -- GUI GÜNCELLEME
            ProgressLabel.Text = "Obje: " .. (data.Count or 0) .. " | İşlem: " .. (data.Status or "Bekliyor")
        end
    }

    local success, err = pcall(function()
        synsaveinstance(Options)
    end)

    if success then
        StatusLabel.Text = "Status: TAMAMLANDI!"
        StatusLabel.TextColor3 = Color3.new(0, 1, 0)
    else
        StatusLabel.Text = "HATA: " .. tostring(err)
        StatusLabel.TextColor3 = Color3.new(1, 0, 0)
    end
end

-- BAŞLAT
task.spawn(StartCopy)
