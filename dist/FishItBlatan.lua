--[[
    FISH IT ULTRA MINIMAL - PASTI JALAN
]]

-- Tunggu bentar biar game load
wait(2)

-- Anti AFK dasar
game.Players.LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

-- GUI minimal
local screenGui = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local btnAuto = Instance.new("TextButton")
local statusText = Instance.new("TextLabel")

screenGui.Parent = game.Players.LocalPlayer.PlayerGui
screenGui.Name = "FishItMini"
screenGui.ResetOnSpawn = false

mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 250, 0, 150)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.2
mainFrame.Active = true
mainFrame.Draggable = true

statusText.Parent = mainFrame
statusText.Size = UDim2.new(1, 0, 0, 40)
statusText.Position = UDim2.new(0, 0, 0, 10)
statusText.BackgroundTransparency = 1
statusText.Text = "🐟 FISH IT MINI"
statusText.TextColor3 = Color3.fromRGB(0, 255, 255)
statusText.TextSize = 20

btnAuto.Parent = mainFrame
btnAuto.Size = UDim2.new(0.8, 0, 0, 40)
btnAuto.Position = UDim2.new(0.1, 0, 0, 60)
btnAuto.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
btnAuto.Text = "🔴 AUTO FISH OFF"
btnAuto.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Fungsi auto fish sederhana
local autoFishing = false
local fishingLoop

btnAuto.MouseButton1Click:Connect(function()
    autoFishing = not autoFishing
    
    if autoFishing then
        btnAuto.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        btnAuto.Text = "🟢 AUTO FISH ON"
        statusText.Text = "🐟 Auto fishing aktif"
        
        fishingLoop = coroutine.create(function()
            while autoFishing do
                print("Mancing...")
                -- Coba cari rod di backpack atau karakter
                local rod = game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool") 
                        or game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if rod then
                    -- Fire semua remote event yang ada di rod
                    for _, v in pairs(rod:GetChildren()) do
                        if v:IsA("RemoteEvent") then
                            v:FireServer()
                        end
                    end
                end
                wait(0.5)
            end
        end)
        coroutine.resume(fishingLoop)
        
    else
        btnAuto.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
        btnAuto.Text = "🔴 AUTO FISH OFF"
        statusText.Text = "⏸️ Auto fishing mati"
    end
end)

-- Notifikasi siap
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Fish It Mini",
    Text = "Script siap! Klik tombol untuk mulai",
    Duration = 3
})
