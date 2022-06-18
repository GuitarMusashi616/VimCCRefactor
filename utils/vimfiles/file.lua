global = global or require "global"

local file = {}

function file.write()
	local h = fs.open(global.getVar("fileName"), "w")
	for i = 1, global.getLength() do
		-- TODO this crashes if the file is write only
		h.writeLine(global.getLine(i))
	end
	h.close()

	global.setVar("hasChanged", false)
end

--[[
	Returns the contents of the set file in a table
	of strings
]] --
function file.read(path)
	local h = io.open(global.getVar("fileName"), "r")
	local lines = {}
	if fs.exists(global.getVar("fileName")) then
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

return file
