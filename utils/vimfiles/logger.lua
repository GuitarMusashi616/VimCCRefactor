local logger = {}

local filename
local file
logger.logLevel = {
	NONE = 0,
	WARNINGS = 5,
	ALL = 10,
}
local level

function logger.init(path, llevel)
	level = logger.logLevel[llevel]
	if level > 0 then
		filename = path
		file = fs.open(filename, "a")
	end
end

function logger.info(message)
	if level > 0 then
		file.writeLine("INFO:" .. message)
		file.flush()
	end
end

function logger.warning(message)
	if level > 5 then
		file.writeLine("WARN:" .. message)
		file.flush()
	end
end

return logger
