" Language:    CoffeeScript
" Maintainer:  Mick Koch <kchmck@gmail.com>
" URL:         http://github.com/kchmck/vim-coffee-script
" License:     WTFPL

if exists("b:current_syntax")
  finish
endif

syntax clear

syntax keyword coffeeStatement return break continue throw
highlight default link coffeeStatement Statement

syntax keyword coffeeRepeat for while
highlight default link coffeeRepeat Repeat

syntax keyword coffeeConditional if else unless switch when then
highlight default link coffeeConditional Conditional

syntax keyword coffeeException try catch finally
highlight default link coffeeException Exception

syntax keyword coffeeOperator instanceof typeof
highlight default link coffeeOperator Operator

syntax keyword coffeeKeyword new in of by where and or not is isnt
syntax keyword coffeeKeyword class extends super
highlight default link coffeeKeyword Keyword

syntax keyword coffeeVar this prototype arguments
syntax match coffeeVar /@\w*/
highlight default link coffeeVar Identifier

syntax match coffeeAssignment /@\?\w\+:/
highlight default link coffeeAssignment Identifier

" Matches class-like names that start with a capital letter, like Array or
" Object
syntax match coffeeObject /\<[A-Z]\w*\>/
highlight default link coffeeObject Structure

syntax match coffeePrototype /::/
highlight default link coffeePrototype SpecialChar

syntax keyword coffeeType void null undefined
highlight default link coffeeType Type

syntax keyword coffeeBoolean true on yes false off no
highlight default link coffeeBoolean Boolean

syntax match coffeeFunction /->/
syntax match coffeeFunction /=>/
syntax match coffeeFunction /<-/
highlight default link coffeeFunction Function

syntax keyword coffeeTodo TODO FIXME XXX contained
highlight default link coffeeTodo Todo

syntax match coffeeComment /#.*/ contains=@Spell,coffeeTodo
highlight default link coffeeComment Comment

syntax region coffeeEmbed start=/`/ end=/`/
highlight default link coffeeEmbed Special

" Matches numbers like -10, -10e8, -10E8, 10, 10e8, 10E8
syntax match coffeeNumber /\<-\?\d\+\%([eE][+-]\?\d\+\)\?\>/
" Matches hex numbers like 0xfff, 0x000
syntax match coffeeNumber /\<0[xX]\x\+\>/
highlight default link coffeeNumber Number

" Matches floating-point numbers like -10.42e8, 10.42e-8
syntax match coffeeFloat /\<-\?\d\+\.\d\+\%([eE][+-]\?\d\+\)\?/
highlight default link coffeeFloat Float

syntax match coffeeInterpolation /[^\\]\@<=\$[A-Za-z_@]\+/ contained
syntax region coffeeInterpolation start=/[^\\]\@<=\${/ end=/}/ contained
\                                 contains=@coffeeInterpolated
highlight default link coffeeInterpolation Special

syntax region coffeeRegExp start=/\// skip=/\\\// end=/\/[gimy]\{,4}/ oneline
\                          contains=coffeeInterpolation
highlight default link coffeeRegExp String

syntax region coffeeString start=/"/ skip=/\\\\\|\\"/ end=/"/ contains=@Spell,
\                                                                      coffeeInterpolation
syntax region coffeeString start=/'/ skip=/\\\\\|\\'/ end=/'/ contains=@Spell
highlight default link coffeeString String

syntax region coffeeHeredoc start=/"""/ end=/"""/ contains=@Spell,
\                                                          coffeeInterpolation
syntax region coffeeHeredoc start=/'''/ end=/'''/ contains=@Spell
highlight default link coffeeHeredoc String

" What should be separately highlighted in interpolations
syntax cluster coffeeInterpolated contains=coffeeConditional,coffeeOperator,
\                                          coffeeKeyword,coffeeVar,coffeeObject,
\                                          coffeeType,coffeeBoolean,coffeeNumber,
\                                          coffeeFloat,coffeeString

" Displays an error for trailing whitespace
syntax match coffeeSpaceError /\s\+$/ display
highlight default link coffeeSpaceError Error

" Displays an error for semicolons at the end of lines
syntax match coffeeSemicolonError /;$/ display
highlight default link coffeeSemicolonError Error

let b:current_syntax = "coffee"
