-- ARAS V2: ALL-IN-ONE FIX
local repo = "https://raw.githubusercontent.com/aras737/CustomSaveInstance/main/"
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [GUI OLUŞTURMA - BURASI AYNI]
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
StatusLabel.Text = "Durum: Başlatılıyor..."
StatusLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
StatusLabel.TextSize = 14
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
local ProgressLabel = Instance.new("TextLabel", MainFrame)
ProgressLabel.Position = UDim2.new(0, 15, 0, 80)
ProgressLabel.Size = UDim2.new(1, -30, 0, 25)
ProgressLabel.Text = "Obje: 0 | Hazır: %0"
ProgressLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
ProgressLabel.TextSize = 14
ProgressLabel.Font = Enum.Font.GothamSemibold
ProgressLabel.BackgroundTransparency = 1
ProgressLabel.TextXAlignment = Enum.TextXAlignment.Left

-- [TELEPORT BYPASS - İÇERİ GÖMDÜK]
local function ScanMap()
    StatusLabel.Text = "Durum: Harita Taranıyor (Görünmez)..."
    local range = 3000 -- Menzili Delta için biraz düşürdük (daha stabil)
    local step = 600
    
    for x = -range, range, step do
        for z = -range, range, step do
            local focus = Instance.new("Part")
            focus.Anchored = true
            focus.Transparency = 1
            focus.Position = Vector3.new(x, 100, z)
            focus.Parent = workspace
            LocalPlayer.ReplicationFocus = focus
            task.wait(0.1) -- Hızlandırdık
            focus:Destroy()
        end
    end
    LocalPlayer.ReplicationFocus = nil
end

-- [ANA SÜREÇ]
task.spawn(function()
    -- Haritayı tara
    ScanMap()
    
    StatusLabel.Text = "Durum: Motor Yükleniyor..."
    local ssi_url = "https://raw.githubusercontent.com/luau/SynSaveInstance/main/saveinstance.luau"
    local success_ssi, synsaveinstance = pcall(function()
        return loadstring(game:HttpGet(ssi_url, true))()
    end)

    if not success_ssi then
        StatusLabel.Text = "Hata: Motor çekilemedi!"
        return
    end

    local Options = {
        Mode = "full",
        FilePath = "Aras_Kopya_" .. game.PlaceId .. ".rbxl",
        Decompile = true,
        NilInstances = true,
        SaveTerrain = true,
        IgnoreSlowInstances = false,
        Callback = function(data)
            ProgressLabel.Text = "Obje: " .. (data.Count or 0) .. " | Durum: " .. (data.Status or "İşleniyor")
        end
    }

    StatusLabel.Text = "Durum: KOPYALANIYOR..."
    local success, err = pcall(function()
        synsaveinstance(Options)
    end)

    if success then
        StatusLabel.Text = "Durum: TAMAMLANDI!"
        StatusLabel.TextColor3 = Color3.new(0, 1, 0)
    else
        StatusLabel.Text = "Hata: " .. tostring(err)
    end
end)
