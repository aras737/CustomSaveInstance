-- ARAS V3: GOD MODE & DETAILED PANEL
local repo = "https://raw.githubusercontent.com/aras737/CustomSaveInstance/main/"
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [DETAYLI PANEL TASARIMI]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 380, 0, 260)
MainFrame.Position = UDim2.new(0.5, -190, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 170, 255)
Stroke.Thickness = 2

local function createLabel(text, pos, color, size)
    local l = Instance.new("TextLabel", MainFrame)
    l.Position = pos
    l.Size = UDim2.new(1, -20, 0, 25)
    l.Text = text
    l.TextColor3 = color or Color3.new(1,1,1)
    l.TextSize = size or 14
    l.BackgroundTransparency = 1
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = Enum.Font.GothamSemibold
    return l
end

local Title = createLabel("ARAS V3 - KONTROL MERKEZİ", UDim2.new(0, 10, 0, 10), Color3.fromRGB(0, 170, 255), 18)
local Status = createLabel("Durum: Hazırlanıyor...", UDim2.new(0, 10, 0, 45), Color3.new(0.8, 0.8, 0.8))
local CurrentService = createLabel("Servis: ---", UDim2.new(0, 10, 0, 75), Color3.fromRGB(255, 165, 0))
local CurrentObj = createLabel("Obje: Bekleniyor...", UDim2.new(0, 10, 0, 105), Color3.new(1, 1, 1), 12)
local TotalCount = createLabel("Toplam Obje: 0", UDim2.new(0, 10, 0, 135), Color3.fromRGB(0, 255, 150))
local MemoryLabel = createLabel("Bellek Kullanımı: %0", UDim2.new(0, 10, 0, 165), Color3.new(0.6, 0.6, 0.6), 12)

-- İlerleme Barı
local Bar = Instance.new("Frame", MainFrame)
Bar.Position = UDim2.new(0, 10, 0, 205)
Bar.Size = UDim2.new(1, -20, 0, 15)
Bar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
local Fill = Instance.new("Frame", Bar)
Fill.Size = UDim2.new(0, 0, 1, 0)
Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)

-- [ANA SÜREÇ]
task.spawn(function()
    -- 1. ÖLÜMSÜZLÜK VE SABİTLEME
    Status.Text = "Durum: Ölümsüzlük Aktif Ediliyor..."
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    
    -- Karakteri havada dondur (Anchored) böylece düşüp ölmezsin
    hrp.Anchored = true
    hrp.CFrame = CFrame.new(hrp.Position.X, 1500, hrp.Position.Z) -- Seni gökyüzüne çıkarır

    -- 2. GHOST SCAN (HARİTA TETİKLEME)
    Status.Text = "Durum: Harita Verisi Çekiliyor..."
    local range = 4000
    local step = 1000
    for x = -range, range, step do
        for z = -range, range, step do
            local pos = Vector3.new(x, 1500, z)
            hrp.CFrame = CFrame.new(pos)
            LocalPlayer:RequestStreamAroundAsync(pos)
            task.wait(0.1)
        end
    end

    -- 3. KOPYALAMA MOTORU
    Status.Text = "Durum: Kopyalama Başladı!"
    local ssi_url = "https://raw.githubusercontent.com/luau/SynSaveInstance/main/saveinstance.luau"
    local synsaveinstance = loadstring(game:HttpGet(ssi_url, true))()

    local Options = {
        Mode = "full",
        FilePath = "Aras_Master_Copy.rbxl",
        Decompile = false,
        Callback = function(data)
            -- CANLI PANEL GÜNCELLEME
            local count = data.Count or 0
            local progress = data.Progress or 0
            local inst = data.Instance
            
            TotalCount.Text = "Toplam Obje: " .. count
            Fill.Size = UDim2.new(progress / 100, 0, 1, 0)
            
            if inst then
                CurrentObj.Text = "Obje: " .. inst.Name
                -- Hangi servisin kopyalandığını bul (Workspace mi, Lighting mi?)
                local service = inst:FindFirstAncestorOfClass("DataModel") or inst.Parent
                CurrentService.Text = "Servis: " .. tostring(service)
            end
        end
    }

    local success, err = pcall(function()
        synsaveinstance(Options)
    end)

    -- BİTİŞ
    hrp.Anchored = false -- Sabitlemeyi kaldır
    if success then
        Status.Text = "TAMAMLANDI! ✅"
        Status.TextColor3 = Color3.new(0, 1, 0)
    else
        Status.Text = "HATA! ❌"
        warn(err)
    end
end)
