--[[
    FishIt Blatan Mode - VERSI LENGKAP
    Created by nasrinakhsani
    Fitur: Multiple Catch (5-20 ikan per cast)
    Untuk Delta Executor
]]

-- =====================================================
-- AUTO EXECUTE
-- =====================================================
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Variabel global
_G.BlatanMode = false
_G.MultiCastCount = 10
_G.AutoSell = false
_G.AutoQuest = false
_G.InfiniteJump = false

-- =====================================================
-- NOTIFIKASI SEDERHANA
-- =====================================================
local function Notif(title, text, duration)
    duration = duration or 3
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration
    })
end

-- =====================================================
-- ANTI AFK
-- =====================================================
local VirtualUser = game:GetService("VirtualUser")
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- =====================================================
-- FUNGSI MENDAPATKAN ROD
-- =====================================================
local function getRod()
    return player.Backpack:FindFirstChildOfClass("Tool") 
            or character:FindFirstChildOfClass("Tool")
end

-- =====================================================
-- BLATAN MODE (MULTIPLE CATCH)
-- =====================================================
local function BlatanMode()
    while _G.BlatanMode do
        local rod = getRod()
        if rod then
            -- Cari semua remote event di rod
            local castRemote = nil
            local reelRemote = nil
            local otherRemotes = {}
            
            for _, v in pairs(rod:GetChildren()) do
                if v:IsA("RemoteEvent") then
                    if v.Name:lower():find("cast") then
                        castRemote = v
                    elseif v.Name:lower():find("reel") or v.Name:lower():find("catch") then
                        reelRemote = v
                    else
                        table.insert(otherRemotes, v)
                    end
                end
            end
            
            -- Prioritaskan yang udah ketemu
            if castRemote and reelRemote then
                -- Cast sekali
                castRemote:FireServer()
                wait(0.2)
                
                -- Reel berkali-kali (BLATAN!)
                for i = 1, _G.MultiCastCount do
                    reelRemote:FireServer()
                    if i % 5 == 0 then
                        print("⚡ Blatan: " .. i .. " kali reel")
                    end
                    wait(0.05)
                end
            else
                -- Fallback: fire semua remote yang ada
                for i = 1, _G.MultiCastCount do
                    for _, remote in pairs(rod:GetChildren()) do
                        if remote:IsA("RemoteEvent") then
                            remote:FireServer()
                            wait(0.03)
                        end
                    end
                end
            end
        end
        wait(0.8)
    end
end

-- =====================================================
-- AUTO SELL
-- =====================================================
local function AutoSell()
    while _G.AutoSell do
        pcall(function()
            -- Cari NPC penjual
            local seller = game:GetService("Workspace"):FindFirstChild("SellNPC")
                        or game:GetService("Workspace"):FindFirstChild("Merchant")
                        or game:GetService("Workspace"):FindFirstChild("Fisherman")
            
            if seller and seller:FindFirstChild("HumanoidRootPart") then
                -- Teleport ke seller
                if humanoidRootPart then
                    humanoidRootPart.CFrame = seller.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                    wait(0.5)
                    
                    -- Cari remote sell
                    local sellRemote = game:GetService("ReplicatedStorage"):FindFirstChild("SellFish")
                                    or game:GetService("ReplicatedStorage"):FindFirstChild("Sell")
                    
                    if sellRemote then
                        sellRemote:FireServer()
                        print("💰 Ikan terjual!")
                    end
                end
            end
        end)
        wait(5)
    end
end

-- =====================================================
-- INFINITE JUMP
-- =====================================================
local function SetupInfiniteJump()
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if _G.InfiniteJump and humanoid then
            humanoid:ChangeState("Jumping")
        end
    end)
end

