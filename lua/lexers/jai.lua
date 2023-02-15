-- Copyright 2006-2023 Mitchell. See LICENSE.
-- Jai LPeg lexer.

local lexer = require('lexer')
local token, word_match = lexer.token, lexer.word_match
local P, S = lpeg.P, lpeg.S

local lex = lexer.new('jai')

-- Whitespace.
lex:add_rule('whitespace', token(lexer.WHITESPACE, lexer.space^1))

-- Keywords.
lex:add_rule('keyword', token(lexer.KEYWORD, word_match{
'if', 'ifx', 'else', 'then', 'while', 'for', 'switch', 'case', 'struct', 'enum',
    'return', 'new', 'remove', 'continue', 'break', 'defer', 'inline', 'no_inline',
    'using', 'SOA',
}))


-- Types.
lex:add_rule('type', token(lexer.TYPE, word_match{
'int', 'u64', 'u32', 'u16', 'u8',
    's64', 's32', 's16', 's8', 'float',
    'float32', 'float64', 'string',
    'bool', 'type', 'struct', 'function'
}))

-- @cast should be add rule function @

-- Constants.
lex:add_rule('constant', token(lexer.CONSTANT, word_match{
  -- Special values.
  'false', 'true', 'null'
}))

-- Built-in functions.
lex:add_rule('function', token(lexer.FUNCTION, '@' * word_match {
   'cast', 'it', 'type_info', 'size_of'
}))


-- Identifiers.
lex:add_rule('identifier', lex:tag(lexer.IDENTIFIER, lexer.word))

-- Strings.
local sq_str = P('L') ^ -1 * lexer.range("'", true)
local dq_str = P('L') ^ -1 * lexer.range('"', true)
lex:add_rule('string', token(lexer.STRING, sq_str + dq_str))

-- Comments.
local line_comment = lexer.to_eol('//')
local block_comment = lexer.range('/*', '*/')
lex:add_rule('comment', lex:tag(lexer.COMMENT, line_comment + block_comment))

-- Numbers.
lex:add_rule('number', token(lexer.NUMBER, lexer.number))

-- Operators.
lex:add_rule('operator', token(lexer.OPERATOR, S('+-/*%<>!=^&|?~:;,.()[]{}')))

-- Fold points.
lex:add_fold_point(lexer.OPERATOR, '{', '}')
lex:add_fold_point(lexer.COMMENT, '/*', '*/')

lexer.property['scintillua.comment'] = '//'

return lex
