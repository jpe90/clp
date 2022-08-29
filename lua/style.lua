local ansi_codes = require('ansi_codes')
local style = {}
local ansi_colors = {}
local clprc = require('clprc')
local selected_theme_name = clprc.theme
local selected_theme_path = 'themes/' .. selected_theme_name
local theme = require(selected_theme_path).theme
local theme_escape_codes = {}

for token, color in pairs(theme) do
	if type(color) == 'table' then
		theme_escape_codes[token] = ansi_codes.ansi_string_4b(color)
	elseif color:sub(1,1) == '#' then
		local r,g,b = ansi_codes.hex_to_rgb(color)
		theme_escape_codes[token] = ansi_codes.ansi_string_24b(r,g,b)
	end
end

local line_highlight_style = {
	['default'] =  ansi_colors.black,
	['nothing'] = '',
	['class'] = ansi_colors.black,
	['comment'] = ansi_colors.black,
	['constant'] = ansi_colors.black,
	['definition'] = ansi_colors.black,
	['error'] = ansi_colors.black,
	['function'] = ansi_colors.black,
	['keyword'] = ansi_colors.black,
	['label'] = ansi_colors.black,
	['number'] = ansi_colors.black,
	['operator'] = ansi_colors.black,
	['regex'] = ansi_colors.black,
	['string'] = ansi_colors.black,
	['preprocessor'] = ansi_colors.black,
	['tag'] = ansi_colors.black,
	['type'] = ansi_colors.black,
	['variable'] = ansi_colors.black,
	['whitespace'] = '',
	['embedded'] = ansi_colors.black,
	['identifier'] = ansi_colors.black,
}

style.line_highlight_style = line_highlight_style
style.theme = theme_escape_codes

return style
