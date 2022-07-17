clp = {}

local theme = require('theme')
local colors = require('colors')
local ftdetect = require('ftdetect')
local lexers = require('lexer')
local default_theme = theme.default_theme
local highlight_theme = theme.highlight_theme

function write(args)
	local filename = args.filename
	local highlight_line = args.highlight_line
	local file = assert(io.open(filename, 'r'))
	local text = file:read('*all')
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
	local hl_line_start, hl_line_end
	if (highlight_line ~= nil) then
		hl_start_pos, hl_end_pos = find_endl(text, highlight_line)
	end
	if (hl_start_pos ~= nil) then
		write_hl(text, lexer, hl_start_pos, hl_end_pos)
	else
		write_nohl(text, lexer)
	end
	file:close()
end

-- https://github.com/martanne/vis/issues/601#issuecomment-327018674
function write_nohl(text, lexer)
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
end

-- find nth and n+1th indices of the endline character in a string
function find_endl(s, n)
	local i = 0
	local hl_start_pos
	if n == 1 then
		return 0,string.find(s,"\n", i + 1)
	end
	while true do
		i = string.find(s, "\n", i + 1)
		if i == nil then
			return nil
		end
		if n == 2 then
			hl_start_pos = i
			break
		end
		n = n - 1
	end
	i = string.find(s, "\n", i + 1)
	if i == nil then
		return i, nil
	else
		return hl_start_pos, i
	end
	return nil
end

function write_hl(text, lexer, hl_line_start, hl_line_end)
	-- gsub the text before, during... can we just say "rest"?
	-- then lets print as normal and see if there's a performance hit
	-- check if hl_line_end is nil
	-- substring from 0 to hl_line_start
	local pre_hl = text:sub(0, hl_line_start)
	local hl = text:sub(hl_line_start, hl_line_end)
	-- substitute newlines for blanks in hl
	hl = hl:gsub("\n", "")
	local post_hl = text:sub(hl_line_end, nil)
	write_thing(pre_hl, lexer, default_theme)
	if (hl ~= nil) then write_thing(hl, lexer, highlight_theme) end
	colors.reset_colors()
	if (post_hl ~= nil) then write_thing(post_hl, lexer, default_theme) end
end

function write_thing(text, lexer, style)
	local tokens = lexer:lex(text, 1)
	local token_start = 1
	local last = ''

	for i = 1, #tokens, 2 do
		local token_end = tokens[i + 1] - 1
		local name = tokens[i]

		local current_style = style[name]
		if current_style ~= nil then
			-- Whereas the lexer reports all other syntaxes over
			-- the entire span of a token, it reports 'default'
			-- byte-by-byte. We emit only the first 'default' of
			-- a series in order to properly display multibyte
			-- UTF-8 characters.
			if not (last == 'default' and name == 'default') then
				io.write(tostring(current_style))
			end
			last = name
		end
		io.write(text:sub(token_start, token_end))
		token_start = token_end + 1
	end
end

function print_available_overrides()
	print('Available overrides:')
	for lang, _ in pairs(ftdetect.filetypes) do
		print('- ' .. lang)
	end
end

return clp
