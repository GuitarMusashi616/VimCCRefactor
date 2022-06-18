function wget(file)
    local url = ("https://raw.githubusercontent.com/GuitarMusashi616/VimCCRefactor/master/utils/vimfiles/%s.lua"):format(file)
    shell.run("wget " .. url)
end

local files = {
    "command",
    "config",
    "file",
    "global",
    "logger",
    "screen",
    "vim",
    "vimode",
    "vimrcDefault",
}

for i = 1, #files do
    wget(files[i])
end
