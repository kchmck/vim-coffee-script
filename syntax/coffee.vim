" Language:    CoffeeScript
" Maintainer:  Mick Koch <kchmck@gmail.com>
" URL:         http://github.com/kchmck/vim-coffee-script
" License:     WTFPL

if exists("b:current_syntax")
  finish
endif

if version < 600
  syn clear
endif

" Include JavaScript for coffeeEmbed.
syn include @coffeeJS syntax/javascript.vim

" Highlight long strings.
syn sync minlines=100

" CoffeeScript allows dollar signs in identifiers.
setlocal isident+=$

" These are 'matches' rather than 'keywords' because vim's highlighting priority
" for keywords (the highest) causes them to be wrongly highlighted when used as
" dot-properties.
syn match coffeeStatement /\<\%(return\|break\|continue\|throw\)\>/
hi def link coffeeStatement Statement

syn match coffeeRepeat /\<\%(for\|while\|until\|loop\)\>/
hi def link coffeeRepeat Repeat

syn match coffeeConditional /\<\%(if\|else\|unless\|switch\|when\|then\)\>/
hi def link coffeeConditional Conditional

syn match coffeeException /\<\%(try\|catch\|finally\)\>/
hi def link coffeeException Exception

syntax match coffeeOperator /\<\%(instanceof\|typeof\|delete\)\>/
hi def link coffeeOperator Operator

syn match coffeeKeyword /\<\%(new\|in\|of\|by\|and\|or\|not\|is\|isnt\|class\|extends\|super\|own\|do\)\>/
hi def link coffeeKeyword Keyword

syn match coffeeBoolean /\<\%(true\|on\|yes\|false\|off\|no\)\>/
hi def link coffeeBoolean Boolean

syn match coffeeGlobal /\<\%(null\|undefined\)\>/
hi def link coffeeGlobal Type

" Keywords reserved by the language
syn cluster coffeeReserved contains=coffeeStatement,coffeeRepeat,
\                                      coffeeConditional,coffeeException,
\                                      coffeeOperator,coffeeKeyword,
\                                      coffeeBoolean,coffeeGlobal

syn match coffeeVar /\<\%(this\|prototype\|arguments\)\>/
" Matches @-variables like @abc.
syn match coffeeVar /@\%(\I\i*\)\?/
hi def link coffeeVar Type

" Matches class-like names that start with a capital letter, like Array or
" Object.
syn match coffeeObject /\<\u\w*\>/
hi def link coffeeObject Structure

" Matches constant-like names in SCREAMING_CAPS.
syn match coffeeConstant /\<\u[A-Z0-9_]\+\>/
hi def link coffeeConstant Constant

" What can make up a variable name
syn cluster coffeeIdentifier contains=coffeeVar,coffeeObject,coffeeConstant,
\                                        coffeePrototype

syn region coffeeString start=/"/ skip=/\\\\\|\\"/ end=/"/ contains=@coffeeInterpString
syn region coffeeString start=/'/ skip=/\\\\\|\\'/ end=/'/ contains=@coffeeSimpleString
hi def link coffeeString String

syn region coffeeAssignString start=/"/ skip=/\\\\\|\\"/ end=/"/ contained contains=@coffeeSimpleString
syn region coffeeAssignString start=/'/ skip=/\\\\\|\\'/ end=/'/ contained contains=@coffeeSimpleString
hi def link coffeeAssignString String

" Matches numbers like -10, -10e8, -10E8, 10, 10e8, 10E8.
syn match coffeeNumber /\i\@<![-+]\?\d\+\%([eE][+-]\?\d\+\)\?/
" Matches hex numbers like 0xfff, 0x000.
syn match coffeeNumber /\<0[xX]\x\+\>/
hi def link coffeeNumber Number

" Matches floating-point numbers like -10.42e8, 10.42e-8.
syn match coffeeFloat /\i\@<![-+]\?\d*\.\@<!\.\d\+\%([eE][+-]\?\d\+\)\?/
hi def link coffeeFloat Float

syn match coffeeAssignSymbols /:\@<!::\@!\|++\|--\|\%(\s\zs\%(and\|or\)\|&&\|||\|?\|+\|-\|\/\|\*\|%\|<<\|>>\|>>>\|&\||\|\^\)\?=\@<!==\@!>\@!/ contained
hi def link coffeeAssignSymbols SpecialChar

syn match coffeeAssignBrackets /\[.\+\]/ contained contains=TOP,coffeeAssign

