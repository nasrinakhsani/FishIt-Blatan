local Utils = {}

function Utils.AntiAFK()
    local VirtualUser = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        print("💤 Anti-AFK activated")
    end)
    print("🛡️ Anti-AFK enabled")
end

function Utils:Notify(title, text, time)
    time = time or 5
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = time
    })
end

function Utils:GetRod()
    local player = game.Players.LocalPlayer
    return player.Backpack:FindFirstChildOfClass("Tool") 
            or player.Character:FindFirstChildOfClass("Tool")
end

function Utils:TeleportTo(locationName)
    local player = game.Players.LocalPlayer
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
    if not hrp then return false end
    
    for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
        if v.Name == locationName and v:IsA("Part") then
            hrp.CFrame = v.CFrame * CFrame.new(0, 5, 0)
            return true
        end
    end
    return false
end

return Utils