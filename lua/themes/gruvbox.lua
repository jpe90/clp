local M = {}

local colors = {
	black            = '#928374',
	red              = '#fb4934',
	green            = '#b8bb26',
	yellow           = '#fabd2f',
	blue             = '#83a598',
	magenta          = '#d3869b',
	cyan             = '#8ec07c',
	aqua	         = '#8ec07c',
	orange           = '#fe8019',
	white            = '#ebdbb2',
}

M.theme = {
	['default']      = colors.white,
	['nothing']      = '',
	['class']        = colors.yellow,
	['comment']      = colors.gray,
	['constant']     = colors.purple,
	['error']        = colors.red,
	['function']     = colors.green,
	['keyword']      = colors.red,
	['label']        = colors.red,
	['number']       = colors.purple,
	['operator']     = colors.white,
	['regex']        = colors.aqua,
	['string']       = colors.green,
	['preprocessor'] = colors.aqua,
	['tag']          = colors.blue,
	['type']         = colors.yellow,
	['variable']     = colors.blue,
	['whitespace']   = '',
	['embedded']     = colors.orange,
	['identifier']   = colors.white,
}
return M
