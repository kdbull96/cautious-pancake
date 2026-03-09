local modules = {
"AutoCollect",
"AutoLock"
}

for _,module in pairs(modules) do
    loadstring(game:HttpGet("https://raw.githubusercontent.com/kdbull96/cautious-pancake/main/Modules/"..module..".lua"))()
end
