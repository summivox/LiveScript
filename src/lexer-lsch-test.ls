# copied from `index.ls` {{{

require! {
    './lexer-lsch': lexer
    '../lib/parser': {parser}
    '../lib/ast'
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
  for i til 10
    #$(rm -rf (a + b c d) ~/de/fgh/ijk)
    #$(rm -rf (a + b(c)) ~/de/fgh/ijk)
    $(rm -rf (a + $(ls) .pipe $(grep b)) $(which cat) ($(($(a)))) ~/cde/fgh/ijk )
    #$"ls"
'''
lexed = lexer.lex src
console.log lexed
ast = parser.parse lexed
compiled = ast.compile-root {}
console.log compiled.toString!
