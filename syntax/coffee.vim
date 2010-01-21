" Language:    CoffeeScript
" Maintainer:  Mick Koch <kchmck@gmail.com>
" URL:         http://github.com/kchmck/vim-coffee-script
" Filenames:   *.coffee
" Version:     1.0
" Last Change: 2010-01-20

if exists("b:current_syntax")
  finish
endif

syntax clear

syntax match coffeeObject /\<[A-Z][A-Za-z]*\>/
highlight link coffeeObject Special

syntax keyword coffeeStatement return break continue throw
highlight link coffeeStatement Statement

syntax keyword coffeeRepeat for while
highlight link coffeeRepeat Repeat

syntax keyword coffeeConditional if else unless switch when then
highlight link coffeeConditional Conditional

syntax keyword coffeeException try catch finally
highlight link coffeeException Exception

syntax keyword coffeeOperator new in of by and or not is isnt extends instanceof typeof
highlight link coffeeOperator Operator

syntax keyword coffeeType this prototype void null undefined
highlight link coffeeType Type

syntax keyword coffeeBoolean true on yes false off no
highlight link coffeeBoolean Boolean

syntax match coffeeFunction /=>/
syntax match coffeeFunction /==>/
highlight link coffeeFunction Function

syntax match coffeeComment /#.*/
highlight link coffeeComment Comment

syntax region coffeeEmbed start=/`/ end=/`/
highlight link coffeeEmbed Special

syntax match coffeeIdentifier /:/
highlight link coffeeIdentifier Identifier

syntax match coffeeNumber /\<-\?\d\+\%([eE]\d\+\)\?L\?\>/
syntax match coffeeNumber /\<0[xX]\x\+\>/
highlight link coffeeNumber Number

syntax match coffeeFloat /\<-\?\%(\d*\.\d*\)\%([eE][+-]\?\d\+\)\?\>/
highlight link coffeeFloat Float

syntax region coffeeRegExp start=/\/\(\*\|\/\)\@!/ skip=/\\\\\|\\\// end=/\/[gim]\{,3}/ oneline
highlight link coffeeRegExp String

syntax region coffeeDoubleQuote start=/"/ skip=/\\"/ end=/"/
highlight link coffeeDoubleQuote String

syntax region coffeeSingleQuote start=/'/ skip=/\\'/ end=/'/
highlight link coffeeSingleQuote String

syntax match coffeeSpaceError /\s\+$/ display
highlight link coffeeSpaceError Error

syntax match coffeeSemicolonError /;\n/ display
highlight link coffeeSemicolonError Error

let b:current_syntax = "coffee"
