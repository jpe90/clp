local colors = require('colors')

local theme = {}

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

local highlight_theme = {
	-- bold => bright
	-- italics => underscore
	['default'] =  colors.white .. colors.reverse,
	['nothing'] = '' .. colors.reverse,
	['class'] = colors.yellow .. colors.bright .. colors.reverse,
	['comment'] = colors.blue .. colors.bright .. colors.reverse,
	['constant'] = colors.cyan .. colors.bright .. colors.reverse,
	['definition'] = colors.blue .. colors.bright .. colors.reverse,
	['error'] = colors.red .. colors.underscore .. colors.reverse,
	['function'] = colors.blue .. colors.bright .. colors.reverse,
	['keyword'] = colors.yellow .. colors.bright .. colors.reverse,
	['label'] = colors.green .. colors.bright .. colors.reverse,
	['number'] = colors.red .. colors.bright .. colors.reverse,
	['operator'] = colors.cyan .. colors.bright .. colors.reverse,
	['regex'] = colors.green .. colors.bright .. colors.reverse,
	['string'] = colors.red .. colors.bright .. colors.reverse,
	['preprocessor'] = colors.magenta .. colors.bright .. colors.reverse,
	['tag'] = colors.red .. colors.bright .. colors.reverse,
	['type'] = colors.green .. colors.bright .. colors.reverse,
	['variable'] = colors.blue .. colors.bright .. colors.reverse,
	['whitespace'] =  '' .. colors.reverse,
	['embedded'] = colors.onblue .. colors.bright .. colors.reverse,
	['identifier'] = colors.white .. colors.reverse,
}

theme['default_theme'] = default_theme
theme['highlight_theme'] = highlight_theme
theme['colors'] = colors

return theme
