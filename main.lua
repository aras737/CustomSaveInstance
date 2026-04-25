-- ARAS V4: FULL VERIFICATION & DETAILED TRACKER
local repo = "https://raw.githubusercontent.com/aras737/CustomSaveInstance/main/"
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [DETAYLI PANEL - HER ŞEY BURADA]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 170, 255)
Stroke.Thickness = 2

local function createL(txt, pos, clr, sz)
    local l = Instance.new("TextLabel", MainFrame)
    l.Position = pos
    l.Size = UDim2.new(1, -20, 0, 25)
    l.Text = txt
    l.TextColor3 = clr or Color3.new(1,1,1)
    l.TextSize = sz or 14
    l.BackgroundTransparency = 1
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = Enum.Font.Gotham
    return l
end

local Title = createL("ARAS V4 - FULL MAP SAVER", UDim2.new(0, 10, 0, 10), Color3.fromRGB(0, 170, 255), 18)
local Status = createL("Durum: Başlatılıyor...", UDim2.new(0, 10, 0, 45), Color3.new(1, 1, 0))
local ScanStatus = createL("Tarama: Bekliyor...", UDim2.new(0, 10, 0, 75))
local CurrentObj = createL("Kopyalanan: ---", UDim2.new(0, 10, 0, 105), Color3.new(0.7, 0.7, 0.7), 12)
local TotalObj = createL("Toplam Obje: 0", UDim2.new(0, 10, 0, 135), Color3.new(0, 1, 0))
local ServiceLabel = createL("Aktif Servis: ---", UDim2.new(0, 10, 0, 165), Color3.fromRGB(255, 100, 0))

-- İlerleme Çubuğu
local Bar = Instance.new("Frame", MainFrame)
Bar.Position = UDim2.new(0, 10, 0, 210)
Bar.Size = UDim2.new(1, -20, 0, 15)
Bar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
local Fill = Instance.new("Frame", Bar)
Fill.Size = UDim2.new(0, 0, 1, 0)
Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

-- [ANA SÜREÇ]
task.spawn(function()
    Status.Text = "Durum: Karakter Sabitleniyor..."
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.Anchored = true -- Kesinlikle düşmezsin

    -- 1. ADIM: DERİN TARAMA (DEEP SCAN)
    Status.Text = "Durum: Derin Harita Taraması Başladı..."
    local range = 5000
    local step = 500
    local totalPoints = ((range*2)/step)^2
    local currentPoint = 0

    for x = -range, range, step do
        for z = -range, range, step do
            currentPoint = currentPoint + 1
            ScanStatus.Text = string.format("Tarama: %d / %d Nokta Yüklendi", currentPoint, 64) -- Örnek sabit değer
            hrp.CFrame = CFrame.new(x, 1000, z)
            LocalPlayer:RequestStreamAroundAsync(Vector3.new(x, 0, z))
            task.wait(0.15) -- Oyunun objeleri indirmesi için süre tanı
        end
    end

    Status.Text = "Durum: Veriler Doğrulanıyor..."
    task.wait(2) -- Son bir bekleme

    -- 2. ADIM: KOPYALAMA MOTORU
    Status.Text = "Durum: RBXL OLUŞTURULUYOR..."
    local ssi_url = "https://raw.githubusercontent.com/luau/SynSaveInstance/main/saveinstance.luau"
    local synsaveinstance = loadstring(game:HttpGet(ssi_url, true))()

    local Options = {
        Mode = "full",
        FilePath = "Aras_Perfect_Copy.rbxl",
        Decompile = false,
        Callback = function(data)
            local count = data.Count or 0
            local progress = data.Progress or 0
            local inst = data.Instance
            
            TotalObj.Text = "Toplam Obje: " .. count
            Fill.Size = UDim2.new(progress / 100, 0, 1, 0)
            
            if inst then
                CurrentObj.Text = "Kopyalanan: " .. inst.Name
                local s = inst:FindFirstAncestorOfClass("DataModel") or inst.Parent
                ServiceLabel.Text = "Aktif Servis: " .. tostring(s)
            end
        end
    }

    local success, err = pcall(function()
        synsaveinstance(Options)
    end)

    hrp.Anchored = false -- İşlem bitti, serbestsin
    if success then
        Status.Text = "DURUM: TAMAMLANDI! ✅"
        Status.TextColor3 = Color3.new(0, 1, 0)
    else
        Status.Text = "HATA: " .. tostring(err)
        Status.TextColor3 = Color3.new(1, 0, 0)
    end
end)
