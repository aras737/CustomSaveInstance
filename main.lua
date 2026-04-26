-- [[ ARAS V11: THE GOD-MODE UNIVERSAL SAVER ]]
-- Map kopyalama + Script Decompile (En İyi Sürüm)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [DEX STYLE MASTER UI]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 400)
MainFrame.Position = UDim2.new(0.5, -225, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- Neon Kenarlık
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 255, 127)
Stroke.Thickness = 2
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Başlık
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "  ARAS V11 - SUPREME COPY ENGINE"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Title.Font = Enum.Font.Code
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Log Paneli (Dex Style)
local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -140)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Scroll.CanvasSize = UDim2.new(0, 0, 50, 0)
Scroll.ScrollBarThickness = 2

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 2)

-- Alt Göstergeler
local Footer = Instance.new("Frame", MainFrame)
Footer.Size = UDim2.new(1, -20, 0, 70)
Footer.Position = UDim2.new(0, 10, 1, -80)
Footer.BackgroundTransparency = 1

local Status = Instance.new("TextLabel", Footer)
Status.Size = UDim2.new(1, 0, 0, 25)
Status.Text = "SİSTEM: Motor Bekleniyor..."
Status.TextColor3 = Color3.fromRGB(0, 255, 127)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Code

local ProgressLabel = Instance.new("TextLabel", Footer)
ProgressLabel.Position = UDim2.new(0, 0, 0, 25)
ProgressLabel.Size = UDim2.new(1, 0, 0, 20)
ProgressLabel.Text = "OBJE: 0 | SCRIPT: 0"
ProgressLabel.TextColor3 = Color3.new(1, 1, 1)
ProgressLabel.BackgroundTransparency = 1

-- [MOTORU ÇALIŞTIR]
task.spawn(function()
    -- 1. Karakter Güvenliği
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.Anchored = true
    hrp.CFrame = CFrame.new(0, 5000, 0)

    Status.Text = "SİSTEM: Decompiler Motoru Yükleniyor..."
    
    -- En Güncel SaveInstance Kütüphanesi
    local saveinstance = loadstring(game:HttpGet("https://raw.githubusercontent.com/luau/SynSaveInstance/main/saveinstance.luau", true))()

    -- [EN İYİ AYARLAR]
    local options = {
        Mode = "full", -- Her şeyi al
        FilePath = "Aras_Supreme_Copy.rbxl",
        NilInstances = true, -- Gizli objeleri yakala
        SaveTerrain = true,  -- Haritadaki Terrain'i (dağ, taş) al
        Decompile = true,    -- SCRIPTLERİ KOPYALA (Kritik özellik!)
        DecompileTimeout = 10, -- Script başına 10 saniye tanı
        RemovePlayerCharacters = true, -- Oyuncuları sil (Temiz harita)
        IgnoreSlowInstances = false,   -- Hiçbir şeyi atlama
        Callback = function(data)
            if data.Instance then
                local l = Instance.new("TextLabel", Scroll)
                l.Size = UDim2.new(1, 0, 0, 16)
                l.BackgroundTransparency = 1
                l.TextColor3 = Color3.fromRGB(200, 200, 200)
                l.Text = " > " .. data.Instance.Name .. " [" .. data.Instance.ClassName .. "]"
                l.Font = Enum.Font.Code
                l.TextSize = 10
                l.TextXAlignment = Enum.TextXAlignment.Left
                Scroll.CanvasPosition = Vector2.new(0, 99999)
            end
            ProgressLabel.Text = "OBJE: " .. (data.Count or 0) .. " | İLERLEME: %" .. math.floor(data.Progress or 0)
        end
    }

    Status.Text = "SİSTEM: KOPYALAMA VE DECOMPILE BAŞLADI!"
    
    local success, err = pcall(function()
        saveinstance(options)
    end)

    hrp.Anchored = false
    if success then
        Status.Text = "SİSTEM: TAMAMLANDI! ✅"
    else
        Status.Text = "HATA: " .. tostring(err)
        warn("Hata Detayı: " .. err)
    end
end)
