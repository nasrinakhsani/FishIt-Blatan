echo "local Blatan = {}
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

function Blatan:Start(count)
    count = count or 10
    print(\"🔥 Blatan mode started with \" .. count .. \" catches\")
    
    while _G.BlatanMode do
        local rod = player.Backpack:FindFirstChildOfClass(\"Tool\") 
                or character:FindFirstChildOfClass(\"Tool\")
        
        if rod then
            local events = {}
            for _, v in pairs(rod:GetChildren()) do
                if v:IsA(\"RemoteEvent\") then
                    table.insert(events, v)
                end
            end
            
            if #events >= 2 then
                -- Cast sekali
                events[1]:FireServer()
                wait(0.2)
                
                -- Reel berkali-kali (BLATAN!)
                for i = 1, count do
                    events[2]:FireServer()
                    if i % 5 == 0 then
                        print(\"⚡ Blatan: \" .. i .. \" ikan dapet!\")
                    end
                    wait(0.05)
                end
            else
                -- Fallback: fire semua remote
                for i = 1, count do
                    for _, remote in pairs(rod:GetChildren()) do
                        if remote:IsA(\"RemoteEvent\") then
                            remote:FireServer()
                            wait(0.02)
                        end
                    end
                end
            end
        end
        wait(0.8)
    end
end

function Blatan:Stop()
    _G.BlatanMode = false
    print(\"⏹️ Blatan mode stopped\")
end

return Blatan
" > src/modules/blatan.lua
