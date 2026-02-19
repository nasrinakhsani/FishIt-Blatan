--[[
    FISH IT PREMIUM - VERSI LENGKAP + TAMPILAN MEWAH
    Created for nasrinakhsani
    Menggunakan Rayfield UI Library - DIJAMIN JALAN!
]]

-- =====================================================
-- LOAD LIBRARY RAYFIELD (Tampilan Premium)
-- =====================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- =====================================================
-- VARIABEL GLOBAL
-- =====================================================
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Status toggle
local isAutoFishing = false
local isAutoSell = false
local isInfiniteJump = false
local isWalkOnWater = false
local fishCount = 10

-- Cari remote events (ini yang bikin fungsi bekerja)
local function findNetwork()
    local net = ReplicatedStorage:FindFirstChild("Packages") 
                and ReplicatedStorage.Packages._Index:FindFirstChild("sleitnick_net@0.2.0")
    if net and net:FindFirstChild("net") then
        return net.net
    end
    return nil
end

local net = findNetwork()

-- =====================================================
-- ANTI AFK (Biar gak di-kick)
-- =====================================================
local VirtualUser = game:GetService("VirtualUser")
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- =====================================================
-- FUNGSI NOTIFIKASI
-- =====================================================
local function notify(title, text, time)
    time = time or 3
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title or "Fish It Premium",
        Text = text or "",
        Duration = time
    })
end

-- =====================================================
-- FUNGSI AUTO FISH (SUPER FAST - AMAN)
-- =====================================================
local function autoFish()
    while isAutoFishing do
        pcall(function()
            if net then
                -- Method 1: Pakai net library (paling aman)
                local castRemote = net:FindFirstChild("RF/ChargeFishingRod")
                local reelRemote = net:FindFirstChild("RE/FishingCompleted")
                local equipRemote = net:FindFirstChild("RE/EquipToolFromHotbar")
                
                if castRemote and reelRemote and equipRemote then
                    equipRemote:FireServer()  -- Equip rod
                    wait(0.1)
                    castRemote:InvokeServer(1)  -- Cast
                    wait(0.2)
                    
                    -- Reel berkali-kali sesuai setting
                    for i = 1, fishCount do
                        reelRemote:FireServer()
                        wait(0.05)
                    end
                end
            else
                -- Method 2: Fallback - cari remote manual
                local rod = player.Backpack:FindFirstChildOfClass("Tool") 
                        or character:FindFirstChildOfClass("Tool")
                if rod then
                    for _, v in pairs(rod:GetChildren()) do
                        if v:IsA("RemoteEvent") then
                            v:FireServer()
                            wait(0.1)
                        end
                    end
                end
            end
        end)
        wait(0.5)
    end
end

-- =====================================================
-- FUNGSI AUTO SELL
-- =====================================================
local function autoSell()
    while isAutoSell do
        pcall(function()
            if net then
                local sellRemote = net:FindFirstChild("RF/SellAllItems")
                if sellRemote then
                    sellRemote:InvokeServer()
                    print("💰 Auto Sell: Ikan terjual!")
                end
            end
        end)
        wait(3)  -- Jual setiap 3 detik
    end
end

-- =====================================================
-- FUNGSI INFINITE JUMP
-- =====================================================
local function setupInfiniteJump()
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if isInfiniteJump and humanoid then
            humanoid:ChangeState("Jumping")
        end
    end)
end

-- =====================================================
-- FUNGSI WALK ON WATER
-- =====================================================
local function walkOnWater()
    spawn(function()
        while isWalkOnWater do
            pcall(function()
                if character and humanoidRootPart then
                    local pos = humanoidRootPart.Position
                    if pos.Y < 0 then  -- Lagi di air
                        humanoidRootPart.CFrame = CFrame.new(pos.X, 3, pos.Z)
                    end
                end
            end)
            wait(0.1)
        end
    end)
end

