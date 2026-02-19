echo "-- Build script untuk menggabungkan file
local files = {
    \"src/config/settings.lua\",
    \"src/modules/utils.lua\",
    \"src/modules/blatan.lua\",
    \"src/modules/fishing.lua\",
    \"src/modules/sell.lua\",
    \"src/modules/gui.lua\",
    \"src/main.lua\"
}

local output = \"--[[\\n    FishIt Blatan Mode\\n    Created by partolentho868\\n    Fitur: Multiple Catch (5-20 ikan per cast)\\n]]--\\n\\n\"

print(\"🚀 Building FishIt Blatan...\")
print(\"Username: partolentho868\")
print(\"\")\n

for _, file in ipairs(files) do
    local success, content = pcall(function()
        return readfile(file)
    end)
    
    if success then
        output = output .. \"--[[ Sumber: \" .. file .. \" ]]--\\n\" .. content .. \"\\n\\n\"
        print(\"✅ \" .. file)
    else
        print(\"❌ Gagal baca: \" .. file)
    end
end

local success = pcall(function()
    writefile(\"dist/FishItBlatan.lua\", output)
end)

if success then
    print(\"\")\n
    print(\"✅ Build selesai!\")
    print(\"📁 File: dist/FishItBlatan.lua\")
    print(\"🔗 Raw URL: https://raw.githubusercontent.com/partolentho868/FishIt-Blatan/main/dist/FishItBlatan.lua\")
else
    print(\"❌ Gagal nulis file output\")
end
" > build.lua
