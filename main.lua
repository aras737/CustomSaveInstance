-- ARAS V7: REAL-TIME DEX TREE & FULL SAVER
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [DEX TREE VIEW PANEL]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 380)
MainFrame.Position = UDim2.new(0.5, -225, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(60, 60, 70)
Stroke.Thickness = 2

-- Başlık
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "  DEX EXPLORER & MAP SAVER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

-- Kaydırma Alanı (Dex'in ağaç yapısı için)
local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -120)
Scroll.Position = UDim2.new(0, 10, 0, 45)
Scroll.CanvasSize = UDim2.new(0, 0, 10, 0)
Scroll.ScrollBarThickness = 4
Scroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 2)

-- Alt Bilgi Paneli
local InfoFrame = Instance.new("Frame", MainFrame)
InfoFrame.Size = UDim2.new(1, -20, 0, 60)
InfoFrame.Position = UDim2.new(0, 10, 1, -70)
InfoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)

local Status = Instance.new("TextLabel", InfoFrame)
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Text = "DURUM: Hazırlanıyor..."
Status.TextColor3 = Color3.fromRGB(0, 255, 0)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Code

local Counter = Instance.new("TextLabel", InfoFrame)
Counter.Position = UDim2.new(0, 0, 0, 30)
Counter.Size = UDim2.new(1, 0, 0, 30)
Counter.Text = "TOPLAM OBJE: 0"
Counter.TextColor3 = Color3.fromRGB(255, 255, 255)
Counter.BackgroundTransparency = 1

-- [KOPYALAMA VE LİSTELEME FONKSİYONU]
local function updateTree(inst)
    local label = Instance.new("TextLabel", Scroll)
    label.Size = UDim2.new(1, 0, 0, 18)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 13
    label.Font = Enum.Font.Code
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Dex stili ağaç gösterimi
    local depth = #inst:GetFullName():split(".")
    label.Text = string.rep("  ", depth) .. "📂 " .. inst.Name .. " [" .. inst.ClassName .. "]"
    
    -- Kaydırmayı otomatik aşağı çek
    Scroll.CanvasPosition = Vector2.new(0, Scroll.AbsoluteWindowSize.Y)
end

task.spawn(function()
    -- Karakteri güvenliğe al
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.Anchored = true
    hrp.CFrame = CFrame.new(hrp.Position.X, 3000, hrp.Position.Z)

    -- Motoru yükle
    local saveinstance = loadstring(game:HttpGet("https://raw.githubusercontent.com/luau/SynSaveInstance/main/saveinstance.luau", true))()

    local Options = {
        Mode = "full",
        FilePath = "Aras_Full_Dex_Map.rbxl",
        NilInstances = true,
        SaveTerrain = true,
        Decompile = false,
        Callback = function(data)
            local inst = data.Instance
            if inst then
                updateTree(inst) -- Dex ağacına ekle
                Status.Text = "DURUM: Kopyalanıyor..."
            end
            Counter.Text = "TOPLAM OBJE: " .. (data.Count or 0)
        end
    }

    local success, err = pcall(function()
        saveinstance(Options)
    end)

    hrp.Anchored = false
    if success then
        Status.Text = "DURUM: BİTTİ! ✅"
    else
        Status.Text = "HATA: " .. tostring(err)
    end
end)
