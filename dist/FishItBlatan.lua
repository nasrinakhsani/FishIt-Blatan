-- Auto Fish Sederhana (Metode Umum)
local player = game.Players.LocalPlayer

local function autoFish()
    print("🟢 Auto Fish dimulai...")
    while wait(1) do -- Loop setiap 1 detik
        pcall(function()
            -- Cari rod di karakter atau backpack
            local rod = player.Character:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
            
            if rod then
                -- Cari remote event di dalam rod
                for _, remote in pairs(rod:GetChildren()) do
                    if remote:IsA("RemoteEvent") then
                        remote:FireServer() -- Pencet remote
                        print("  🎣 Mencasting...")
                        wait(0.2)
                    end
                end
            else
                print("  ❌ Rod tidak ditemukan. Pastikan Anda memegang pancing.")
            end
        end)
    end
end

-- Mulai auto fish
autoFish()
