local _logger = {}

local filename
local file
_logger.logLevel = {
	NONE = 0,
	WARNINGS = 5,
	ALL = 10,
}
local level

function _logger.init(path, llevel)
	level = _logger.logLevel[llevel]
	if level > 0 then
		filename = path
		file = fs.open(filename, "a")
	end
end

function _logger.info(message)
	if level > 0 then
		file.writeLine("INFO:" .. message)
		file.flush()
	end
end

function _logger.warning(message)
	if level > 5 then
		file.writeLine("WARN:" .. message)
		file.flush()
	end
end

return _logger
