clp = {}

local ftdetect = require('ftdetect')
local lexers = require('lexer')
local ansi_codes = require('ansi_codes')

require('util')

-- TODO: the logic in here changed in scintillua_6
--            investigate if this is still (or was ever) needed
function expand_theme(theme, lexer)
    local extra_styles = lexer._extra_tags
    local expanded_table = copy_table(theme)
    for k, v in pairs(extra_styles) do
        -- local copied_style_name = string.match(v,"%.(.-)%)")
        -- local copied_style = theme[copied_style_name]
        -- expanded_table[k] = copied_style
    end
    return expanded_table
end

function write(args)
    local selected_theme_name = ""
    if args.color_theme_override ~= nil then
        selected_theme_name = args.color_theme_override
    else
        local clprc = require('clprc')
        selected_theme_name = clprc.theme
    end
    local selected_theme_path = 'themes/' .. selected_theme_name
    local theme_name = require(selected_theme_path).theme
    local color_theme = require('color_theme')
    color_theme.init_style(theme_name)
    local syntax_highlight_theme = color_theme.theme
    local line_highlight_style = color_theme.line_highlight_style
    local filename = args.filename
    local highlight_line = args.highlight_line
    local filetype_override = args.filetype_override
    local file = assert(io.open(filename, 'r'))

    local text = file:read('*all')
    local syntax
    if color_theme_override ~= nil then
        syntax = filetype_override
    else
        syntax = ftdetect.lookup_lexer(filename)
    end
    if filetype_override ~= nil then
        syntax = filetype_override
    else
        syntax = ftdetect.lookup_lexer(filename)
    end
    local lexer = lexers.load(syntax)
    local lang_theme = expand_theme(syntax_highlight_theme, lexer)
    if not lang_theme then
        print(string.format('Failed to theme: `%s`', syntax))
    end
    if not lexer then
        print(string.format('Failed to load lexer: `%s`', syntax))
        return 1
    end

    -- if a line was set to be highlighted, make sure it has valid bounds and
    -- then highlight it. Otherwise just write normally to stdout.
    local hl_start_pos, hl_end_pos, hl_next_pos
    if (highlight_line ~= nil and highlight_line > 0) then
        hl_start_pos, hl_end_pos, hl_next_pos =
            find_hl_bounds(text, highlight_line)
    end
    if (hl_start_pos ~= nil) then
        write_hl(text, lexer, hl_start_pos, hl_end_pos, hl_next_pos,
                 lang_theme)
    else
        write_nohl(text, lexer, lang_theme)
    end
    reset_colors()
    file:close()
end

function write_nohl(text, lexer, theme) write_styled(text, lexer, theme) end

function reset_colors() io.write(tostring(ansi_codes.reset_sequence)) end

function find_hl_bounds(s, n)
    if n == nil or n < 1 then return nil end

    local line_start = 1
    local current = 1
    while current < n do
        local nl = string.find(s, "\n", line_start, true)
        if nl == nil then return nil end
        line_start = nl + 1
        current = current + 1
    end

    local nl = string.find(s, "\n", line_start, true)
    if nl == nil then
        local line_end = #s
        if line_end >= line_start and s:sub(line_end, line_end) == "\r" then
            line_end = line_end - 1
        end
        return line_start, line_end, #s + 1
    end

    local line_end = nl - 1
    if line_end >= line_start and s:sub(line_end, line_end) == "\r" then
        line_end = line_end - 1
    end
    return line_start, line_end, nl + 1
end

function write_hl(text, lexer, hl_line_start, hl_line_end, hl_next_start,
                  lang_theme)
    local pre_hl = text:sub(1, hl_line_start - 1)
    local hl = text:sub(hl_line_start, hl_line_end)
    local line_break = ""
    if hl_line_end + 1 <= hl_next_start - 1 then
        line_break = text:sub(hl_line_end + 1, hl_next_start - 1)
    end
    local post_hl = text:sub(hl_next_start)
    write_styled(pre_hl, lexer, lang_theme)
    if (hl ~= nil) then
        io.write(ansi_codes.begin_line_hl_ansi .. hl ..
                     ansi_codes.end_line_hl_ansi)
    end
    if line_break ~= "" then io.write(line_break) end
    if (post_hl ~= nil) then write_styled(post_hl, lexer, lang_theme) end
end

-- https://github.com/martanne/vis/issues/601#issuecomment-327018674
function write_styled(text, lexer, local_color_theme)
    local tokens = lexer:lex(text, 1)
    local token_start = 1
    local last = ''

    for i = 1, #tokens, 2 do
        local token_end = tokens[i + 1] - 1
        local name = tokens[i]

        local current_color_theme = local_color_theme[name]
        if current_color_theme ~= nil then
            -- Whereas the lexer reports all other syntaxes over
            -- the entire span of a token, it reports 'default'
            -- byte-by-byte. We emit only the first 'default' of
            -- a series in order to properly display multibyte
            -- UTF-8 characters.
            if not (last == 'default' and name == 'default') then
                io.write(tostring(current_color_theme))
            end
            last = name
        end
        io.write(text:sub(token_start, token_end))
        reset_colors()
        token_start = token_end + 1
    end
end

function print_available_overrides()
    print('Available filetype overrides:')
    for lang, _ in pairs(ftdetect.filetypes) do print('- ' .. lang) end
end

return clp
