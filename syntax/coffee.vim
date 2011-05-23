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

" These are `matches` instead of `keywords` because vim's highlighting
" priority for keywords is higher than matches. This causes keywords to be
" highlighted inside matches, even if a match says it shouldn't contain them --
" like with coffeeAssign and coffeeDot.
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
\                                   coffeeConditional,coffeeException,
\                                   coffeeOperator,coffeeKeyword,
\                                   coffeeBoolean,coffeeGlobal

" A special variable
syn match coffeeSpecialVar /\<\%(this\|prototype\|arguments\)\>/
" An @-variable
syn match coffeeSpecialVar /@\%(\I\i*\)\?/
hi def link coffeeSpecialVar Type

" A class-like name that starts with a capital letter
syn match coffeeObject /\<\u\w*\>/
hi def link coffeeObject Structure

" A constant-like name in SCREAMING_CAPS
syn match coffeeConstant /\<\u[A-Z0-9_]\+\>/
hi def link coffeeConstant Constant

" A variable name
syn cluster coffeeIdentifier contains=coffeeSpecialVar,coffeeObject,
\                                     coffeeConstant,coffeePrototype

" A non-interpolated string
syn cluster coffeeBasicString contains=@Spell,coffeeEscape
" An interpolated string
syn cluster coffeeInterpString contains=@coffeeBasicString,coffeeInterp

" Regular strings
syn region coffeeString start=/"/ skip=/\\\\\|\\"/ end=/"/
\                       contains=@coffeeInterpString
syn region coffeeString start=/'/ skip=/\\\\\|\\'/ end=/'/
\                       contains=@coffeeBasicString
hi def link coffeeString String

" A integer, including a leading plus or minus
syn match coffeeNumber /\i\@<![-+]\?\d\+\%([eE][+-]\?\d\+\)\?/
" A hex number
syn match coffeeNumber /\<0[xX]\x\+\>/
hi def link coffeeNumber Number

" A floating-point number, including a leading plus or minus
syn match coffeeFloat /\i\@<![-+]\?\d*\.\@<!\.\d\+\%([eE][+-]\?\d\+\)\?/
hi def link coffeeFloat Float

syn match coffeeAssignSymbols /:\@<!::\@!\|++\|--\|\%(\s\zs\%(and\|or\)\|&&\|||\|?\|+\|-\|\/\|\*\|%\|<<\|>>\|>>>\|&\||\|\^\)\?=\@<!==\@!>\@!/
\                             contained
hi def link coffeeAssignSymbols SpecialChar

syn match coffeeAssignBrackets /\[.\+\]/ contained contains=TOP,coffeeAssign

" A destructuring assignment
syn match coffeeAssign /[}\]]\@<=\s*==\@!>\@!/ contains=coffeeAssignSymbols
" A pre-increment or pre-decrement assignment
syn match coffeeAssign /\%(++\|--\)\s*\%(@\|@\?\I\)\%(\i\|::\|\.\|?\|\[.\+\]\)*/
\                      contains=@coffeeIdentifier,coffeeAssignSymbols,
\                                coffeeAssignBrackets
" A normal assignment, or a post-increment or post-decrement assignment
syn match coffeeAssign /\%(@\|@\?\I\)\%(\i\|::\|\.\|?\|\[.\+\]\)*\%(++\|--\|\s*\%(and\|or\|&&\|||\|?\|+\|-\|\/\|\*\|%\|<<\|>>\|>>>\|&\||\|\^\)\?=\@<!==\@!>\@!\)/
\                      contains=@coffeeIdentifier,coffeeAssignSymbols,
\                                coffeeAssignBrackets
hi def link coffeeAssign Identifier

" An error for reserved keywords
if !exists("coffee_no_reserved_words_error")
  syn match coffeeReservedError /\<\%(case\|default\|function\|var\|void\|with\|const\|let\|enum\|export\|import\|native\|__hasProp\|__extends\|__slice\|__bind\|__indexOf\)\>/
  hi def link coffeeReservedError Error
endif

