-- ARAS V2: FULL VISUAL & LIVE TRACKER
local repo = "https://raw.githubusercontent.com/aras737/CustomSaveInstance/main/"
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [GELİŞMİŞ GÖRSEL PANEL]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 220)
MainFrame.Position = UDim2.new(0.5, -175, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
local corner = Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "ARAS KOPYALAMA MERKEZİ"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Position = UDim2.new(0, 10, 0, 40)
StatusLabel.Size = UDim2.new(1, -20, 0, 25)
StatusLabel.Text = "Durum: Başlatılıyor..."
StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.BackgroundTransparency = 1

local CurrentObjLabel = Instance.new("TextLabel", MainFrame)
CurrentObjLabel.Position = UDim2.new(0, 10, 0, 70)
CurrentObjLabel.Size = UDim2.new(1, -20, 0, 25)
CurrentObjLabel.Text = "Obje: Bekleniyor..."
CurrentObjLabel.TextColor3 = Color3.fromRGB(255, 255, 0) -- Sarı (Dikkat çekici)
CurrentObjLabel.TextSize = 12
CurrentObjLabel.TextXAlignment = Enum.TextXAlignment.Left
CurrentObjLabel.BackgroundTransparency = 1

local ProgressLabel = Instance.new("TextLabel", MainFrame)
ProgressLabel.Position = UDim2.new(0, 10, 0, 100)
ProgressLabel.Size = UDim2.new(1, -20, 0, 25)
ProgressLabel.Text = "Toplam Obje: 0 | Yüzde: %0"
ProgressLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
ProgressLabel.TextXAlignment = Enum.TextXAlignment.Left
ProgressLabel.BackgroundTransparency = 1

-- İlerleme Çubuğu
local BarBg = Instance.new("Frame", MainFrame)
BarBg.Position = UDim2.new(0, 10, 0, 135)
BarBg.Size = UDim2.new(1, -20, 0, 12)
BarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
local Fill = Instance.new("Frame", BarBg)
Fill.Size = UDim2.new(0, 0, 1, 0)
Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)

-- [DETAYLI SÜREÇ]
task.spawn(function()
    -- 1. ADIM: HAYALET TARAMA (GÖRSEL GERİ BİLDİRİMLİ)
    StatusLabel.Text = "Durum: Harita Verisi Zorlanıyor..."
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    
    local range = 4000
    local step = 800
    local points = {}
    for x = -range, range, step do
        for z = -range, range, step do
            table.insert(points, Vector3.new(x, 1200, z))
        end
    end

    for i, pos in ipairs(points) do
        StatusLabel.Text = "Durum: Tarama (" .. i .. "/" .. #points .. ")"
        CurrentObjLabel.Text = "Konum: X:" .. math.floor(pos.X) .. " Z:" .. math.floor(pos.Z)
        hrp.CFrame = CFrame.new(pos)
        LocalPlayer:RequestStreamAroundAsync(pos)
        task.wait(0.2)
    end

    -- 2. ADIM: KOPYALAMA BAŞLANGICI
    StatusLabel.Text = "Durum: Motor Hazırlanıyor..."
    local ssi_url = "https://raw.githubusercontent.com/luau/SynSaveInstance/main/saveinstance.luau"
    local synsaveinstance = loadstring(game:HttpGet(ssi_url, true))()

    local Options = {
        Mode = "full",
        FilePath = "Aras_Kopya_" .. game.PlaceId .. ".rbxl",
        Decompile = false, -- Çökmemesi için false, sonra istersen açarız.
        Callback = function(data)
            -- CANLI VERİ BURADA AKIYOR
            local count = data.Count or 0
            local progress = data.Progress or 0
            local current = data.Instance and data.Instance.Name or "İşleniyor..."
            
            ProgressLabel.Text = "Toplam Obje: " .. count .. " | Yüzde: %" .. math.floor(progress)
            CurrentObjLabel.Text = "Şu an: " .. current
            Fill.Size = UDim2.new(progress / 100, 0, 1, 0)
        end
    }

    StatusLabel.Text = "Durum: DİSK'E YAZILIYOR (RBXL)..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 0)

    local success, err = pcall(function()
        synsaveinstance(Options)
    end)

    if success then
        StatusLabel.Text = "TAMAMLANDI! ✅"
        StatusLabel.TextColor3 = Color3.new(0, 1, 0)
        CurrentObjLabel.Text = "Dosya Delta klasöründe hazır."
    else
        StatusLabel.Text = "HATA OLUŞTU! ❌"
        CurrentObjLabel.Text = "Hata detayı console'da."
        warn(err)
    end
end)
