-- TEST SCRIPT UNTUK DELTA
print("🚀 TEST SCRIPT BERJALAN")
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "BERHASIL",
    Text = "Script test bisa jalan di Delta!",
    Duration = 5
})

-- Cuma nampilin GUI sederhana
local ScreenGui = Instance.new("ScreenGui")
local TextLabel = Instance.new("TextLabel")
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui
TextLabel.Parent = ScreenGui
TextLabel.Text = "DELTA BISA JALAN!"
TextLabel.Size = UDim2.new(0, 200, 0, 50)
TextLabel.Position = UDim2.new(0.5, -100, 0.5, -25)
TextLabel.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.FontSize = Enum.FontSize.Size24
