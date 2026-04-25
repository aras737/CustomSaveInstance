-- main.lua
-- GitHub deponun Raw bağlantısını buraya gireceğiz (Sen repo açınca güncelleriz)
local GitHubRawURL = "https://raw.githubusercontent.com/aras737/CustomSaveInstance/main/"

local function LoadModule(moduleName)
    local url = GitHubRawURL .. "modules/" .. moduleName .. ".lua"
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url, true))()
    end)
    if success then return result else warn("Modül yüklenemedi: " .. moduleName) end
end

print("==== Kendi SaveInstance'ımız Başlıyor ====")

-- 1. Aşama: Map'i tam yükle
local Bypass = LoadModule("StreamingBypass")
if Bypass then
    Bypass.LoadMap()
end

-- (Daha sonra buraya Scanner ve Serializer ekleyeceğiz)

print("==== İşlem Hazır ====")