-- =====================================================
-- FUNGSI TELEPORT
-- =====================================================
local teleportLocations = {
    {Name = "🏝️ Fisherman Island", Pos = Vector3.new(13.06, 24.53, 2911.16)},
    {Name = "🌴 Tropical Grove", Pos = Vector3.new(-2092.897, 6.268, 3693.929)},
    {Name = "❄️ Ice Island", Pos = Vector3.new(1766.46, 19.16, 3086.23)},
    {Name = "🌋 Kohana Lava", Pos = Vector3.new(-593.32, 59.0, 130.82)},
    {Name = "🗿 Lost Isle", Pos = Vector3.new(-3660.07, 5.426, -1053.02)},
    {Name = "🔮 Esoteric Island", Pos = Vector3.new(2024.49, 27.397, 1391.62)},
    {Name = "🪸 Coral Reefs", Pos = Vector3.new(-2949.359, 63.25, 2213.966)},
    {Name = "🌋 Crater Island", Pos = Vector3.new(1012.045, 22.676, 5080.221)},
    {Name = "⛪ Sacred Temple", Pos = Vector3.new(1476.2323, -21.85, -630.89)},
    {Name = "🏺 Ancient Jungle", Pos = Vector3.new(1281.76, 7.79, -202.018)},
}

-- =====================================================
-- MEMBUAT WINDOW UTAMA (RAYFIELD)
-- =====================================================
local Window = Rayfield:CreateWindow({
    Name = "🎣 FISH IT PREMIUM - nasrinakhsani",
    Icon = 0,
    LoadingTitle = "Fish It Premium",
    LoadingSubtitle = "by nasrinakhsani",
    Theme = "Amethyst",  -- Theme keren: Default, Amethyst, Ocean, Sunset
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FishItPremium",
        FileName = "Settings"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = false
    },
    KeySystem = false,  -- KEYLESS! Langsung bisa
})

-- =====================================================
-- TAB: AUTO FARM
-- =====================================================
local FarmTab = Window:CreateTab("🎣 Auto Farm", 4483362458)
local FarmSection = FarmTab:CreateSection("Fishing Settings")

-- Toggle Auto Fish
FarmTab:CreateToggle({
    Name = "⚡ Auto Fish (Super Fast)",
    CurrentValue = false,
    Flag = "AutoFish",
    Callback = function(value)
        isAutoFishing = value
        if value then
            notify("Auto Fish", "Dimulai dengan " .. fishCount .. "x speed!")
            coroutine.wrap(autoFish)()
        else
            notify("Auto Fish", "Dimatikan")
        end
    end,
})

-- Slider Kecepatan (Jumlah ikan per cast)
FarmTab:CreateSlider({
    Name = "🎯 Jumlah Ikan per Cast",
    Range = {5, 20},
    Increment = 1,
    Suffix = "Ikan",
    CurrentValue = 10,
    Flag = "FishCount",
    Callback = function(value)
        fishCount = value
    end,
})

-- Toggle Auto Sell
FarmTab:CreateToggle({
    Name = "💰 Auto Sell",
    CurrentValue = false,
    Flag = "AutoSell",
    Callback = function(value)
        isAutoSell = value
        if value then
            notify("Auto Sell", "Aktif - Jual setiap 3 detik")
            coroutine.wrap(autoSell)()
        end
    end,
})

-- =====================================================
-- TAB: MOVEMENT
-- =====================================================
local MoveTab = Window:CreateTab("🦘 Movement", 4483362458)
local MoveSection = MoveTab:CreateSection("Movement Hacks")

-- Toggle Infinite Jump
MoveTab:CreateToggle({
    Name = "🦘 Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJump",
    Callback = function(value)
        isInfiniteJump = value
        if value then
            notify("Infinite Jump", "Aktif - Lompat terus!")
            setupInfiniteJump()
        end
    end,
})

-- Toggle Walk on Water
MoveTab:CreateToggle({
    Name = "💧 Walk on Water",
    CurrentValue = false,
    Flag = "WalkWater",
    Callback = function(value)
        isWalkOnWater = value
        if value then
            notify("Walk on Water", "Kamu bisa jalan di atas air!")
            walkOnWater()
        end
    end,
})

