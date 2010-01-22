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

syntax match coffeeObject /\<[A-Z]\w*\>/
highlight default link coffeeObject Special

syntax keyword coffeeStatement return break continue throw
highlight default link coffeeStatement Statement

syntax keyword coffeeRepeat for while
highlight default link coffeeRepeat Repeat

syntax keyword coffeeConditional if else unless switch when then
highlight default link coffeeConditional Conditional

syntax keyword coffeeException try catch finally
highlight default link coffeeException Exception

syntax keyword coffeeOperator new in of by and or not is isnt extends instanceof typeof
highlight default link coffeeOperator Operator

syntax keyword coffeeType this prototype void null undefined
highlight default link coffeeType Type

syntax keyword coffeeBoolean true on yes false off no
highlight default link coffeeBoolean Boolean

syntax match coffeeFunction /=>/
syntax match coffeeFunction /==>/
highlight default link coffeeFunction Function

syntax match coffeeComment /#.*/
highlight default link coffeeComment Comment

syntax region coffeeEmbed start=/`/ end=/`/
highlight default link coffeeEmbed Special

syntax match coffeeIdentifier /:/
highlight default link coffeeIdentifier Identifier

syntax match coffeeNumber /\<-\?\d\+\%([eE]\d\+\)\?L\?\>/
syntax match coffeeNumber /\<0[xX]\x\+\>/
highlight default link coffeeNumber Number

syntax match coffeeFloat /\<-\?\%(\d*\.\d*\)\%([eE][+-]\?\d\+\)\?\>/
highlight default link coffeeFloat Float

syntax region coffeeRegExp start=/\/\(\*\|\/\)\@!/ skip=/\\\\\|\\\// end=/\/[gim]\{,3}/ oneline
highlight default link coffeeRegExp String

syntax region coffeeDoubleQuote start=/"/ skip=/\\"/ end=/"/
highlight default link coffeeDoubleQuote String

syntax region coffeeSingleQuote start=/'/ skip=/\\'/ end=/'/
highlight default link coffeeSingleQuote String

syntax match coffeeSpaceError /\s\+$/ display
highlight default link coffeeSpaceError Error

syntax match coffeeSemicolonError /;\n/ display
highlight default link coffeeSemicolonError Error

let b:current_syntax = "coffee"
