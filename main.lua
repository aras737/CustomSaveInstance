-- [[ ARAS V13: THE COLOSSUS - BIG MAP EDITION ]]
-- 40MB+ Haritalar İçin Özel Optimize Edilmiş Sürüm

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- [UI TASARIMI - COLOSSUS DARK MODE]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 500, 0, 450)
MainFrame.Position = UDim2.new(0.5, -250, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 20)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 150, 255) -- Safir Mavisi
Stroke.Thickness = 3

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "  ARAS V13 - COLOSSUS ENGINE [40MB+]"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(0, 20, 40)
Title.Font = Enum.Font.Code
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -180)
Scroll.Position = UDim2.new(0, 10, 0, 60)
Scroll.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Scroll.CanvasSize = UDim2.new(0, 0, 200, 0) -- Çok fazla obje için geniş canvas
Scroll.ScrollBarThickness = 4

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 2)

local LogStatus = Instance.new("TextLabel", MainFrame)
LogStatus.Position = UDim2.new(0, 15, 1, -110)
LogStatus.Size = UDim2.new(1, -30, 0, 40)
LogStatus.Text = "SİSTEM: Dev Harita Taraması Bekleniyor..."
LogStatus.TextColor3 = Color3.fromRGB(0, 255, 255)
LogStatus.BackgroundTransparency = 1
LogStatus.Font = Enum.Font.Code
LogStatus.TextWrapped = true

-- [ANA MOTOR - COLOSSUS SCAN]
task.spawn(function()
    -- 1. AGRESİF CHUNK LOADING (Büyük Harita Çözümü)
    LogStatus.Text = "UYARI: Dev Harita Taranıyor. Telefon Isınabilir, Lütfen Bekle..."
    
    local allParts = Workspace:GetDescendants()
    local totalParts = #allParts
    
    for i, v in ipairs(allParts) do
        if v:IsA("BasePart") then
            -- Sanal bir "Göz" haritanın her yerini geziyor gibi simüle eder
            LocalPlayer.ReplicationFocus = v
            if i % 300 == 0 then -- Her 300 objede bir sistemi dinlendir (Crash Önleyici)
                LogStatus.Text = "YÜKLENEN PARÇA: " .. i .. "/" .. totalParts
                task.wait(0.1)
            end
        end
    end
    
    LogStatus.Text = "MOD: SaveInstance & Decompiler Yükleniyor..."
    -- En güçlü SaveInstance kütüphanesini çekiyoruz
    local saveinstance = loadstring(game:HttpGet("https://raw.githubusercontent.com/luau/SynSaveInstance/main/saveinstance.luau", true))()

    -- [MAKSİMUM DERİNLİK AYARLARI]
    local options = {
        Mode = "full", 
        FilePath = "Aras_Colossus_Map.rbxl",
        NilInstances = true,    -- Gizli saklı hiçbir şeyi bırakma
        SaveTerrain = true,     -- Su ve dağ yapılarını 1:1 al
        Decompile = true,       -- Scriptleri (Local/Module) tek tek çöz
        DecompileTimeout = 20,  -- Dev scriptler için süreyi artırdık
        IgnoreSlowInstances = false, 
        ExtraInstances = {game:GetService("ReplicatedStorage"), game:GetService("ServerStorage")}, -- Ekstra servisler
        Callback = function(data)
            if data.Instance then
                local l = Instance.new("TextLabel", Scroll)
                l.Size = UDim2.new(1, 0, 0, 16)
                l.BackgroundTransparency = 1
                l.TextColor3 = Color3.fromRGB(180, 255, 180)
                l.Text = " [SAVED] " .. data.Instance.Name
                l.Font = Enum.Font.Code
                l.TextSize = 10
                l.TextXAlignment = Enum.TextXAlignment.Left
                if data.Count % 10 == 0 then
                    Scroll.CanvasPosition = Vector2.new(0, 9999999)
                end
            end
            LogStatus.Text = "İLERLEME: %" .. math.floor(data.Progress or 0) .. " | OBJE: " .. (data.Count or 0)
        end
    }

    LogStatus.Text = "SİSTEM: COLOSSUS KOPYALAMA BAŞLADI - EKRANI KAPATMA!"
    LogStatus.TextColor3 = Color3.fromRGB(255, 165, 0)

    local success, err = pcall(function()
        saveinstance(options)
    end)

    if success then
        LogStatus.Text = "✅ TAMAMLANDI! workspace/Aras_Colossus_Map.rbxl konumuna kaydedildi."
        LogStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        LogStatus.Text = "❌ HATA: Bellek Yetmedi veya Executor Kapandı! Detay: " .. tostring(err)
        LogStatus.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)
