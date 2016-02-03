# copied from `index.ls` {{{

require! {
    './lexer.js': lexer
    '../lib/parser.js': {parser}
    '../lib/ast.js'
}

# Override Jison's default lexer, so that it can accept
# the generic stream of tokens our lexer produces.
parser <<<
    yy: ast
    lexer:
        lex: ->
            [tag, @yytext, first_line, first_column] = @tokens[++@pos] or [''];
            [,, last_line, last_column] = @tokens[@pos+1] or [''];
            @yylineno = first_line
            @yylloc =
                first_line: first_line
                first_column: first_column
                last_line: last_line
                last_column: last_column
            tag
        set-input: ->
            @pos = -1
            @tokens = it
        upcoming-input: -> ''

# }}}









src = '''
if excited
  for i til 10
    `ls
    `ls | grep b
    `foo` .pipe `bar
    `foo` .pipe `bar`
    `long long long \\
      is too long\\
      for gcc
$(rm -rf (a b c [d, e, f]) gh/ijk)
$(rm -rf (a + b(c)) ~/de/fgh/ijk)
$(rm (a + $(b) .pipe $(c d)) $(e f g) (h + $((i + $(j)))) 'k l m \\n')
$(sleep 5 (async: true))
#$"ls"
'''
lexed = lexer.lex src
console.log lexed
ast = parser.parse lexed
compiled = ast.compile-root {}
console.log compiled.toString!
