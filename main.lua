-- ARAS V2: FORCE START EDITION
local repo = "https://raw.githubusercontent.com/aras737/CustomSaveInstance/main/"
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [GUI OLUŞTURMA]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 160)
MainFrame.Position = UDim2.new(0.5, -160, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
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
local ProgressLabel = Instance.new("TextLabel", MainFrame)
ProgressLabel.Position = UDim2.new(0, 15, 0, 80)
ProgressLabel.Size = UDim2.new(1, -30, 0, 25)
ProgressLabel.Text = "Obje: 0 | Durum: Bekliyor"
ProgressLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
ProgressLabel.TextSize = 14
ProgressLabel.BackgroundTransparency = 1

-- [ANA SÜREÇ]
task.spawn(function()
    -- 1. ADIM: Arka Planda Harita Tetikleme (Takılmayı engellemek için spawn içinde)
    task.spawn(function()
        StatusLabel.Text = "Durum: Harita Tetikleniyor..."
        local range = 2000
        for x = -range, range, 1000 do
            for z = -range, range, 1000 do
                LocalPlayer:RequestStreamAroundAsync(Vector3.new(x, 0, z))
                task.wait(0.1)
            end
        end
    end)

    task.wait(1) -- Kısa bir es ver ve hemen kopyalamaya geç

    -- 2. ADIM: Motoru Yükle
    StatusLabel.Text = "Durum: Motor Bağlanıyor..."
    local ssi_url = "https://raw.githubusercontent.com/luau/SynSaveInstance/main/saveinstance.luau"
    local success_ssi, synsaveinstance = pcall(function()
        return loadstring(game:HttpGet(ssi_url, true))()
    end)

    if not success_ssi then
        StatusLabel.Text = "Hata: Motor Yüklenemedi!"
        return
    end

    -- 3. ADIM: Kopyalamayı Zorla Başlat
    StatusLabel.Text = "Durum: KOPYALAMA BAŞLADI!"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)

    local Options = {
        Mode = "full",
        FilePath = "Aras_Kopya_" .. game.PlaceId .. ".rbxl",
        Decompile = false, -- Delta'da takılmaması için önce false yap, stabil çalışırsa true denersin
        NilInstances = true,
        SaveTerrain = true,
        Callback = function(data)
            ProgressLabel.Text = "Obje: " .. (data.Count or 0) .. " | Yüzde: %" .. (data.Progress or 0)
        end
    }

    local success, err = pcall(function()
        synsaveinstance(Options)
    end)

    if success then
        StatusLabel.Text = "Durum: TAMAMLANDI!"
        StatusLabel.TextColor3 = Color3.new(0, 1, 0)
        ProgressLabel.Text = "Dosya 'workspace' klasöründe!"
    else
        StatusLabel.Text = "Hata: " .. tostring(err)
        StatusLabel.TextColor3 = Color3.new(1, 0, 0)
        warn(err)
    end
end)
