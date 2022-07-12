clp = {}

local theme = require('theme')
local ftdetect = require('ftdetect')
local lexers = require('lexer')
local default_theme = theme.default_theme
local selected_theme = theme.selected_theme

function write(args)
	local filename = args.filename
	local filetype_override = args.filetype_override
	local syntax
	if filetype_override ~= nil then
		syntax = filetype_override
	else
		syntax = ftdetect.lookup_lexer(filename)
	end

	local lexer = lexers.load(syntax)
	if not lexer then
		print(string.format('Failed to load lexer: `%s`', syntax))
		return 1
	end

	local file = assert(io.open(filename, 'r'))
	local text = file:read('*all')
	local tokens = lexer:lex(text, 1)
	local token_start = 1
	local last = ''

	for i = 1, #tokens, 2 do
		local token_end = tokens[i + 1] - 1
		local name = tokens[i]

		local style = default_theme[name]
		if style ~= nil then
			-- Whereas the lexer reports all other syntaxes over
			-- the entire span of a token, it reports 'default'
			-- byte-by-byte. We emit only the first 'default' of
			-- a series in order to properly display multibyte
			-- UTF-8 characters.
			if not (last == 'default' and name == 'default') then
				io.write(tostring(style))
			end
			last = name
		end
		io.write(text:sub(token_start, token_end))
		token_start = token_end + 1
	end
	file:close()
end

return clp
