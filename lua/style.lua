local style = {}
local ansi_colors = {}
local clprc = require('clprc')

-- https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters
local sgr_params = {
    reset      = 0,
    clear      = 0,
    default    = 0,
    bright     = 1,
    dim        = 2,
    underscore = 4,
    blink      = 5,
    reverse    = 7,
    hidden     = 8,

	-- TODO: get foreground values from external theme
	-- e.g. black = theme.black_sgr_number

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

-- converts a SGR parameter to an ANSI escape string
-- https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
local function ansi_string(sgr_number)
	if(sgr_number > 47) then
        sgr_number = "38;5;" .. tostring(sgr_number)
    end
    return string.char(27) .. '[' .. tostring(sgr_number) .. 'm'
end

for sgr_name,sgr_number in pairs(sgr_params) do
	ansi_colors[sgr_name] = ansi_string(sgr_number)
end

-- TODO: get these values from external theme
--       e.g. ['default'] = ansi_colors.default_color
local dark_mode_syntax_highlight_style = {
	['default'] =  ansi_colors.white,
	['nothing'] = '',
	['class'] = ansi_colors.yellow .. ansi_colors.bright,
	['comment'] = ansi_colors.blue .. ansi_colors.bright,
	['constant'] = ansi_colors.cyan .. ansi_colors.bright,
	['definition'] = ansi_colors.blue .. ansi_colors.bright,
	['error'] = ansi_colors.red .. ansi_colors.underscore,
	['function'] = ansi_colors.blue .. ansi_colors.bright,
	['keyword'] = ansi_colors.yellow .. ansi_colors.bright,
	['label'] = ansi_colors.green .. ansi_colors.bright,
	['number'] = ansi_colors.red .. ansi_colors.bright,
	['operator'] = ansi_colors.cyan .. ansi_colors.bright,
	['regex'] = ansi_colors.green .. ansi_colors.bright,
	['string'] = ansi_colors.red .. ansi_colors.bright,
	['preprocessor'] = ansi_colors.magenta .. ansi_colors.bright,
	['tag'] = ansi_colors.red .. ansi_colors.bright,
	['type'] = ansi_colors.green .. ansi_colors.bright,
	['variable'] = ansi_colors.blue .. ansi_colors.bright,
	['whitespace'] =  '',
	['embedded'] = ansi_colors.magenta .. ansi_colors.bright,
	['identifier'] = ansi_colors.white,
}

local light_mode_syntax_highlight_style = {
	['default'] =  ansi_colors.black,
	['nothing'] = '',
	['class'] = ansi_colors.magenta .. ansi_colors.bright,
	['comment'] = ansi_colors.blue .. ansi_colors.bright,
	['constant'] = ansi_colors.cyan .. ansi_colors.bright,
	['definition'] = ansi_colors.blue .. ansi_colors.bright,
	['error'] = ansi_colors.red .. ansi_colors.underscore,
	['function'] = ansi_colors.blue .. ansi_colors.bright,
	['keyword'] = ansi_colors.blue.. ansi_colors.bright,
	['label'] = ansi_colors.green .. ansi_colors.bright,
	['number'] = ansi_colors.red .. ansi_colors.bright,
	['operator'] = ansi_colors.black .. ansi_colors.bright,
	['regex'] = ansi_colors.green .. ansi_colors.bright,
	['string'] = ansi_colors.red .. ansi_colors.bright,
	['preprocessor'] = ansi_colors.magenta .. ansi_colors.bright,
	['tag'] = ansi_colors.red .. ansi_colors.bright,
	['type'] = ansi_colors.cyan .. ansi_colors.bright,
	['variable'] = ansi_colors.blue .. ansi_colors.bright,
	['whitespace'] =  '',
	['embedded'] = ansi_colors.magenta .. ansi_colors.bright,
	['identifier'] = ansi_colors.black,
}

local line_highlight_style = {
	['default'] =  ansi_colors.black .. ansi_colors.onwhite,
	['nothing'] = '' .. ansi_colors.onwhite,
	['class'] = ansi_colors.black .. ansi_colors.onwhite,
	['comment'] = ansi_colors.black .. ansi_colors.onwhite,
	['constant'] = ansi_colors.black .. ansi_colors.onwhite,
	['definition'] = ansi_colors.black .. ansi_colors.onwhite,
	['error'] = ansi_colors.black .. ansi_colors.onwhite,
	['function'] = ansi_colors.black .. ansi_colors.onwhite,
	['keyword'] = ansi_colors.black .. ansi_colors.onwhite,
	['label'] = ansi_colors.black .. ansi_colors.onwhite,
	['number'] = ansi_colors.black .. ansi_colors.onwhite,
	['operator'] = ansi_colors.black .. ansi_colors.onwhite,
	['regex'] = ansi_colors.black .. ansi_colors.onwhite,
	['string'] = ansi_colors.black .. ansi_colors.onwhite,
	['preprocessor'] = ansi_colors.black .. ansi_colors.onwhite,
	['tag'] = ansi_colors.black .. ansi_colors.onwhite,
	['type'] = ansi_colors.black .. ansi_colors.onwhite,
	['variable'] = ansi_colors.black .. ansi_colors.onwhite,
	['whitespace'] = '' .. ansi_colors.onwhite,
	['embedded'] = ansi_colors.black .. ansi_colors.onwhite,
	['identifier'] = ansi_colors.black .. ansi_colors.onwhite,
}

style.reset_sequence = ansi_string(sgr_params.reset)
style.line_highlight_style = line_highlight_style

-- TODO: temporary hack, remove when external themes implemented
if clprc ~= nil and clprc.custom_theme == "light" then
	style.syntax_highlight_style = light_mode_syntax_highlight_style
else
	style.syntax_highlight_style = dark_mode_syntax_highlight_style
end

return style
