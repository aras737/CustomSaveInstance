local TeleportBypass = {}

function TeleportBypass.ScanFullMap(range, step)
    local player = game:GetService("Players").LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local oldPos = hrp.CFrame

    range = range or 2500 -- Ne kadar uzağa gitsin?
    step = step or 500    -- Kaç metre aralıkla ışınlansın?

    print("🛰️ Teleport Bypass Başlatıldı...")

    -- Haritayı ızgara şeklinde gez (Grid Scan)
    for x = -range, range, step do
        for z = -range, range, step do
            -- Karakteri ışınla (Yüksekte tut ki yere düşmesin/ölmesin)
            hrp.CFrame = CFrame.new(Vector3.new(x, 500, z))
            
            -- Oyunun veriyi göndermesi için kısa bir süre bekle
            game:GetService("RunService").Heartbeat:Wait()
            player:RequestStreamAroundAsync(Vector3.new(x, 0, z))
            
            task.wait(0.1) -- Delta'nın çökmemesi için kısa es
        end
    end

    -- Karakteri eski yerine geri getir
    hrp.CFrame = oldPos
    print("✅ Tüm harita tarandı ve yüklendi!")
end

return TeleportBypass
