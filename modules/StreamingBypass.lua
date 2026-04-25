-- modules/StreamingBypass.lua
local StreamingBypass = {}

function StreamingBypass.LoadMap()
    local player = game:GetService("Players").LocalPlayer
    if not workspace.StreamingEnabled then
        print("Streaming kapalı, tüm harita zaten yüklü!")
        return true
    end

    print("Harita yükleniyor, lütfen bekleyin...")
    -- Haritanın köşelerine doğru request atarak chunk'ları yüklemeye zorlar
    local points = {
        Vector3.new(1000, 0, 1000), Vector3.new(-1000, 0, 1000),
        Vector3.new(1000, 0, -1000), Vector3.new(-1000, 0, -1000),
        Vector3.new(0,0,0)
    }

    for _, pos in ipairs(points) do
        player:RequestStreamAroundAsync(pos)
        task.wait(0.5) -- Yüklenmesi için zaman tanı
    end
    print("Harita chunk'ları zorla yüklendi!")
    return true
end

return StreamingBypass
