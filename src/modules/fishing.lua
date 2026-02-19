echo "local Fishing = {}

function Fishing:Cast()
    local player = game.Players.LocalPlayer
    local rod = player.Backpack:FindFirstChildOfClass(\"Tool\") 
            or player.Character:FindFirstChildOfClass(\"Tool\")
    
    if rod then
        for _, v in pairs(rod:GetChildren()) do
            if v:IsA(\"RemoteEvent\") and v.Name:lower():find(\"cast\") then
                v:FireServer()
                return true
            end
        end
    end
    return false
end

function Fishing:Reel()
    local player = game.Players.LocalPlayer
    local rod = player.Backpack:FindFirstChildOfClass(\"Tool\") 
            or player.Character:FindFirstChildOfClass(\"Tool\")
    
    if rod then
        for _, v in pairs(rod:GetChildren()) do
            if v:IsA(\"RemoteEvent\") and v.Name:lower():find(\"reel\") then
                v:FireServer()
                return true
            end
        end
    end
    return false
end

return Fishing
" > src/modules/fishing.lua

