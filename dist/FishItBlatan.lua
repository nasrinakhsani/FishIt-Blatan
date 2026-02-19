--[[
    LNTH FISH IT PANEL - PREMIUM EDITION
    Created by nasrinakhsani for LNTH
    Fitur: Auto Fish, Blatan Mode, Auto Sell, Teleport, Token System
]]

-- Tunggu game load sebentar
wait(2)

-- =====================================================
-- CORE SYSTEM - ANTI AFK
-- =====================================================
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")
local VirtualUser = game:GetService("VirtualUser")

-- Anti AFK biar gak di-kick server
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Fungsi notifikasi
local function notify(title, msg, time)
    time = time or 3
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title or "LNTH",
        Text = msg or "",
        Duration = time
    })
end

-- =====================================================
-- LOAD NET REMOTE (KUNCI UTAMA BIAR FITUR JALAN)
-- =====================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local net = nil

-- Cari net remote di berbagai kemungkinan
pcall(function()
    local packages = ReplicatedStorage:FindFirstChild("Packages")
    if packages then
        local index = packages:FindFirstChild("_Index")
        if index then
            for _, v in pairs(index:GetChildren()) do
                if v.Name:find("sleitnick_net") then
                    net = v:FindFirstChild("net")
                    if net then break end
                end
            end
        end
    end
end)

-- Fallback kalau gak ketemu
if not net then
    net = ReplicatedStorage:FindFirstChild("Net") 
        or ReplicatedStorage:FindFirstChild("Network")
end

-- =====================================================
-- VARIABEL GLOBAL
-- =====================================================
_G.LNTH = {
    AutoFish = false,
    BlatanMode = false,
    AutoSell = false,
    InfiniteJump = false,
    WalkWater = false,
    SpeedBoost = false,
    BlatanCount = 10,
    SelectedLocation = "Fisherman Island"
}

-- =====================================================
-- FUNGSI AUTO FISH + BLATAN
-- =====================================================
local function startAutoFish()
    task.spawn(function()
        while _G.LNTH.AutoFish or _G.LNTH.BlatanMode do
            pcall(function()
                if net then
                    -- Auto equip rod
                    local equipRemote = net:FindFirstChild("RE/EquipToolFromHotbar")
                    if equipRemote then
                        equipRemote:FireServer()
                    end
                    
                    wait(0.1)
                    
                    -- Cast rod
                    local castRemote = net:FindFirstChild("RF/ChargeFishingRod")
                    if castRemote then
                        castRemote:InvokeServer(1)
                    end
                    
                    wait(0.1)
                    
                    -- BLATAN MODE: multiple catch
                    local catchRemote = net:FindFirstChild("RE/FishingCompleted")
                    if catchRemote and _G.LNTH.BlatanMode then
                        for i = 1, _G.LNTH.BlatanCount do
                            catchRemote:FireServer()
                            if i % 3 == 0 then
                                print("⚡ LNTH Blatan: " .. i .. "x catch")
                            end
                            wait(0.03)
                        end
                    elseif catchRemote and _G.LNTH.AutoFish then
                        catchRemote:FireServer()
                    end
                else
                    -- Fallback method: cari remote di rod
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
            wait(0.3)
        end
    end)
end

-- =====================================================
-- FUNGSI AUTO SELL
-- =====================================================
local function startAutoSell()
    task.spawn(function()
        while _G.LNTH.AutoSell do
            pcall(function()
                if net then
                    local sellRemote = net:FindFirstChild("RF/SellAllItems")
                    if sellRemote then
                        sellRemote:InvokeServer()
                        print("💰 LNTH Auto Sell: Ikan terjual!")
                    end
                end
            end)
            wait(2)
        end
    end)
end

-- =====================================================
-- FUNGSI INFINITE JUMP
-- =====================================================
local function setupInfiniteJump()
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if _G.LNTH.InfiniteJump and humanoid then
            humanoid:ChangeState("Jumping")
        end
    end)
end

-- =====================================================
-- FUNGSI WALK ON WATER
-- =====================================================
local function startWalkWater()
    task.spawn(function()
        while _G.LNTH.WalkWater do
            pcall(function()
                if hrp and hrp.Position.Y < 0 then
                    hrp.CFrame = CFrame.new(hrp.Position.X, 3, hrp.Position.Z)
                end
            end)
            wait(0.1)
        end
    end)
end

