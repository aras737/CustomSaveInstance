-- ARAS V5: DEX STYLE EXPLORER & FULL ENGINE
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [DEX STYLE PANEL - HER DETAYI GÖSTERİR]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 420, 0, 320)
MainFrame.Position = UDim2.new(0.5, -210, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 170, 255)
Stroke.Thickness = 2

local function addLabel(txt, y, clr, sz)
    local l = Instance.new("TextLabel", MainFrame)
    l.Position = UDim2.new(0, 15, 0, y)
    l.Size = UDim2.new(1, -30, 0, 25)
    l.Text = txt
    l.TextColor3 = clr or Color3.new(1,1,1)
    l.TextSize = sz or 14
    l.BackgroundTransparency = 1
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = Enum.Font.Code -- Yazılımcı tipi, Dex gibi görünür
    return l
end

addLabel("ARAS EXPLORER V5 - KOPYALAMA ÜSSÜ", 10, Color3.fromRGB(0, 170, 255), 16)
local Status = addLabel("DURUM: Hazırlanıyor...", 45, Color3.new(1, 1, 0))
local CurrentPath = addLabel("YOL: ---", 75, Color3.new(0.8, 0.8, 0.8), 12)
local CurrentObj = addLabel("OBJE: ---", 100, Color3.new(1, 1, 1), 12)
local Counter = addLabel("TOPLAM VERİ: 0", 130, Color3.new(0, 1, 0))
local ServiceProgress = addLabel("AKTİF SERVİS: Bekleniyor...", 160, Color3.fromRGB(255, 100, 0))

-- İlerleme Barı
local Bar = Instance.new("Frame", MainFrame)
Bar.Position = UDim2.new(0, 15, 0, 200)
Bar.Size = UDim2.new(1, -30, 0, 10)
Bar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
local Fill = Instance.new("Frame", Bar)
Fill.Size = UDim2.new(0, 0, 1, 0)
Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

-- [KUSURSUZ KOPYALAMA MOTORU]
task.spawn(function()
    Status.Text = "DURUM: Karakter Gökyüzüne Sabitlendi"
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.Anchored = true
    hrp.CFrame = CFrame.new(0, 2000, 0) -- Çok yukarısı, güvenli bölge

    Status.Text = "DURUM: Motor ve Dex Verileri Yükleniyor..."
    local synsaveinstance = loadstring(game:HttpGet("https://raw.githubusercontent.com/luau/SynSaveInstance/main/saveinstance.luau", true))()

    local Options = {
        Mode = "full",
        FilePath = "Aras_Full_Dex_Copy.rbxl",
        NilInstances = true, -- Gizli objeleri al
        SaveTerrain = true,  -- Yer şekillerini al
        Decompile = false,   -- Hız için kapalı
        IgnoreSlowInstances = false,
        Callback = function(data)
            local inst = data.Instance
            if inst then
                -- Dex gibi tam yolu göster (Game.Workspace.Part gibi)
                CurrentPath.Text = "YOL: game." .. inst:GetFullName()
                CurrentObj.Text = "OBJE: " .. inst.Name .. " (" .. inst.ClassName .. ")"
                
                -- Hangi ana serviste olduğumuzu anla
                local root = inst:FindFirstAncestorOfClass("DataModel") or inst.Parent
                ServiceProgress.Text = "AKTİF SERVİS: " .. tostring(root)
            end
            
            Counter.Text = "TOPLAM VERİ: " .. (data.Count or 0)
            Fill.Size = UDim2.new((data.Progress or 0) / 100, 0, 1, 0)
        end
    }

    Status.Text = "DURUM: KOPYALAMA BAŞLADI (Sistem Zorlanıyor)"
    Status.TextColor3 = Color3.new(0, 1, 0)

    local success, err = pcall(function()
        synsaveinstance(Options)
    end)

    if success then
        Status.Text = "DURUM: TAMAMLANDI! ✅"
        CurrentPath.Text = "Dosya: Delta/workspace/Aras_Full_Dex_Copy.rbxl"
    else
        Status.Text = "HATA: " .. tostring(err)
        warn("Kritik Hata: " .. err)
    end
    
    hrp.Anchored = false
end)
