-- main.lua
local GitHubRawURL = "https://raw.githubusercontent.com/aras737/CustomSaveInstance/main/"

local function LoadModule(moduleName)
    local url = GitHubRawURL .. "modules/" .. moduleName .. ".lua"
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url, true))()
    end)
    if success then return result else warn("Modül yüklenemedi: " .. moduleName) end
end

print("==== Aras SaveInstance Başlıyor ====")

-- 1. Haritayı Yükle (Eksik çıkmasını önlemek için)
local Bypass = LoadModule("StreamingBypass")
if Bypass then Bypass.LoadMap() end

-- 2. Objeleri Tara
local Scanner = LoadModule("Scanner")
local objList = {}
if Scanner then objList = Scanner.GetInstances() end

-- 3. Dosyaya Kaydet
local Serializer = LoadModule("Serializer")
if Serializer and #objList > 0 then 
    Serializer.SaveToJSON(objList) 
end

print("==== İşlem Bitti ====")
