-- ARAS V2: DIRECT RBXL EXPORT
local repo = "https://raw.githubusercontent.com/aras737/CustomSaveInstance/main/"

-- [EKRAN PANELI]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 120)
MainFrame.Position = UDim2.new(0.5, -150, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
local corner = Instance.new("UICorner", MainFrame)
local Status = Instance.new("TextLabel", MainFrame)
Status.Size = UDim2.new(1, 0, 1, 0)
Status.Text = "RBXL OLUŞTURULUYOR...\nLÜTFEN BEKLE KANKA"
Status.TextColor3 = Color3.new(1, 1, 1)
Status.BackgroundTransparency = 1
Status.TextSize = 18

-- [ANA KOPYALAMA MOTORU]
task.spawn(function()
    -- Harita taramasını geçiyoruz, direkt motoru çağırıyoruz
    local ssi_url = "https://raw.githubusercontent.com/luau/SynSaveInstance/main/saveinstance.luau"
    local synsaveinstance = loadstring(game:HttpGet(ssi_url, true))()

    local Options = {
        Mode = "full", -- Her şeyi al
        FilePath = "Aras_Kopya_" .. game.PlaceId .. ".rbxl",
        Decompile = false, -- Çökmeyi önlemek için kapalı (harita öncelikli)
        NilInstances = true,
        SaveTerrain = true,
        IgnoreSlowInstances = false
    }

    -- Kopyalamayı başlat
    local success, err = pcall(function()
        synsaveinstance(Options)
    end)

    if success then
        Status.Text = "BİTTİ! ✅\n'workspace' klasörüne bak."
        Status.TextColor3 = Color3.new(0, 1, 0)
    else
        Status.Text = "HATA OLUŞTU! ❌"
        warn(err)
    end
end)
