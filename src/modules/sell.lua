echo "local Sell = {}
local player = game.Players.LocalPlayer

function Sell:AutoSell(interval)
    interval = interval or 5
    print(\"💰 Auto sell started every \" .. interval .. \" seconds\")
    
    while _G.AutoSell do
        pcall(function()
            -- Cari NPC penjual
            local seller = game:GetService(\"Workspace\"):FindFirstChild(\"SellNPC\")
                        or game:GetService(\"Workspace\"):FindFirstChild(\"Merchant\")
                        or game:GetService(\"Workspace\"):FindFirstChild(\"Fisherman\")
            
            if seller and seller:FindFirstChild(\"HumanoidRootPart\") then
                -- Teleport ke seller
                local hrp = player.Character and player.Character:FindFirstChild(\"HumanoidRootPart\")
                if hrp then
                    hrp.CFrame = seller.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                    wait(0.5)
                    
                    -- Cari remote sell
                    local sellRemote = game:GetService(\"ReplicatedStorage\"):FindFirstChild(\"SellFish\")
                                    or game:GetService(\"ReplicatedStorage\"):FindFirstChild(\"Sell\")
                                    or game:GetService(\"ReplicatedStorage\"):FindFirstChild(\"SellItem\")
                    
                    if sellRemote then
                        sellRemote:FireServer()
                        print(\"💰 Ikan terjual!\")
                    end
                end
            end
        end)
        wait(interval)
    end
end

function Sell:Stop()
    _G.AutoSell = false
    print(\"⏹️ Auto sell stopped\")
end

return Sell
" > src/modules/sell.lua
