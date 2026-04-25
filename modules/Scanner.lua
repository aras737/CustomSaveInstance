-- modules/Scanner.lua
local Scanner = {}

function Scanner.GetInstances()
    local objects = {}
    -- Taranacak ana bölümler
    local services = {
        workspace, game:GetService("Lighting"), game:GetService("ReplicatedStorage"),
        game:GetService("StarterGui"), game:GetService("StarterPack")
    }

    print("Tarama başlatılıyor...")
    local count = 0

    for _, service in ipairs(services) do
        for _, obj in ipairs(service:GetDescendants()) do
            -- Oyuncuları ve karakterleri kopyalamamak için filtreliyoruz
            if not obj:IsA("Player") and not obj:IsAncestorOf(game.Players.LocalPlayer) then
                table.insert(objects, obj)
                count = count + 1
            end
        end
    end

    print("Tarama tamamlandı! " .. count .. " obje bulundu.")
    return objects
end

return Scanner
