local ansi_codes = require('ansi_codes')
local style = {}
local ansi_colors = {}
local clprc = require('clprc')
local selected_theme_name = clprc.theme
local selected_theme_path = 'themes/' .. selected_theme_name
local theme = require(selected_theme_path).theme
local theme_escape_codes = {}

for sgr_name,sgr_number in pairs(ansi_codes.sgr_params) do
	ansi_colors[sgr_name] = ansi_codes.ansi_string(sgr_number)
end

for token, color in pairs(theme) do
	if type(color) == 'table' then
		theme_escape_codes[token] = ansi_codes.ansi_string_4b(color)
	elseif color:sub(1,1) == '#' then
		local r,g,b = ansi_codes.hex_to_rgb(color)
		theme_escape_codes[token] = ansi_codes.ansi_string_24b(r,g,b)
	end
end

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

style.line_highlight_style = line_highlight_style
style.theme = theme_escape_codes

return style
