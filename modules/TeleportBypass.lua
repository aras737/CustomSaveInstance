local TeleportBypass = {}

function TeleportBypass.ScanFullMap()
    local player = game:GetService("Players").LocalPlayer
    local camera = workspace.CurrentCamera
    
    -- Harita büyüklüğüne göre menzil (Artırabilirsin)
    local range = 4000 
    local step = 300 -- Daha sık tarama yaparak her objeyi tetikler
    
    print("🛰️ Görünmez Kamera Taraması Başladı (Kick Riskini Azaltır)...")

    for x = -range, range, step do
        for z = -range, range, step do
            -- Karakteri değil, sadece oyunun odak noktasını (Focus) değiştiriyoruz
            -- Bu sayede oyun o bölgedeki objeleri cihazına gönderir
            player.ReplicationFocus = nil -- Reset
            
            -- Geçici bir parça oluşturup odağı oraya veriyoruz
            local focusPart = Instance.new("Part")
            focusPart.Anchored = true
            focusPart.Transparency = 1
            focusPart.CanCollide = false
            focusPart.CFrame = CFrame.new(x, 100, z)
            focusPart.Parent = workspace
            
            player.ReplicationFocus = focusPart
            
            -- Oyunun yüklemesi için kısa bekleme
            task.wait(0.2) 
            
            focusPart:Destroy()
        end
        task.wait(0.1) -- Delta'yı yormamak için
    end
    
    player.ReplicationFocus = nil
    print("✅ Tüm objeler belleğe çekildi, artık kopyalanabilir!")
end

return TeleportBypass
