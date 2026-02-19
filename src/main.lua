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