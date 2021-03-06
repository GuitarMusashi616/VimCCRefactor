_global = _global or require "global"

local _screen = {}

function _screen.redraw()
	--term.clear()
	term.setCursorPos(1, 1)

	local topLine = _global.getVar("topLine")
	local lineskip = 0

	-- TODO maybe this should, like the real vim, have that when a line is
	-- to long to render instead an '@' shows up indicating that there is more
	-- TODO also, then a line as longer than the number of characters on the screen,
	-- displaying lines before the lines breaks down
	--
	-- This is a while loop to be able to do the check is go around
	local i = topLine
	while i <= topLine + _global.getVar("termY") - 2 - lineskip do
		term.clearLine()
		local tLine = _global.getLine(i)
		if tLine ~= nil then
			for l = 1, string.len(tLine) do
				if i == _global.getVar("currentLine") and
					l == _global.getVar("currentColumn") then
					term.blit(tLine:sub(l, l), "f", "0")
				else
					term.write(tLine:sub(l, l))
				end
				if l % _global.getVar("termX") == 0 then
					lineskip = lineskip + 1
					io.write("\n")
					term.clearLine()
				end
			end
			-- if inputing data at the end of the line
			if _global.getVar("currentColumn") == string.len(tLine) + 1 and
				_global.getVar("currentLine") == i then
				term.blit(" ", "f", "0")
			end
		else
			io.write("~")
		end
		io.write("\n")
		i = i + 1
	end
end

-- for error messages shown at the bottom of the screen
function _screen.echoerr(message)
	term.setCursorPos(1, _global.getVar("termY"))
	if term.isColor() then
		term.setBackgroundColour(colors.red)
	end
	term.write(message)
	if term.isColor() then
		term.setBackgroundColour(colors.black)
	end
end

-- for other messages to be shown at the bottom of the screen
function _screen.echo(message)
	term.setCursorPos(1, _global.getVar("termY"))
	term.write(message)
end

-- returns false if line couldn't be redrawn
function _screen.redrawLine(lineNo)
	local topLine = _global.getVar("topLine")
	local line = _global.getLine(lineNo)

	if lineNo < topLine then
		return false
	end
	if lineNo >= topLine + _global.getVar("termX") then
		return false
	end

	local positionOnScreen = lineNo - topLine
	for i = topLine, lineNo do
	end
end

function _screen.drawLine(lineNo)
	local tLine = _global.getLine(lineNo)
	for l = 1, string.len(tLine) do
		if i == _global.getVar("currentLine") and
			l == _global.getVar("currentColumn") then
			term.blit(tLine:sub(l, l), "f", "0")
		else
			term.write(tLine:sub(l, l))
		end
		if l % _global.getVar("termX") == 0 then
			lineskip = lineskip + 1
			io.write("\n")
		end
	end
end

function _screen.debug(message)
	term.setCursorPos(_global.getVar("termX") - string.len(message) + 1,
		_global.getVar("termY"))
	if message == nil then
		term.write("nil")
	else
		term.write(message)
	end
	os.pullEvent("key")
end

return _screen
