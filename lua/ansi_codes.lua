local M = {}

local rgb_to_ansi = {}

local sgr_params = {
    reset      = 0,
    clear      = 0,
    default    = 0,
    bright     = 1,
    dim        = 2,
	italic     = 3,
    underscore = 4,
    blink      = 5,
    reverse    = 7,
    hidden     = 8,

	-- foreground
    black      = 30,
    red        = 31,
    green      = 32,
    yellow     = 33,
    blue       = 34,
    magenta    = 35,
    cyan       = 36,
    white      = 37,

    -- background
    onblack    = 40,
    onred      = 41,
    ongreen    = 42,
    onyellow   = 43,
    onblue     = 44,
    onmagenta  = 45,
    oncyan     = 46,
    onwhite    = 47,
}

local function hex_to_rgb(hex)
    hex = hex:sub(2)
    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)
    return r, g, b
end

-- converts a SGR parameter to an ANSI escape string
-- https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
local function ansi_string(sgr_number)
    return string.char(27) .. '[' .. tostring(sgr_number) .. 'm'
end

-- converts a SGR parameter to an ANSI escape string
-- https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
-- not currently used
-- local function ansi_string_265(sgr_number)
-- 	return string.char(27) .."[38;5;"  ..  tostring(sgr_number) .. 'm'
-- end

-- converts a SGR parameter to an ANSI escape string
-- https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
local function ansi_string_4b(color)
	local ansi_code = ""
	for attr, value in pairs(color) do
		if attr == "color" then
    		ansi_code = ansi_code .. ansi_string(sgr_params[value])
		else
    		print('error in 4 bit color value')
		end
	end
	return ansi_code
end

-- converts a SGR parameter to an ANSI escape string
-- https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
local function ansi_string_24b(r,g,b)
	return string.char(27) .."[38;2;"  ..  tostring(r) ..  ';' .. tostring(g)..  ';' .. tostring(b).. 'm'
end

M.begin_line_hl_ansi = string.char(27) .. "[47m" .. string.char(27) .. "[30m"
M.end_line_hl_ansi = string.char(27) .. "[K" .. string.char(27) .. "[0m"

M.ansi_string = ansi_string
M.rgb_to_ansi = rgb_to_ansi
M.reset_sequence = ansi_string(0)
M.hex_to_rgb = hex_to_rgb
M.ansi_string_24b = ansi_string_24b
M.ansi_string_4b = ansi_string_4b

return M