-- =====================================================
-- FUNGSI SPEED BOOST
-- =====================================================
local function startSpeedBoost()
    task.spawn(function()
        while _G.LNTH.SpeedBoost do
            pcall(function()
                if humanoid then
                    humanoid.WalkSpeed = 50
                end
            end)
            wait(1)
        end
        if humanoid then
            humanoid.WalkSpeed = 16
        end
    end)
end

-- =====================================================
-- DAFTAR LOKASI TELEPORT LENGKAP
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
-- MEMBUAT GUI LNTH (TANPA LIBRARY, PASTI JALAN)
-- =====================================================
local gui = Instance.new("ScreenGui")
gui.Name = "LNTH_Panel"
gui.Parent = player.PlayerGui
gui.ResetOnSpawn = false

-- Frame utama (bisa di-drag)
local mainFrame = Instance.new("Frame")
mainFrame.Parent = gui
mainFrame.Size = UDim2.new(0, 380, 0, 550)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

-- Efek shadow
local shadow = Instance.new("ImageLabel")
shadow.Parent = mainFrame
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.5

-- Header
local header = Instance.new("Frame")
header.Parent = mainFrame
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
header.BorderSizePixel = 0

local title = Instance.new("TextLabel")
title.Parent = header
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🔥 LNTH FISH IT PANEL"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = header
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 7)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Tab buttons (biar rapi kayak Lynx)
local tabFrame = Instance.new("Frame")
tabFrame.Parent = mainFrame
tabFrame.Size = UDim2.new(1, -20, 0, 40)
tabFrame.Position = UDim2.new(0, 10, 0, 50)
tabFrame.BackgroundTransparency = 1

local tabs = {"⚡ AUTO", "💰 SELL", "📍 TP", "⚙️ MOVE", "ℹ️ INFO"}
local currentTab = 1
local tabButtons = {}

local function createTabButtons()
    local btnWidth = (380 - 40) / #tabs
    for i, tabName in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Parent = tabFrame
        btn.Size = UDim2.new(0, btnWidth - 4, 0, 35)
        btn.Position = UDim2.new(0, (i-1) * btnWidth, 0, 0)
        btn.BackgroundColor3 = i == 1 and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(40, 40, 40)
        btn.Text = tabName
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamSemibold
        btn.BorderSizePixel = 0
        
        btn.MouseButton1Click:Connect(function()
            currentTab = i
            for j, b in ipairs(tabButtons) do
                b.BackgroundColor3 = j == i and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(40, 40, 40)
            end
            updateTabContent()
        end)
        
        table.insert(tabButtons, btn)
    end
end

-- Container untuk konten tab
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Parent = mainFrame
contentFrame.Size = UDim2.new(1, -20, 1, -120)
contentFrame.Position = UDim2.new(0, 10, 0, 100)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
contentFrame.BorderSizePixel = 0
contentFrame.ScrollBarThickness = 8
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 120, 200)
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