syn match coffeeAssign /[}\]]\@<=\s*==\@!>\@!/ contains=coffeeAssignSymbols
syn match coffeeAssign /\%(++\|--\)\s*\%(@\|@\?\I\)\%(\i\|::\|\.\|?\|\[.\+\]\)*/
\                         contains=@coffeeIdentifier,coffeeAssignSymbols,coffeeAssignBrackets
syn match coffeeAssign /\%(@\|@\?\I\)\%(\i\|::\|\.\|?\|\[.\+\]\)*\%(++\|--\|\s*\%(and\|or\|&&\|||\|?\|+\|-\|\/\|\*\|%\|<<\|>>\|>>>\|&\||\|\^\)\?=\@<!==\@!>\@!\)/
\                         contains=@coffeeIdentifier,coffeeAssignSymbols,coffeeAssignBrackets

" Displays an error for reserved words.
if !exists("coffee_no_reserved_words_error")
  syn match coffeeReservedError /\<\%(case\|default\|function\|var\|void\|with\|const\|let\|enum\|export\|import\|native\|__hasProp\|__extends\|__slice\|__bind\|__indexOf\)\>/
  hi def link coffeeReservedError Error
endif

syn match coffeeAssign /@\?\I\i*\s*:\@<!::\@!/ contains=@coffeeIdentifier,coffeeAssignSymbols
" Matches string assignments in object literals like {'a': 'b'}.
syn match coffeeAssign /\("\|'\)[^\1]*\1\s*;\@<!::\@!'\@!/ contains=coffeeAssignString,
\                                                                      coffeeAssignSymbols
" Matches number assignments in object literals like {42: 'a'}.
syn match coffeeAssign /\d\+\%(\.\d\+\)\?\s*:\@<!::\@!/ contains=coffeeNumber,coffeeAssignSymbols
hi def link coffeeAssign Identifier

syn match coffeePrototype /::/
hi def link coffeePrototype SpecialChar

syn match coffeeFunction /->\|=>/
hi def link coffeeFunction Function

syn keyword coffeeTodo TODO FIXME XXX contained
hi def link coffeeTodo Todo

syn match coffeeComment /#.*/ contains=@Spell,coffeeTodo
syn region coffeeComment start=/####\@!/ end=/###/ contains=@Spell,coffeeTodo
hi def link coffeeComment Comment

syn region coffeeHereComment start=/#/ end=/\ze\/\/\// end=/$/ contained contains=@Spell,coffeeTodo
hi def link coffeeHereComment coffeeComment

syn region coffeeEmbed matchgroup=coffeeEmbedDelim contains=@coffeeJS
\                         start=/`/ skip=/\\\\\|\\`/ end=/`/ 
hi def link coffeeEmbedDelim Delimiter

syn region coffeeInterpolation matchgroup=coffeeInterpDelim
\                                 start=/\#{/ end=/}/
\                                 contained contains=TOP
hi def link coffeeInterpDelim Delimiter

" Matches escape sequences like \000, \x00, \u0000, \n.
syn match coffeeEscape /\\\d\d\d\|\\x\x\{2\}\|\\u\x\{4\}\|\\./ contained
hi def link coffeeEscape SpecialChar

" What is in a non-interpolated string
syn cluster coffeeSimpleString contains=@Spell,coffeeEscape
" What is in an interpolated string
syn cluster coffeeInterpString contains=@coffeeSimpleString,
\                                           coffeeInterpolation

syn region coffeeRegex start=/\%(\%()\|\i\@<!\d\)\s*\|\i\)\@<!\/\s\@!/
\                         skip=/\[[^]]\{-}\/[^]]\{-}\]/
\                         end=/\/[gimy]\{,4}\d\@!/
\                         oneline contains=@coffeeSimpleString
syn region coffeeHereRegex start=/\/\/\// end=/\/\/\/[gimy]\{,4}/ contains=@coffeeInterpString,coffeeHereComment fold
hi def link coffeeHereRegex coffeeRegex
hi def link coffeeRegex String

syn region coffeeHeredoc start=/"""/ end=/"""/ contains=@coffeeInterpString fold
syn region coffeeHeredoc start=/'''/ end=/'''/ contains=@coffeeSimpleString fold
hi def link coffeeHeredoc String

" Displays an error for trailing whitespace.
if !exists("coffee_no_trailing_space_error")
  syn match coffeeSpaceError /\S\@<=\s\+$/ display
  hi def link coffeeSpaceError Error
endif

" Displays an error for trailing semicolons.
if !exists("coffee_no_trailing_semicolon_error")
  syn match coffeeSemicolonError /;$/ display
  hi def link coffeeSemicolonError Error
endif

" Reserved words can be used as dot-properties.
syn match coffeeDot /\.\@<!\.\i\+/ transparent
\                                     contains=ALLBUT,@coffeeReserved,
\                                                      coffeeReservedError

let b:current_syntax = "coffee"
