-- [[ ARAS V12: THE OVERLORD - DEEP SCAN ENGINE ]]
-- Her şeyi yükler, gizli saklı bırakmaz.

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- [DEX STYLE ULTIMATE UI]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 480, 0, 420)
MainFrame.Position = UDim2.new(0.5, -240, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(255, 0, 0) -- Agresif Kırmızı
Stroke.Thickness = 2

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "  ARAS V12 - DEEP SCAN OVERLORD"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
Title.Font = Enum.Font.Code
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -160)
Scroll.Position = UDim2.new(0, 10, 0, 55)
Scroll.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Scroll.CanvasSize = UDim2.new(0, 0, 100, 0)
Scroll.ScrollBarThickness = 3

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 2)

local Status = Instance.new("TextLabel", MainFrame)
Status.Position = UDim2.new(0, 15, 1, -100)
Status.Size = UDim2.new(1, -30, 0, 30)
Status.Text = "SİSTEM: Bekleniyor..."
Status.TextColor3 = Color3.fromRGB(255, 255, 0)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Code

-- [ANA MOTOR]
task.spawn(function()
    -- 1. STREAMING ENABLED BYPASS (Haritayı Zorla Yükleme)
    Status.Text = "MOD: Harita Parçaları Zorla Yükleniyor (Streaming Bypass)..."
    local mapParts = Workspace:GetDescendants()
    for i, v in ipairs(mapParts) do
        if v:IsA("BasePart") then
            -- Kamerayı kısa süreliğine oraya odaklanmış gibi kandırır
            LocalPlayer.ReplicationFocus = v
            if i % 100 == 0 then task.wait() end -- Crash engelleme
        end
    end
    
    Status.Text = "MOD: Decompiler & SaveInstance Yükleniyor..."
    local saveinstance = loadstring(game:HttpGet("https://raw.githubusercontent.com/luau/SynSaveInstance/main/saveinstance.luau", true))()

    -- [EN DERİN KOPYALAMA AYARLARI]
    local options = {
        Mode = "full", 
        FilePath = "Aras_Full_World.rbxl",
        NilInstances = true,    -- Parent'ı olmayan (gizli) objeleri al
        SaveTerrain = true,     -- Su, kum, dağ verilerini al
        Decompile = true,       -- Scriptleri (Local/Module) çöz ve kopyala
        DecompileTimeout = 15,  -- Karmaşık scriptler için daha fazla süre
        IgnoreSlowInstances = false, 
        ObjectBlacklist = {},   -- Hiçbir şeyi engelleme
        Callback = function(data)
            if data.Instance then
                local l = Instance.new("TextLabel", Scroll)
                l.Size = UDim2.new(1, 0, 0, 16)
                l.BackgroundTransparency = 1
                l.TextColor3 = Color3.fromRGB(255, 255, 255)
                l.Text = " [+] " .. data.Instance:GetFullName()
                l.Font = Enum.Font.Code
                l.TextSize = 10
                l.TextXAlignment = Enum.TextXAlignment.Left
                Scroll.CanvasPosition = Vector2.new(0, 999999)
            end
            Status.Text = "KOPYALANAN: " .. (data.Count or 0) .. " | İLERLEME: %" .. math.floor(data.Progress or 0)
        end
    }

    Status.Text = "SİSTEM: DERİN TARAMA BAŞLADI - TELEFONU ELLEME!"
    Status.TextColor3 = Color3.fromRGB(0, 255, 0)

    local success, err = pcall(function()
        saveinstance(options)
    end)

    if success then
        Status.Text = "İŞLEM TAMAMLANDI! Dosya: workspace/Aras_Full_World.rbxl"
    else
        Status.Text = "KRİTİK HATA: " .. tostring(err)
    end
end)
