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