-- Fungsi buat update konten tab
local function updateTabContent()
    -- Hapus konten lama
    for _, v in pairs(contentFrame:GetChildren()) do
        v:Destroy()
    end
    
    local yPos = 10
    
    if currentTab == 1 then  -- AUTO TAB
        -- Title
        local title = Instance.new("TextLabel")
        title.Parent = contentFrame
        title.Size = UDim2.new(1, -20, 0, 30)
        title.Position = UDim2.new(0, 10, 0, yPos)
        title.BackgroundTransparency = 1
        title.Text = "⚡ AUTO FISH SETTINGS"
        title.TextColor3 = Color3.fromRGB(0, 200, 255)
        title.TextSize = 16
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        yPos = yPos + 35
        
        -- Auto Fish Toggle
        local autoFishBtn = createButton(contentFrame, "AUTO FISH", _G.LNTH.AutoFish, yPos)
        autoFishBtn.MouseButton1Click:Connect(function()
            _G.LNTH.AutoFish = not _G.LNTH.AutoFish
            updateButtonColor(autoFishBtn, _G.LNTH.AutoFish)
            if _G.LNTH.AutoFish then
                notify("LNTH", "Auto Fish ON")
                startAutoFish()
            end
        end)
        yPos = yPos + 45
        
        -- Blatan Mode Toggle
        local blatanBtn = createButton(contentFrame, "BLATAN MODE", _G.LNTH.BlatanMode, yPos)
        blatanBtn.MouseButton1Click:Connect(function()
            _G.LNTH.BlatanMode = not _G.LNTH.BlatanMode
            updateButtonColor(blatanBtn, _G.LNTH.BlatanMode)
            if _G.LNTH.BlatanMode then
                _G.LNTH.AutoFish = true
                updateButtonColor(autoFishBtn, true)
                notify("LNTH", "BLATAN MODE ON - " .. _G.LNTH.BlatanCount .. "x catch")
                startAutoFish()
            end
        end)
        yPos = yPos + 45
        
        -- Slider Blatan Count
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Parent = contentFrame
        sliderLabel.Size = UDim2.new(1, -30, 0, 25)
        sliderLabel.Position = UDim2.new(0, 15, 0, yPos)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = "📊 BLATAN COUNT: " .. _G.LNTH.BlatanCount
        sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        sliderLabel.TextSize = 14
        sliderLabel.Font = Enum.Font.Gotham
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        yPos = yPos + 30
        
        local sliderFrame = createSlider(contentFrame, yPos, 5, 20, _G.LNTH.BlatanCount, function(val)
            _G.LNTH.BlatanCount = val
            sliderLabel.Text = "📊 BLATAN COUNT: " .. val
        end)
        yPos = yPos + 50
        
    elseif currentTab == 2 then  -- SELL TAB
        local title = Instance.new("TextLabel")
        title.Parent = contentFrame
        title.Size = UDim2.new(1, -20, 0, 30)
        title.Position = UDim2.new(0, 10, 0, yPos)
        title.BackgroundTransparency = 1
        title.Text = "💰 AUTO SELL SETTINGS"
        title.TextColor3 = Color3.fromRGB(0, 200, 255)
        title.TextSize = 16
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        yPos = yPos + 35
        
        local sellBtn = createButton(contentFrame, "AUTO SELL", _G.LNTH.AutoSell, yPos)
        sellBtn.MouseButton1Click:Connect(function()
            _G.LNTH.AutoSell = not _G.LNTH.AutoSell
            updateButtonColor(sellBtn, _G.LNTH.AutoSell)
            if _G.LNTH.AutoSell then
                notify("LNTH", "Auto Sell ON")
                startAutoSell()
            end
        end)
        yPos = yPos + 50
        
    elseif currentTab == 3 then  -- TELEPORT TAB
        local title = Instance.new("TextLabel")
        title.Parent = contentFrame
        title.Size = UDim2.new(1, -20, 0, 30)
        title.Position = UDim2.new(0, 10, 0, yPos)
        title.BackgroundTransparency = 1
        title.Text = "📍 TELEPORT LOCATIONS"
        title.TextColor3 = Color3.fromRGB(0, 200, 255)
        title.TextSize = 16
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        yPos = yPos + 35
        
        for _, loc in ipairs(teleportLocations) do
            local btn = Instance.new("TextButton")
            btn.Parent = contentFrame
            btn.Size = UDim2.new(1, -20, 0, 35)
            btn.Position = UDim2.new(0, 10, 0, yPos)
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            btn.Text = loc.Name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 14
            btn.Font = Enum.Font.Gotham
            
            btn.MouseButton1Click:Connect(function()
                pcall(function()
                    hrp.CFrame = CFrame.new(loc.Pos)
                    notify("LNTH", "Teleport ke " .. loc.Name, 1)
                end)
            end)
            yPos = yPos + 40
        end
        
    elseif currentTab == 4 then  -- MOVEMENT TAB
        local title = Instance.new("TextLabel")
        title.Parent = contentFrame
        title.Size = UDim2.new(1, -20, 0, 30)
        title.Position = UDim2.new(0, 10, 0, yPos)
        title.BackgroundTransparency = 1
        title.Text = "⚙️ MOVEMENT HACKS"
        title.TextColor3 = Color3.fromRGB(0, 200, 255)
        title.TextSize = 16
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        yPos = yPos + 35
        
        local jumpBtn = createButton(contentFrame, "INFINITE JUMP", _G.LNTH.InfiniteJump, yPos)
        jumpBtn.MouseButton1Click:Connect(function()
            _G.LNTH.InfiniteJump = not _G.LNTH.InfiniteJump
            updateButtonColor(jumpBtn, _G.LNTH.InfiniteJump)
            if _G.LNTH.InfiniteJump then
                setupInfiniteJump()
            end
        end)
        yPos = yPos + 45
        
        local waterBtn = createButton(contentFrame, "WALK ON WATER", _G.LNTH.WalkWater, yPos)
        waterBtn.MouseButton1Click:Connect(function()
            _G.LNTH.WalkWater = not _G.LNTH.WalkWater
            updateButtonColor(waterBtn, _G.LNTH.WalkWater)
            if _G.LNTH.WalkWater then
                startWalkWater()
            end
        end)
        yPos = yPos + 45
        
        local speedBtn = createButton(contentFrame, "SPEED BOOST", _G.LNTH.SpeedBoost, yPos)
        speedBtn.MouseButton1Click:Connect(function()
            _G.LNTH.SpeedBoost = not _G.LNTH.SpeedBoost
            updateButtonColor(speedBtn, _G.LNTH.SpeedBoost)
            if _G.LNTH.SpeedBoost then
                startSpeedBoost()
            end
        end)
        yPos = yPos + 50
        
    elseif currentTab == 5 then  -- INFO TAB
        local title = Instance.new("TextLabel")
        title.Parent = contentFrame
        title.Size = UDim2.new(1, -20, 0, 30)
        title.Position = UDim2.new(0, 10, 0, yPos)
        title.BackgroundTransparency = 1
        title.Text = "ℹ️ LNTH PANEL INFO"
        title.TextColor3 = Color3.fromRGB(0, 200, 255)
        title.TextSize = 16
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        yPos = yPos + 35
        
        local info = {
            "🔥 LNTH FISH IT PANEL",
            "👤 Creator: nasrinakhsani",
            "⚡ Fitur:",
            "  • Auto Fish",
            "  • BLATAN Mode (5-20x)",
            "  • Auto Sell",
            "  • 10+ Teleport",
            "  • Infinite Jump",
            "  • Walk on Water",
            "  • Speed Boost",
            "  • Anti AFK",
        }
        
        for _, line in ipairs(info) do
            local label = Instance.new("TextLabel")
            label.Parent = contentFrame
            label.Size = UDim2.new(1, -20, 0, 20)
            label.Position = UDim2.new(0, 10, 0, yPos)
            label.BackgroundTransparency = 1
            label.Text = line
            label.TextColor3 = Color3.fromRGB(200, 200, 200)
            label.TextSize = 13
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            yPos = yPos + 22
        end
        
        local copyBtn = Instance.new("TextButton")
        copyBtn.Parent = contentFrame
        copyBtn.Size = UDim2.new(1, -20, 0, 40)
        copyBtn.Position = UDim2.new(0, 10, 0, yPos + 10)
        copyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        copyBtn.Text = "📋 COPY LOADSTRING"
        copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        copyBtn.TextSize = 14
        copyBtn.Font = Enum.Font.GothamBold
        
        copyBtn.MouseButton1Click:Connect(function()
            setclipboard('loadstring(game:HttpGet("https://raw.githubusercontent.com/nasrinakhsani/FishIt-Blatan/main/dist/FishItBlatan.lua"))()')
            notify("LNTH", "Loadstring copied!")
        end)
    end
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 30)
end

