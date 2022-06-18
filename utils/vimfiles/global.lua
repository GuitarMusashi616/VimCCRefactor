local _global = {}

_global.globals = {
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

function _global.getVar(key)
	local temp = _global.globals[key]
	if temp == nil then
		error("get:no such key: " .. key)
	end
	return _global.globals[key]
end

function _global.setVar(key, value)
	local temp = _global.globals[key]
	if temp == nil then
		error("set:no such key: " .. key)
	end
	if value == nil then
		error("you forgot the value: " .. key)
	end
	_global.globals[key] = value
end

------------------------------

local lines = {}
local length = 0

function _global.getLines()
	return lines
end

-- screen uses the possible nil value that this may return
function _global.getLine(lineNo)
	return lines[lineNo]
end

function _global.getCurLine()
	return lines[ _global.globals["currentLine"] ];
end

function _global.setCurLine(text)
	lines[ _global.globals["currentLine"] ] = text
end

function _global.setLine(lineNo, text)
	lines[lineNo] = text
end

function _global.setLines(inLines)
	lines = inLines
	length = #lines
end

function _global.removeLine(lineNo)
	table.remove(lines, lineNo)
	length = length - 1
end

function _global.insertLine(pos, text)
	table.insert(lines, pos, text)
	length = length + 1
end

function _global.getLength()
	return length
end

return _global
