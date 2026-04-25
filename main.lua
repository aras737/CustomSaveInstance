-- ARAS V2: THE BEAST EDITION + TELEPORT BYPASS
local repo = "https://raw.githubusercontent.com/aras737/CustomSaveInstance/main/"

-- [GUI VE DİĞER AYARLAR AYNI KALIYOR...]
-- (Buraya önceki GUI kodlarını eklediğini varsayıyorum)

local function StartCopy()
    StatusLabel.Text = "Status: Teleport Bypass Çalışıyor..."
    
    -- 1. ADIM: TELEPORT BYPASS (Haritayı Gezme)
    local successTP, TPModule = pcall(function()
        return loadstring(game:HttpGet(repo .. "modules/TeleportBypass.lua"))()
    end)
    
    if successTP then
        -- 3000 metre çapında, 500 metre aralıklarla tara
        TPModule.ScanFullMap(3000, 500)
    end

    StatusLabel.Text = "Status: Motor Yükleniyor..."
    
    -- 2. ADIM: KAYDETME MOTORUNU ÇALIŞTIR
    local ssi_url = "https://raw.githubusercontent.com/luau/SynSaveInstance/main/saveinstance.luau"
    local synsaveinstance = loadstring(game:HttpGet(ssi_url, true))()

    local Options = {
        Mode = "full",
        FilePath = "Aras_Full_Map_" .. game.PlaceId .. ".rbxl",
        Decompile = true,
        NilInstances = true,
        SaveTerrain = true,
        -- Kopyalama sırasında objeleri saydır
        Callback = function(data)
            ProgressLabel.Text = "Obje: " .. (data.Count or 0) .. " | Durum: " .. (data.Status or "İşleniyor")
        end
    }

    synsaveinstance(Options)
    StatusLabel.Text = "✅ KOPYALAMA BİTTİ!"
end

task.spawn(StartCopy)
