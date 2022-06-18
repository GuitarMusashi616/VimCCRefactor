_global = _global or require "global"
_screen = _screen or require "screen"
_config = _config or require "config"

local _vimode = {}

function _vimode.commandMode()
	local command = ""
	local pos = 1
	term.setCursorPos(1, _global.getVar("termY"))
	term.clearLine()
	term.write(":")

	-- TODO find better way to 'eat' event
	os.sleep(0.1)


	local running = true
	local event, key = os.pullEvent()
	while running do
		if event == "key" then
			if key == keys.enter then
				term.clearLine()
				running = false
				return command
			end

			if key == _config.get("escBtn") then
				term.clearLine()
				running = false
			end

			if key == keys.backspace then
				term.setCursorPos(pos, _global.getVar("termY"))

				command = string.sub(command, 1, string.len(command) - 1)
				pos = pos - 1
				if pos < 1 then
					pos = 1
				end
			end
		end

		if event == "char" then
			--command[pos] = key
			command = command .. key
			pos = pos + 1
			term.setCursorPos(pos, _global.getVar("termY"))
			term.write(key)
		end
		event, key = os.pullEvent()
	end
end

function _vimode.insertText(pos, text)
	_global.setVar("hasChanged", true)
	local line, column

	if pos == "newline" or
		pos == "prevline" then
		line = _global.getVar("currentLine") + 1
		_global.insertLine(line, text)
	else
		line = _global.getVar("currentLine")
		if pos == "here" then
			column = _global.getVar("currentColumn")
		elseif pos == "after" then
			column = _global.getVar("currentColumn") + 1
		elseif pos == "beginning" then
			column = string.len(string.match(_global.getLine(line), "%s*"))
			column = column + 1
		elseif pos == "0" then
			column = 1
		elseif pos == "end" then
			column = string.len(_global.getLine(line))
		end
		strBefore = string.sub(_global.getLine(line), 1, column - 1)
		strAfter  = string.sub(_global.getLine(line), column)

		_global.setLine(line, strBefore .. text .. strAfter)
	end


end

-- pos: where should insert mode be entered in realtion to the cursor
function _vimode.insertMode(pos)
	-- TODO find better way to eat event
	os.sleep(0.1)

	local strBefore
	local strAfter

	local strChange = ""

	_global.setVar("hasChanged", true)

	if pos == "here" then
	elseif pos == "after" then
		_global.setVar("currentColumn", _global.getVar("currentColumn") + 1)
	elseif pos == "beginning" then
		_global.setVar("currentColumn", string.len(string.match(_global.getCurLine(), "%s*")) + 1)
	elseif pos == "0" then
		_global.setVar("currentColumn", 1)
	elseif pos == "end" then
		_global.setVar("currentColumn", string.len(_global.getCurLine()) + 1)
	elseif pos == "newline" then
		_global.setVar("hasChanged", true)
		_global.setVar("currentLine", _global.getVar("currentLine") + 1)
		_global.insertLine(_global.getVar("currentLine"), "")
		_global.setVar("currentColumn", 1)
	elseif pos == "prevline" then
		_global.setVar("hasChanged", true)
		_global.insertLine(_global.getVar("currentLine") + 1, _global.getCurLine())
		_global.setLine(_global.getVar("currentLine"), "")
		_global.setVar("currentColumn", 1)
	end

	strBefore = string.sub(_global.getCurLine(), 1, _global.getVar("currentColumn") - 1)
	strAfter = string.sub(_global.getCurLine(), _global.getVar("currentColumn"))

	-- TODO the cursor should blink while in insert mode
	_screen.redraw()

	local event, key = os.pullEvent()
	while true do
		if event == "key" then

			if key == _config.get("escBtn") then
				-- the cursor can be one step to far to the right
				-- this happens when appending text to a line
				local strLen = string.len(_global.getCurLine())
				if _global.getVar("currentColumn") > strLen then
					_global.setVar("currentColumn", strLen)
				end

				break
			end

			-- TODO You currently can backspace past the screen
			if key == keys.backspace then
				strBefore = string.sub(strBefore, 1, string.len(strBefore) - 1)
				_global.setVar("currentColumn", _global.getVar("currentColumn") - 1)
				_global.setLine(_global.getVar("currentLine"), strBefore .. strAfter)

				strChange = string.sub(strChange, 1, string.len(strChange) - 1)

				--term.setCursorPos(column, line)
			end

			if key == keys.delete then
				strAfter = string.sub(strAfter, 2)
				_global.setLine(_global.getVar("currentLine"), strBefore .. strAfter)

				--term.setCursorPos(column, line)
			end

			-- TODO this sholud be better
			if key == keys.enter then
				_global.setVar("hasChanged", true)

				_global.setLine(_global.getVar("currentLine"), strBefore)

				_global.setVar("currentLine", _global.getVar("currentLine") + 1)
				_global.setVar("currentColumn", 1)
				_global.insertLine(_global.getVar("currentLine"), strAfter)
				strBefore = ""

				strChange = strChange .. "\n"

				--screen.redraw()
			end

			_screen.redraw()
		end

		-- text entry
		if event == "char" then
			_global.setVar("hasChanged", true)
			_global.setVar("currentColumn", _global.getVar("currentColumn") + 1)

			strBefore = strBefore .. key
			strChange = strChange .. key

			_global.setLine(_global.getVar("currentLine"), strBefore .. strAfter)

			_screen.redraw()
		end

		-- pull next event
		event, key = os.pullEvent()
	end

	return strChange
end

function _vimode.normalMode()
	term.setCursorBlink(false)
	_command = _command or require "command"

	local keyPresses = {}

	_global.setVar("running", true)
	while _global.getVar("running") do
		local event, key = os.pullEvent()

		if event == "key" then
			if key == _config.get("escBtn") then
				keyPresses = {}
			end
		end
		if event == "char" then
			if key == ":" then
				local cmd = _vimode.commandMode() or ""
				_command.runExCommand(cmd)
				keyPresses = {}
			end

			keyPresses[#keyPresses + 1] = key

			local triggered = _command.runViCommand(keyPresses)

			if triggered then
				keyPresses = {}
			end
		end
	end
end

return _vimode
