local colors = require('colors')

local theme = {}

-- local term = require('term')
local default_theme = {
	-- bold => bright
	-- italics => underscore
	['default'] =  colors.white,
	['nothing'] = '',
	['class'] = colors.yellow .. colors.bright,
	['comment'] = colors.blue .. colors.bright,
	['constant'] = colors.cyan .. colors.bright,
	['definition'] = colors.blue .. colors.bright,
	['error'] = colors.red .. colors.underscore,
	['function'] = colors.blue .. colors.bright,
	['keyword'] = colors.yellow .. colors.bright,
	['label'] = colors.green .. colors.bright,
	['number'] = colors.red .. colors.bright,
	['operator'] = colors.cyan .. colors.bright,
	['regex'] = colors.green .. colors.bright,
	['string'] = colors.red .. colors.bright,
	['preprocessor'] = colors.magenta .. colors.bright,
	['tag'] = colors.red .. colors.bright,
	['type'] = colors.green .. colors.bright,
	['variable'] = colors.blue .. colors.bright,
	['whitespace'] =  '',
	['embedded'] = colors.onblue .. colors.bright,
	['identifier'] = colors.white,
}

theme['default_theme'] = default_theme
theme['colors'] = colors

return theme
