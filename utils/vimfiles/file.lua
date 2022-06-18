_global = _global or require "global"

local _file = {}

function _file.write()
	local h = fs.open(_global.getVar("fileName"), "w")
	for i = 1, _global.getLength() do
		-- TODO this crashes if the file is write only
		h.writeLine(_global.getLine(i))
	end
	h.close()

	_global.setVar("hasChanged", false)
end

--[[
	Returns the contents of the set file in a table
	of strings
]] --
function _file.read(path)
	local h = io.open(_global.getVar("fileName"), "r")
	local lines = {}
	if fs.exists(_global.getVar("fileName")) then
		local tempLine = h:read()

		while tempLine ~= nil do
			lines[#lines + 1] = tempLine
			tempLine = h:read()
		end
		h:close()

		-- inserts a new line if the file is complealty empty
		if (lines[1] == nil) then
			lines[#lines + 1] = ""
		end
	else
		lines[#lines + 1] = ""
	end
	return lines
end

return _file
