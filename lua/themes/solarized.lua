-- Solarized color codes Copyright (c) 2011 Ethan Schoonover
local M = {}

local colors = {
	base03  = '#002b36',
	base02  = '#073642',
	base01  = '#586e75',
	base00  = '#657b83',
	base0   = '#839496',
	base1   = '#93a1a1',
	base2   = '#eee8d5',
	base3   = '#fdf6e3',
	yellow  = '#b58900',
	orange  = '#cb4b16',
	red     = '#dc322f',
	magenta = '#d33682',
	violet  = '#6c71c4',
	blue    = '#268bd2',
	cyan    = '#2aa198',
	green   = '#859900',
}

M.theme = {
	['default'] = colors.base0,
	['nothing'] = '',
	['class'] = colors.yellow,
	['comment'] = colors.base01,
	['constant'] = colors.cyan,
	['definition'] = colors.blue,
	['error'] = colors.red,
	['function'] = colors.blue,
	['keyword'] = colors.green,
	['label'] = colors.green,
	['number'] = colors.cyan,
	['operator'] = colors.base01,
	['regex'] = colors.green,
	['string'] = colors.green,
	['preprocessor'] = colors.orange,
	['tag'] = colors.red,
	['type'] = colors.yellow,
	['variable'] = colors.blue,
	['whitespace'] = '',
	['embedded'] = colors.blue,
	['identifier'] = colors.base0,
}
return M