-- Helper function buat bikin button toggle
function createButton(parent, text, state, yPos)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(80, 0, 0)
    btn.Text = text .. ": " .. (state and "ON" or "OFF")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    return btn
end

function updateButtonColor(btn, state)
    btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(80, 0, 0)
    btn.Text = btn.Text:gsub(": .*", ": " .. (state and "ON" or "OFF"))
end

function createSlider(parent, yPos, min, max, default, callback)
    local bg = Instance.new("Frame")
    bg.Parent = parent
    bg.Size = UDim2.new(1, -20, 0, 20)
    bg.Position = UDim2.new(0, 10, 0, yPos)
    bg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    
    local slider = Instance.new("TextButton")
    slider.Parent = bg
    slider.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    slider.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    slider.Text = ""
    
    local val = default
    local dragging = false
    
    slider.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if dragging then
            local mousePos = game:GetService("UserInputService"):GetMouseLocation()
            local absPos = bg.AbsolutePosition
            local absSize = bg.AbsoluteSize
            local relativeX = math.clamp(mousePos.X - absPos.X, 0, absSize.X)
            local newVal = min + (relativeX / absSize.X) * (max - min)
            newVal = math.floor(newVal + 0.5)
            if newVal ~= val then
                val = newVal
                slider.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                callback(val)
            end
        end
    end)
    
    return bg
end

-- Initialize GUI
createTabButtons()
updateTabContent()

-- Welcome notification
notify("🔥 LNTH PANEL", "Loaded! Tekan tab untuk pilih fitur", 3)
print("✅ LNTH Fish It Panel loaded - Created for nasrinakhsani")
