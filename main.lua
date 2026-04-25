-- ARAS V2: GHOST-SCAN EDITION (ANTI-BAN)
local repo = "https://raw.githubusercontent.com/aras737/CustomSaveInstance/main/"
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [HAYALET TARAYICI - HIZLI VE GÖRÜNMEZ]
local function GhostScan()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local oldCFrame = hrp.CFrame
    
    -- Karakteri geçici olarak görünmez ve çarpışmasız yap (Ban riskini azaltır)
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end

    local range = 5000 -- Tarama alanı
    local step = 400   -- Atlayış mesafesi

    for x = -range, range, step do
        for z = -range, range, step do
            -- Önce kamerayı ve ReplicationFocus'u oraya odakla
            local targetPos = Vector3.new(x, 1000, z) -- Çok yüksekten uçuyoruz, kimse görmez
            hrp.CFrame = CFrame.new(targetPos)
            LocalPlayer:RequestStreamAroundAsync(targetPos)
            
            -- O kadar hızlı ki sunucu konumunu tam işlemeden veri çekilir
            game:GetService("RunService").Heartbeat:Wait()
        end
    end

    hrp.CFrame = oldCFrame -- İşlem bitince şak diye eski yerine dön
    print("✅ Hayalet Tarama Tamamlandı!")
end

-- [ANA KOPYALAYICI SÜRECİ]
task.spawn(function()
    -- 1. ADIM: Kimseye çaktırmadan her yeri gez
    GhostScan()

    -- 2. ADIM: Her şeyi .rbxl olarak dosyaya dök
    local ssi_url = "https://raw.githubusercontent.com/luau/SynSaveInstance/main/saveinstance.luau"
    local synsaveinstance = loadstring(game:HttpGet(ssi_url, true))()

    local Options = {
        Mode = "full",
        FilePath = "Aras_Full_World_" .. game.PlaceId .. ".rbxl",
        Decompile = false, -- En stabil dosya için kapalı tutuyoruz
        NilInstances = true,
        SaveTerrain = true,
        IgnoreSlowInstances = false -- Hiçbir şeyi atlama!
    }

    synsaveinstance(Options)
end)