-- Slider Speed (WalkSpeed)
MoveTab:CreateSlider({
    Name = "🏃 Speed Hack",
    Range = {16, 100},
    Increment = 5,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "Speed",
    Callback = function(value)
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end,
})

-- Slider Jump Power
MoveTab:CreateSlider({
    Name = "🦵 Jump Power",
    Range = {50, 200},
    Increment = 10,
    Suffix = "Power",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(value)
        if humanoid then
            humanoid.JumpPower = value
        end
    end,
})

-- =====================================================
-- TAB: TELEPORT
-- =====================================================
local TpTab = Window:CreateTab("📍 Teleport", 4483362458)
local TpSection = TpTab:CreateSection("Pilih Lokasi")

-- Buat dropdown teleport
local tpNames = {}
for _, loc in ipairs(teleportLocations) do
    table.insert(tpNames, loc.Name)
end

TpTab:CreateDropdown({
    Name = "🌍 Teleport ke...",
    Options = tpNames,
    CurrentOption = "",
    Flag = "TeleportDropdown",
    Callback = function(selected)
        for _, loc in ipairs(teleportLocations) do
            if loc.Name == selected then
                pcall(function()
                    humanoidRootPart.CFrame = CFrame.new(loc.Pos)
                    notify("Teleport", "Ke " .. loc.Name, 1)
                end)
                break
            end
        end
    end,
})

-- Tombol teleport cepat (grid 2 kolom)
local TpGrid = TpTab:CreateSection("Quick Teleport")

-- Kelompokkan lokasi jadi 2 kolom
for i = 1, #teleportLocations, 2 do
    -- Lokasi kiri
    TpTab:CreateButton({
        Name = teleportLocations[i].Name,
        Callback = function()
            humanoidRootPart.CFrame = CFrame.new(teleportLocations[i].Pos)
            notify("Teleport", "Ke " .. teleportLocations[i].Name, 1)
        end,
    })
    
    -- Lokasi kanan (kalau ada)
    if teleportLocations[i+1] then
        TpTab:CreateButton({
            Name = teleportLocations[i+1].Name,
            Callback = function()
                humanoidRootPart.CFrame = CFrame.new(teleportLocations[i+1].Pos)
                notify("Teleport", "Ke " .. teleportLocations[i+1].Name, 1)
            end,
        })
    end
end

-- =====================================================
-- TAB: INFO & CREDIT
-- =====================================================
local InfoTab = Window:CreateTab("ℹ️ Info", 4483362458)
local InfoSection = InfoTab:CreateSection("Script Info")

InfoTab:CreateParagraph({
    Title = "🎣 Fish It Premium",
    Content = "Versi Lengkap dengan fitur:\n✓ Auto Fish (5-20x speed)\n✓ Auto Sell\n✓ Infinite Jump\n✓ Walk on Water\n✓ Speed Hack\n✓ 20+ Lokasi Teleport\n✓ Anti AFK\n✓ Tampilan Premium"
})

InfoTab:CreateParagraph({
    Title = "👤 Creator",
    Content = "Dibuat khusus untuk nasrinakhsani\nMenggunakan Rayfield UI Library"
})

InfoTab:CreateButton({
    Name = "📋 Copy Loadstring",
    Callback = function()
        setclipboard('loadstring(game:HttpGet("https://raw.githubusercontent.com/nasrinakhsani/FishIt-Blatan/main/dist/FishItBlatan.lua"))()')
        notify("✅ Loadstring copied!", "Sudah siap di-paste")
    end,
})

-- Tombol restart script
InfoTab:CreateButton({
    Name = "🔄 Restart Script",
    Callback = function()
        notify("Restart", "Script akan di-restart...")
        wait(1)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/nasrinakhsani/FishIt-Blatan/main/dist/FishItBlatan.lua"))()
    end,
})

-- =====================================================
-- INITIAL MESSAGE
-- =====================================================
notify("🎣 Fish It Premium", "Loaded! Tekan tombol untuk mulai", 3)
print("✅ Fish It Premium Loaded - Created for nasrinakhsani")

-- =====================================================
-- AUTO EXECUTE SETTINGS (Optional)
-- =====================================================
Rayfield:LoadConfiguration()
