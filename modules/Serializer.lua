-- modules/Serializer.lua
local Serializer = {}
local HttpService = game:GetService("HttpService")

function Serializer.SaveToJSON(objects)
    local dataToSave = {}
    print("Kaydetme işlemi başlıyor, oyunun boyutuna göre biraz sürebilir...")

    for i, obj in ipairs(objects) do
        local success, err = pcall(function()
            local objData = {
                ClassName = obj.ClassName,
                Name = obj.Name,
                ParentName = obj.Parent and obj.Parent.Name or "None",
                Properties = {}
            }

            -- Temel Parça (Part) Özelliklerini Al
            if obj:IsA("BasePart") then
                objData.Properties.Size = {obj.Size.X, obj.Size.Y, obj.Size.Z}
                objData.Properties.CFrame = tostring(obj.CFrame)
                objData.Properties.Color = tostring(obj.Color)
                objData.Properties.Anchored = obj.Anchored
                objData.Properties.CanCollide = obj.CanCollide
                objData.Properties.Transparency = obj.Transparency
                objData.Properties.Material = tostring(obj.Material)
            end

            -- Özel Modelleri (Mesh) Al
            if obj:IsA("MeshPart") or obj:IsA("SpecialMesh") then
                objData.Properties.MeshId = obj.MeshId
                objData.Properties.TextureID = obj.TextureId or obj.TextureID
            end

            table.insert(dataToSave, objData)
        end)

        -- Oyun çökmesin diye her 1000 objede bir nefes aldırıyoruz (Çok Önemli!)
        if i % 1000 == 0 then
            task.wait() 
        end
    end

    print("Veriler birleştiriliyor...")
    local jsonResult = HttpService:JSONEncode(dataToSave)
    
    -- Bilgisayarına dosya olarak kaydetme
    if writefile then
        writefile("Aras_Kopya.json", jsonResult)
        print("BAŞARILI! Dosya 'workspace' klasörüne 'Aras_Kopya.json' olarak kaydedildi.")
    else
        warn("HATA: Kullandığın executor dosya kaydetmeyi desteklemiyor!")
    end
end

return Serializer
