lexer = require './lexer-lsch.ls'
lexer.lex '''
  $(rm -rf abc)
  for i from 1 to 10
    $"ls"
'''
