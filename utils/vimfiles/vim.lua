--/utils/vimfiles/apiloader.loadAPI( "/utils/vimfiles/" );
_global = _global or require "global"
_screen = _screen or require "screen"
_vimode = _vimode or require "vimode"
_logger = _logger or require "logger"
_file = _file or require "file"

-- start main
local args = { ... }

local termX, termY = term.getSize()
_global.setVar("termX", termX)
_global.setVar("termY", termY)


_global.setVar("hasChanged", false)

-- TODO check if file is read only
if #args < 1 then
	error("please specify a file")
end

local sPath = shell.resolve(args[1])
if fs.exists(sPath) and fs.isDir(sPath) then
	print("Cannot edit a directory.")
	return
end
_global.setVar("fileName", sPath)



-- what absolute line are selected
_global.setVar("currentLine", 1)
_global.setVar("currentColumn", 1)
_global.setVar("topLine", 1)


local lines = _file.read(_global.getVar("fileName"))
_global.setLines(lines)



_screen.redraw()



if not fs.isDir("/.vimlog") then
	fs.makeDir("/.vimlog")
end
_logger.init("/.vimlog/vimlog-" .. os.day() .. "-" .. os.time(), _config.get("logLevel"))
_logger.info("log file created")


_vimode.normalMode()

term.setCursorPos(1, 1)
term.clear()