-- =====================================================
-- MEMBUAT GUI SEDERHANA (TANPA LIBRARY)
-- =====================================================
local function CreateGUI()
    -- Hapus GUI lama kalau ada
    for _, v in pairs(player.PlayerGui:GetChildren()) do
        if v.Name == "FishItGUI" then
            v:Destroy()
        end
    end
    
    -- Buat ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name = "FishItGUI"
    gui.Parent = player.PlayerGui
    gui.ResetOnSpawn = false
    
    -- Frame utama
    local frame = Instance.new("Frame")
    frame.Parent = gui
    frame.Size = UDim2.new(0, 300, 0, 400)
    frame.Position = UDim2.new(0.5, -150, 0.5, -200)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BackgroundTransparency = 0.1
    frame.Active = true
    frame.Draggable = true
    
    -- Judul
    local title = Instance.new("TextLabel")
    title.Parent = frame
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    title.Text = "🐟 FISHIT BLATAN"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 20
    
    -- Tombol tutup
    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = frame
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -30, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.TextSize = 20
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    
    local yPos = 50
    
    -- BLATAN MODE TOGGLE
    local blatanLabel = Instance.new("TextLabel")
    blatanLabel.Parent = frame
    blatanLabel.Size = UDim2.new(1, 0, 0, 30)
    blatanLabel.Position = UDim2.new(0, 0, 0, yPos)
    blatanLabel.BackgroundTransparency = 1
    blatanLabel.Text = "⚡ BLATAN MODE"
    blatanLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    blatanLabel.Font = Enum.Font.SourceSansBold
    blatanLabel.TextSize = 18
    
    yPos = yPos + 35
    
    local blatanToggle = Instance.new("TextButton")
    blatanToggle.Parent = frame
    blatanToggle.Size = UDim2.new(0.9, 0, 0, 35)
    blatanToggle.Position = UDim2.new(0.05, 0, 0, yPos)
    blatanToggle.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    blatanToggle.Text = "🔴 OFF"
    blatanToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    blatanToggle.Font = Enum.Font.SourceSansBold
    blatanToggle.TextSize = 16
    
    yPos = yPos + 45
    
    -- SLIDER JUMLAH IKAN
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Parent = frame
    sliderLabel.Size = UDim2.new(1, 0, 0, 25)
    sliderLabel.Position = UDim2.new(0, 0, 0, yPos)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Text = "Ikan per Cast: " .. _G.MultiCastCount
    sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sliderLabel.Font = Enum.Font.SourceSans
    sliderLabel.TextSize = 16
    
    yPos = yPos + 30
    
    -- Tombol - dan +
    local minusBtn = Instance.new("TextButton")
    minusBtn.Parent = frame
    minusBtn.Size = UDim2.new(0, 35, 0, 35)
    minusBtn.Position = UDim2.new(0.2, -20, 0, yPos)
    minusBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    minusBtn.Text = "-"
    minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minusBtn.Font = Enum.Font.SourceSansBold
    minusBtn.TextSize = 20
    
    local countLabel = Instance.new("TextLabel")
    countLabel.Parent = frame
    countLabel.Size = UDim2.new(0, 50, 0, 35)
    countLabel.Position = UDim2.new(0.5, -25, 0, yPos)
    countLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    countLabel.Text = _G.MultiCastCount
    countLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    countLabel.Font = Enum.Font.SourceSansBold
    countLabel.TextSize = 18
    
    local plusBtn = Instance.new("TextButton")
    plusBtn.Parent = frame
    plusBtn.Size = UDim2.new(0, 35, 0, 35)
    plusBtn.Position = UDim2.new(0.8, -15, 0, yPos)
    plusBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    plusBtn.Text = "+"
    plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    plusBtn.Font = Enum.Font.SourceSansBold
    plusBtn.TextSize = 20
    
    yPos = yPos + 45
    
    -- AUTO SELL TOGGLE
    local sellToggle = Instance.new("TextButton")
    sellToggle.Parent = frame
    sellToggle.Size = UDim2.new(0.9, 0, 0, 35)
    sellToggle.Position = UDim2.new(0.05, 0, 0, yPos)
    sellToggle.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    sellToggle.Text = "💰 AUTO SELL: OFF"
    sellToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    sellToggle.Font = Enum.Font.SourceSansBold
    sellToggle.TextSize = 16
    
    yPos = yPos + 45
    
    -- INFINITE JUMP TOGGLE
    local jumpToggle = Instance.new("TextButton")
    jumpToggle.Parent = frame
    jumpToggle.Size = UDim2.new(0.9, 0, 0, 35)
    jumpToggle.Position = UDim2.new(0.05, 0, 0, yPos)
    jumpToggle.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    jumpToggle.Text = "🦘 INFINITE JUMP: OFF"
    jumpToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    jumpToggle.Font = Enum.Font.SourceSansBold
    jumpToggle.TextSize = 16
    
    yPos = yPos + 45
    
    -- TELEPORT BUTTONS
    local tpLabel = Instance.new("TextLabel")
    tpLabel.Parent = frame
    tpLabel.Size = UDim2.new(1, 0, 0, 25)
    tpLabel.Position = UDim2.new(0, 0, 0, yPos)
    tpLabel.BackgroundTransparency = 1
    tpLabel.Text = "📍 TELEPORT"
    tpLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    tpLabel.Font = Enum.Font.SourceSansBold
    tpLabel.TextSize = 18
    
    yPos = yPos + 30
    
    local tp1 = Instance.new("TextButton")
    tp1.Parent = frame
    tp1.Size = UDim2.new(0.45, -5, 0, 30)
    tp1.Position = UDim2.new(0.05, 0, 0, yPos)
    tp1.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    tp1.Text = "Fisherman Island"
    tp1.TextColor3 = Color3.fromRGB(255, 255, 255)
    tp1.Font = Enum.Font.SourceSans
    tp1.TextSize = 14
    
    local tp2 = Instance.new("TextButton")
    tp2.Parent = frame
    tp2.Size = UDim2.new(0.45, -5, 0, 30)
    tp2.Position = UDim2.new(0.5, 5, 0, yPos)
    tp2.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    tp2.Text = "Crystal Depths"
    tp2.TextColor3 = Color3.fromRGB(255, 255, 255)
    tp2.Font = Enum.Font.SourceSans
    tp2.TextSize = 14
    
    -- =====================================================
    -- FUNGSI TOMBOL
    -- =====================================================
    
    -- Blatan toggle
    blatanToggle.MouseButton1Click:Connect(function()
        _G.BlatanMode = not _G.BlatanMode
        if _G.BlatanMode then
            blatanToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            blatanToggle.Text = "✅ ON (" .. _G.MultiCastCount .. " ikan)"
            Notif("BLATAN MODE", "Aktif! " .. _G.MultiCastCount .. " ikan per cast", 2)
            coroutine.wrap(BlatanMode)()
        else
            blatanToggle.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
            blatanToggle.Text = "🔴 OFF"
            Notif("BLATAN MODE", "Dimatikan", 2)
        end
    end)
    
    -- Tombol -
    minusBtn.MouseButton1Click:Connect(function()
        if _G.MultiCastCount > 5 then
            _G.MultiCastCount = _G.MultiCastCount - 1
            countLabel.Text = _G.MultiCastCount
            sliderLabel.Text = "Ikan per Cast: " .. _G.MultiCastCount
            if _G.BlatanMode then
                blatanToggle.Text = "✅ ON (" .. _G.MultiCastCount .. " ikan)"
            end
        end
    end)
    
    -- Tombol +
    plusBtn.MouseButton1Click:Connect(function()
        if _G.MultiCastCount < 20 then
            _G.MultiCastCount = _G.MultiCastCount + 1
            countLabel.Text = _G.MultiCastCount
            sliderLabel.Text = "Ikan per Cast: " .. _G.MultiCastCount
            if _G.BlatanMode then
                blatanToggle.Text = "✅ ON (" .. _G.MultiCastCount .. " ikan)"
            end
        end
    end)
    
    -- Auto sell toggle
    sellToggle.MouseButton1Click:Connect(function()
        _G.AutoSell = not _G.AutoSell
        if _G.AutoSell then
            sellToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            sellToggle.Text = "💰 AUTO SELL: ON"
            Notif("AUTO SELL", "Aktif", 2)
            coroutine.wrap(AutoSell)()
        else
            sellToggle.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
            sellToggle.Text = "💰 AUTO SELL: OFF"
        end
    end)
    
    -- Infinite jump toggle
    jumpToggle.MouseButton1Click:Connect(function()
        _G.InfiniteJump = not _G.InfiniteJump
        if _G.InfiniteJump then
            jumpToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            jumpToggle.Text = "🦘 INFINITE JUMP: ON"
            Notif("INFINITE JUMP", "Aktif", 2)
            SetupInfiniteJump()
        else
            jumpToggle.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
            jumpToggle.Text = "🦘 INFINITE JUMP: OFF"
        end
    end)
    
    -- Teleport functions
    tp1.MouseButton1Click:Connect(function()
        Notif("Teleport", "Ke Fisherman Island", 1)
        local target = game:GetService("Workspace"):FindFirstChild("Fisherman Island")
        if target and target:FindFirstChild("SpawnLocation") then
            humanoidRootPart.CFrame = target.SpawnLocation.CFrame
        end
    end)
    
    tp2.MouseButton1Click:Connect(function()
        Notif("Teleport", "Ke Crystal Depths", 1)
        local target = game:GetService("Workspace"):FindFirstChild("Crystal Depths")
        if target and target:FindFirstChild("SpawnLocation") then
            humanoidRootPart.CFrame = target.SpawnLocation.CFrame
        end
    end)
    
    return gui
end

-- =====================================================
-- MULAI SCRIPT
-- =====================================================

-- Tampilkan notifikasi selamat datang
Notif("🐟 FishIt Blatan", "Versi Lengkap oleh nasrinakhsani", 3)
print("🎣 FishIt Blatan Loaded! Tekan tombol di GUI untuk mulai")

-- Buat GUI
local gui = CreateGUI()

-- Tambahkan instruksi di chat
game:GetService("Players").LocalPlayer:Chat(game:GetService("Players").LocalPlayer, "FishIt Blatan Loaded! Cari GUI di layar")
