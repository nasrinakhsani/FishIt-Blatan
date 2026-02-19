--[[
    FISH IT PROPER - BY NASRINAKHSANI
    Fitur: Auto Fish No Delay, Auto Sell All, Teleport, Auto Equip
    Size: Ringan & Cepat
]]

-- Cek game ID
if game.PlaceId == 121864768012064 then
    local CurrentVersion = "🎣 FISH IT PROPER v2.0"

    -- LOAD MERCURY LIBRARY (Lebih ringan & stabil)
    local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeehub/exec/main/mercury.lua"))()
    
    -- MAIN GUI
    local GUI = Mercury:Create{
        Name = CurrentVersion,
        Size = UDim2.fromOffset(500, 400),
        Theme = Mercury.Themes.Dark,
        Link = "https://github.com/nasrinakhsani"
    }

    -- =====================================================
    -- VARIABEL & REMOTE (YANG BENER)
    -- =====================================================
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    
    -- NET REMOTE (Ini kunci utamanya!)
    local net = ReplicatedStorage.Packages._Index:FindFirstChild("sleitnick_net@0.2.0")
    if net then
        net = net.net
    else
        -- Fallback cari pake pattern
        for _, v in pairs(ReplicatedStorage.Packages._Index:GetChildren()) do
            if v.Name:find("sleitnick_net") then
                net = v:FindFirstChild("net")
                if net then break end
            end
        end
    end

    if not net then
        Mercury:Prompt("Gagal load net remote!", "Error")
        return
    end

    -- Status toggle
    local isFarming = false
    local isSelling = false
    local catchCount = 10  -- BLATAN: 10x lipat!

    -- =====================================================
    -- TAB: AUTO FARM (SEMUA FITUR DI SINI)
    -- =====================================================
    local FarmTab = GUI:Tab{
        Name = "⚡ AUTO FARM",
        Icon = "rbxassetid://4483345998"
    }

    -- 🔥 BLATAN MODE (AUTO FISH SUPER CEPAT)
    FarmTab:Toggle{
        Name = "🔥 BLATAN MODE",
        StartingState = false,
        Description = "Mancing cepet 5-20x lipat + auto equip",
        Callback = function(state)
            isFarming = state
            task.spawn(function()
                while isFarming do
                    pcall(function()
                        -- AUTO EQUIP ROD
                        net:FindFirstChild("RE/EquipToolFromHotbar"):FireServer()
                        task.wait(0.05)
                        
                        -- CAST (Charge rod)
                        net:FindFirstChild("RF/ChargeFishingRod"):InvokeServer(1)
                        task.wait(0.05)
                        
                        -- BLATAN: Multiple catch sesuai setting
                        for i = 1, catchCount do
                            net:FindFirstChild("RF/RequestFishingMinigameStarted"):InvokeServer(1, 1)
                            net:FindFirstChild("RE/FishingCompleted"):FireServer()
                            
                            -- Notif setiap 3 kali catch (biar tau jalan)
                            if i % 3 == 0 then
                                Mercury:Prompt("⚡ Blatan: " .. i .. "x catch!", "Info")
                            end
                            task.wait(0.02)  -- Delay super kecil
                        end
                    end)
                    task.wait(0.1)  -- Cooldown antar siklus
                end
            end)
        end
    }

    -- 🎚️ SLIDER JUMLAH CATCH (5-20)
    FarmTab:Slider{
        Name = "🎚️ Jumlah Catch per Siklus",
        Default = 10,
        Min = 5,
        Max = 20,
        Callback = function(value)
            catchCount = value
            Mercury:Prompt("Blatan set ke " .. value .. "x catch", "Settings")
        end
    }

    -- =====================================================
    -- TAB: AUTO SELL
    -- =====================================================
    local SellTab = GUI:Tab{
        Name = "💰 AUTO SELL",
        Icon = "rbxassetid://4483345876"
    }

    -- AUTO SELL ALL
    SellTab:Toggle{
        Name = "💰 Auto Sell All Items",
        StartingState = false,
        Description = "Jual semua ikan otomatis tiap 1 detik",
        Callback = function(state)
            isSelling = state
            task.spawn(function()
                while isSelling do
                    pcall(function()
                        net:FindFirstChild("RF/SellAllItems"):InvokeServer()
                        Mercury:Prompt("💰 Ikan terjual!", "Sell")
                    end)
                    task.wait(1)
                end
            end)
        end
    }

    -- =====================================================
    -- TAB: TELEPORT (20+ LOKASI)
    -- =====================================================
    local TpTab = GUI:Tab{
        Name = "📍 TELEPORT",
        Icon = "rbxassetid://4483345432"
    }

    -- DAFTAR LOKASI LENGKAP
    local teleportSpots = {
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
        {Name = "⚙️ Weather Machine", Pos = Vector3.new(-1495.25, 6.5, 1889.92)},
        {Name = "💎 Enchant Altar", Pos = Vector3.new(3236.12, -1302.855, 1399.491)},
        {Name = "🦪 Treasure Hall", Pos = Vector3.new(-3598.39, -275.82, -1641.46)},
        {Name = "🗿 Sishypus Statue", Pos = Vector3.new(-3693.96, -135.57, -1027.28)},
        {Name = "⬆️ Lever Diamond", Pos = Vector3.new(1819, 8.45, -284)},
        {Name = "🌙 Lever Crescent", Pos = Vector3.new(1420, 31.2, 79)},
        {Name = "⏳ Lever Hourglass", Pos = Vector3.new(1486, 6.82, -857)},
        {Name = "🏹 Lever Arrow", Pos = Vector3.new(898.137, 8.45, -363.173)},
    }

    -- Dropdown Teleport
    local tpNames = {}
    for _, spot in ipairs(teleportSpots) do
        table.insert(tpNames, spot.Name)
    end

    TpTab:Dropdown{
        Name = "📍 Pilih Lokasi",
        StartingText = "Klik untuk pilih lokasi",
        Items = tpNames,
        Callback = function(selected)
            for _, spot in ipairs(teleportSpots) do
                if spot.Name == selected then
                    local char = player.Character or player.CharacterAdded:Wait()
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.CFrame = CFrame.new(spot.Pos)
                        Mercury:Prompt("Teleport ke " .. spot.Name, "📍 Berhasil")
                    end
                    break
                end
            end
        end
    }

    -- =====================================================
    -- TAB: INFO
    -- =====================================================
    local InfoTab = GUI:Tab{
        Name = "ℹ️ INFO",
        Icon = "rbxassetid://4483345211"
    }

    InfoTab:Paragraph{
        Name = "📋 FITUR LENGKAP:",
        Content = "✓ BLATAN MODE (5-20x catch)\n✓ Auto Equip Rod\n✓ Auto Sell All Items\n✓ 20+ Lokasi Teleport\n✓ Anti AFK Built-in\n✓ Ringan & Cepat"
    }

    InfoTab:Paragraph{
        Name = "👤 CREATOR:",
        Content = "Script by nasrinakhsani\nVersi: " .. CurrentVersion
    }

    InfoTab:Button{
        Name = "📋 Copy Loadstring",
        Callback = function()
            setclipboard('loadstring(game:HttpGet("https://raw.githubusercontent.com/nasrinakhsani/FishIt-Blatan/main/dist/FishItBlatan.lua"))()')
            Mercury:Prompt("Loadstring copied!", "✅")
        end
    }

    -- =====================================================
    -- ANTI AFK (BUILT-IN)
    -- =====================================================
    local VirtualUser = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)

    -- Welcome message
    Mercury:Prompt("🎣 Fish It Proper Loaded! BLATAN mode siap!", "Selamat datang")

    -- Auto execute (optional)
    -- task.wait(1)
    -- isFarming = true  -- Uncomment kalau mau auto start
end
