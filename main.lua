-- Aras Ultimate SaveInstance - Eksiksiz Kopyalama
print("==== Aras SaveInstance Başlatılıyor ====")

-- 1. ADIM: STREAMING BYPASS (Haritanın yarısının eksik gelmesini önler)
local function LoadFullMap()
    print("Harita yükleniyor... Lütfen bekleyin (Streaming Bypass)")
    local player = game:GetService("Players").LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    
    -- Haritanın uzak köşelerini kontrol et ve yüklet
    local scanRange = 2500 -- Menzili artırabilirsin
    local points = {
        Vector3.new(scanRange, 0, scanRange),
        Vector3.new(-scanRange, 0, scanRange),
        Vector3.new(scanRange, 0, -scanRange),
        Vector3.new(-scanRange, 0, -scanRange),
        Vector3.new(0, 500, 0)
    }

    for _, pos in pairs(points) do
        player:RequestStreamAroundAsync(pos)
        task.wait(0.5)
    end
    print("Harita parçaları belleğe çekildi.")
end

-- 2. ADIM: KAYDETME MOTORUNU ÇEK VE AYARLA
local function StartSave()
    local Params = {
        RepoURL = "https://raw.githubusercontent.com/luau/SynSaveInstance/main/",
        SSI = "saveinstance",
    }

    local synsaveinstance = loadstring(game:HttpGet(Params.RepoURL .. Params.SSI .. ".luau", true), Params.SSI)()

    local Options = {
        Mode = "full",                 -- Her şeyi kopyala
        Decompile = true,              -- Scriptleri çöz
        NilInstances = true,           -- Gizli objeleri bul
        RemovePlayerCharacters = true, -- Oyuncuları temizle (kalabalık yapmasın)
        SaveTerrain = true,            -- Toprağı/Suyu kaçırma
        IgnoreSlowInstances = false,   -- Yavaş yüklenenleri bekle (Eksiksiz olması için)
        FilePath = "Aras_Oyun_Kopyasi.rbxl" -- Dosya adı
    }

    print("Kopyalama başladı... Dosya .rbxl olarak kaydedilecek.")
    synsaveinstance(Options)
    print("İŞLEM TAMAM! Executor klasöründeki 'workspace' içine bak kanka.")
end

-- ÇALIŞTIR
LoadFullMap()
task.wait(1)
StartSave()