" A normal object assignment
syn match coffeeObjAssign /@\?\I\i*\s*:\@<!::\@!/
\                         contains=@coffeeIdentifier,coffeeAssignSymbols
hi def link coffeeObjAssign coffeeAssign

" Strings used in string assignments, which can't have interpolations
syn region coffeeAssignString start=/"/ skip=/\\\\\|\\"/ end=/"/
\                             contained contains=@coffeeBasicString
syn region coffeeAssignString start=/'/ skip=/\\\\\|\\'/ end=/'/
\                             contained contains=@coffeeBasicString
hi def link coffeeAssignString String

" An object-string assignment
syn match coffeeObjStringAssign /\("\|'\)[^\1]*\1\s*;\@<!::\@!'\@!/
\                               contains=coffeeAssignString,coffeeAssignSymbols
" An object-integer assignment
syn match coffeeObjNumberAssign /\d\+\%(\.\d\+\)\?\s*:\@<!::\@!/
\                               contains=coffeeNumber,coffeeAssignSymbols

syn match coffeePrototype /::/
hi def link coffeePrototype SpecialChar

syn match coffeeFunction /[-=]>/
hi def link coffeeFunction Function

syn keyword coffeeTodo TODO FIXME XXX contained
hi def link coffeeTodo Todo

syn match coffeeComment /#.*/ contains=@Spell,coffeeTodo
hi def link coffeeComment Comment

syn region coffeeBlockComment start=/####\@!/ end=/###/
\                             contains=@Spell,coffeeTodo
hi def link coffeeBlockComment coffeeComment

" A comment in a heregex
syn region coffeeHeregexComment start=/#/ end=/\ze\/\/\/\|$/
\                               contained contains=@Spell,coffeeTodo
hi def link coffeeHeregexComment coffeeComment

" Embedded JavaScript
syn region coffeeEmbed matchgroup=coffeeEmbedDelim
\                      start=/`/ skip=/\\\\\|\\`/ end=/`/
\                      contains=@coffeeJS
hi def link coffeeEmbedDelim Delimiter

syn region coffeeInterp matchgroup=coffeeInterpDelim
\                       start=/\#{/ end=/}/
\                       contained contains=TOP
hi def link coffeeInterpDelim Delimiter

" A string escape sequence
syn match coffeeEscape /\\\d\d\d\|\\x\x\{2\}\|\\u\x\{4\}\|\\./ contained
hi def link coffeeEscape SpecialChar

" A regex -- must not follow a parenthesis, number, or identifier, and must not
" be followed by a number
syn region coffeeRegex start=/\%(\%()\|\i\@<!\d\)\s*\|\i\)\@<!\/\s\@!/
\                      skip=/\[[^\]]\{-}\/[^\]]\{-}\]/
\                      end=/\/[gimy]\{,4}\d\@!/
\                      oneline contains=@coffeeBasicString
hi def link coffeeRegex String

" A heregex
syn region coffeeHeregex start=/\/\/\// end=/\/\/\/[gimy]\{,4}/
\                        contains=@coffeeInterpString,coffeeHeregexComment
\                        fold
hi def link coffeeHeregex coffeeRegex

" Heredoc strings
syn region coffeeHeredoc start=/"""/ end=/"""/ contains=@coffeeInterpString
\                        fold
syn region coffeeHeredoc start=/'''/ end=/'''/ contains=@coffeeBasicString
\                        fold
hi def link coffeeHeredoc String

" An error for trailing whitespace, as long as the line isn't just whitespace
if !exists("coffee_no_trailing_space_error")
  syn match coffeeSpaceError /\S\@<=\s\+$/ display
  hi def link coffeeSpaceError Error
endif

" An error for trailing semicolons, for help transitioning from JavaScript
if !exists("coffee_no_trailing_semicolon_error")
  syn match coffeeSemicolonError /;$/ display
  hi def link coffeeSemicolonError Error
endif

" Ignore reserved words in dot-properties.
syn match coffeeDot /\.\@<!\.\i\+/ contains=ALLBUT,@coffeeReserved,
\                                                   coffeeReservedError
\                                  transparent

let b:current_syntax = "coffee"
