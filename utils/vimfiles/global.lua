local global = {}

global.globals = {
	termX = 0,
	termY = 0,
	hasChanged = false,
	fileName = "",
	currentLine = 1,
	currentColumn = 1,
	-- Used when scrolling between lines
	-- note that this still doesn't behave
	-- exactly like the real deal. See one char lines
	-- and last character on line
	actualColumn = 1,

	topLine = 1,
	running = true,
}

function global.getVar(key)
	local temp = global.globals[key]
	if temp == nil then
		error("get:no such key: " .. key)
	end
	return global.globals[key]
end

function global.setVar(key, value)
	local temp = global.globals[key]
	if temp == nil then
		error( "set:no such key: " .. key )
	end
	if value == nil then
		error( "you forgot the value: " .. key )
	end
	global.globals[key] = value
end

------------------------------

local lines = {}
local length = 0

function global.getLines()
	return lines
end

-- screen uses the possible nil value that this may return
function global.getLine(lineNo)
	return lines[lineNo]
end

function global.getCurLine()
	return lines[global.globals["currentLine"]];
end

function global.setCurLine( text )
	lines[global.globals["currentLine"]] = text
end

function global.setLine(lineNo, text)
	lines[lineNo] = text
end

function global.setLines(inLines)
	lines = inLines
	length = #lines
end

function global.removeLine(lineNo)
	table.remove(lines, lineNo)
	length = length - 1
end

function global.insertLine( pos, text )
	table.insert(lines, pos, text)
	length = length + 1
end

function global.getLength()
	return length
end

return global