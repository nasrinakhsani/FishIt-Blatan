local Settings = {
    Version = "1.0.0",
    Creator = "nasrinakhsani",
    DefaultCatchCount = 10,
    MaxCatchCount = 20,
    MinCatchCount = 5,
    AutoSellInterval = 5,
    Colors = {
        Primary = Color3.fromRGB(0, 255, 255),
        Secondary = Color3.fromRGB(255, 0, 255),
        Background = Color3.fromRGB(30, 30, 30)
    }
}

return Settings


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

local Blatan = {}
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

function Blatan:Start(count)
    count = count or 10
    print("🔥 Blatan mode started with " .. count .. " catches")
    
    while _G.BlatanMode do
        local rod = player.Backpack:FindFirstChildOfClass("Tool") 
                or character:FindFirstChildOfClass("Tool")
        
        if rod then
            local events = {}
            for _, v in pairs(rod:GetChildren()) do
                if v:IsA("RemoteEvent") then
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
                        print("⚡ Blatan: " .. i .. " ikan dapet!")
                    end
                    wait(0.05)
                end
            else
                -- Fallback: fire semua remote
                for i = 1, count do
                    for _, remote in pairs(rod:GetChildren()) do
                        if remote:IsA("RemoteEvent") then
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
    print("⏹️ Blatan mode stopped")
end

return Blatan

local Fishing = {}

function Fishing:Cast()
    local player = game.Players.LocalPlayer
    local rod = player.Backpack:FindFirstChildOfClass("Tool") 
            or player.Character:FindFirstChildOfClass("Tool")
    
    if rod then
        for _, v in pairs(rod:GetChildren()) do
            if v:IsA("RemoteEvent") and v.Name:lower():find("cast") then
                v:FireServer()
                return true
            end
        end
    end
    return false
end

function Fishing:Reel()
    local player = game.Players.LocalPlayer
    local rod = player.Backpack:FindFirstChildOfClass("Tool") 
            or player.Character:FindFirstChildOfClass("Tool")
    
    if rod then
        for _, v in pairs(rod:GetChildren()) do
            if v:IsA("RemoteEvent") and v.Name:lower():find("reel") then
                v:FireServer()
                return true
            end
        end
    end
    return false
end

return Fishing

local Sell = {}
local player = game.Players.LocalPlayer

function Sell:AutoSell(interval)
    interval = interval or 5
    print("💰 Auto sell started every " .. interval .. " seconds")
    
    while _G.AutoSell do
        pcall(function()
            -- Cari NPC penjual
            local seller = game:GetService("Workspace"):FindFirstChild("SellNPC")
                        or game:GetService("Workspace"):FindFirstChild("Merchant")
                        or game:GetService("Workspace"):FindFirstChild("Fisherman")
            
            if seller and seller:FindFirstChild("HumanoidRootPart") then
                -- Teleport ke seller
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = seller.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                    wait(0.5)
                    
                    -- Cari remote sell
                    local sellRemote = game:GetService("ReplicatedStorage"):FindFirstChild("SellFish")
                                    or game:GetService("ReplicatedStorage"):FindFirstChild("Sell")
                                    or game:GetService("ReplicatedStorage"):FindFirstChild("SellItem")
                    
                    if sellRemote then
                        sellRemote:FireServer()
                        print("💰 Ikan terjual!")
                    end
                end
            end
        end)
        wait(interval)
    end
end

function Sell:Stop()
    _G.AutoSell = false
    print("⏹️ Auto sell stopped")
end

return Sell

local GUI = {}
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

function GUI:Create()
    local Window = Library.CreateLib("FishIt Blatan - nasrinakhsani", "DarkTheme")
    
    -- Tab Utama
    local MainTab = Window:NewTab("BLATAN MODE")
    local MainSection = MainTab:NewSection("Multiple Catch Settings")
    
    MainSection:NewToggle("BLATAN MODE", "1x cast = banyak ikan", function(state)
        _G.BlatanMode = state
        if state then
            local Blatan = require(game:GetService("ReplicatedStorage").Blatan)
            Blatan:Start(_G.MultiCastCount or 10)
        end
    end)
    
    MainSection:NewSlider("Ikan per Cast", "Jumlah ikan tiap mancing", 20, 5, function(val)
        _G.MultiCastCount = val
        Library:Notify("Setting: " .. val .. " ikan/cast")
    end)
    
    -- Tab Lokasi
    local LocTab = Window:NewTab("Teleport")
    local LocSection = LocTab:NewSection("Pilih Lokasi")
    
    local locations = {
        "Fisherman Island",
        "Crystal Depths",
        "Pirate Cove",
        "Tropical Grove",
        "The Lost Isle",
        "Kohana Lava"
    }
    
    for _, loc in pairs(locations) do
        LocSection:NewButton(loc, "Teleport ke " .. loc, function()
            local Utils = require(game:GetService("ReplicatedStorage").Utils)
            if Utils:TeleportTo(loc) then
                Library:Notify("✅ Teleport ke " .. loc)
            else
                Library:Notify("❌ Lokasi tidak ditemukan")
            end
        end)
    end
    
    -- Tab Info
    local InfoTab = Window:NewTab("Info")
    local InfoSection = InfoTab:NewSection("Credit")
    
    InfoSection:NewLabel("🎣 FishIt Blatan Mode")
    InfoSection:NewLabel("👤 Creator: nasrinakhsani")
    InfoSection:NewLabel("📅 Version: 1.0.0")
    InfoSection:NewLabel("⚡ Fitur: Multiple Catch")
    InfoSection:NewButton("Copy Loadstring", "", function()
        setclipboard("loadstring(game:HttpGet('https://raw.githubusercontent.com/nasrinakhsani/FishIt-Blatan/main/dist/FishItBlatan.lua'))()")
        Library:Notify("✅ Loadstring copied!")
    end)
end

return GUI

-- Main Script FishIt Blatan
-- Created by nasrinakhsani

print("🎣 Loading FishIt Blatan Mode...")
print("👤 Creator: nasrinakhsani")
wait(1)

-- Load modules
local Settings = loadstring(game:HttpGet("https://raw.githubusercontent.com/nasrinakhsani/FishIt-Blatan/main/src/config/settings.lua"))()
local Utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/nasrinakhsani/FishIt-Blatan/main/src/modules/utils.lua"))()
local Blatan = loadstring(game:HttpGet("https://raw.githubusercontent.com/nasrinakhsani/FishIt-Blatan/main/src/modules/blatan.lua"))()
local Fishing = loadstring(game:HttpGet("https://raw.githubusercontent.com/nasrinakhsani/FishIt-Blatan/main/src/modules/fishing.lua"))()
local Sell = loadstring(game:HttpGet("https://raw.githubusercontent.com/nasrinakhsani/FishIt-Blatan/main/src/modules/sell.lua"))()
local GUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/nasrinakhsani/FishIt-Blatan/main/src/modules/gui.lua"))()

-- Initialize
GUI:Create()
Utils.AntiAFK()

print("✅ FishIt Blatan Loaded!")
print("🔥 Blatan mode siap digunakan!")
