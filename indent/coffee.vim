" Language:    CoffeeScript
" Maintainer:  Mick Koch <kchmck@gmail.com>
" URL:         http://github.com/kchmck/vim-coffee-script
" Filenames:   *.coffee

if exists("b:did_indent")
  finish
endif

let b:did_indent = 1

setlocal autoindent
setlocal indentexpr=GetCoffeeIndent(v:lnum)
" Make sure GetCoffeeIndent is run when these are typed
setlocal indentkeys+=0],0),=else,=catch,=finally

" Only define the function once
if exists("*GetCoffeeIndent")
  finish
endif

" Outdent certain keywords, etc.
let s:outdent = ['^else', '^catch', '^finally', '^}', '^]', '^)']

" Indent after certain keywords, functions, etc.
let s:indent_after = ['^if\>', '^else\>', '^for\>', '^while\>', '^switch\>',
\                     '^when\>', '^try\>', '^catch\>', '^finally\>', '^class\>',
\                     '[$', '{$', '($', '->$', '=>$']

" Outdent after certain keywords
let s:outdent_after = ['^return\>', '^break\>', '^continue\>', '^throw\>']

" A hint that the previous line is a one-liner
let s:oneliner_hint = '\<then\>'

" See if a _line_ contains any regular expression in _regexps_
function! s:Search(line, regexps)
  for regexp in a:regexps
    if a:line =~ regexp
      return 1
    endif
  endfor

  return 0
endfunction

function! s:CheckOutdent(prevline, curline)
  " Don't double-outdent
  if a:prevline =~ s:oneliner_hint || s:Search(a:prevline, s:outdent_after)
    return 0
  endif

  return s:Search(a:curline, s:outdent)
endfunction

function! s:CheckIndentAfter(prevline)
  if a:prevline =~ s:oneliner_hint
    return 0
  endif

  return s:Search(a:prevline, s:indent_after)
endfunction

function! s:CheckOutdentAfter(prevline)
  return s:Search(a:prevline, s:outdent_after)
endfunction

function! GetCoffeeIndent(curlinenum)
  " Find a non-blank line above the current line
  let prevlinenum = prevnonblank(a:curlinenum - 1)

  " No indenting is needed at the start of a file
  if prevlinenum == 0
    return 0
  endif

  let curindent = indent(a:curlinenum)
  let previndent = indent(prevlinenum)

  " Strip off leading whitespace
  let curline = getline(a:curlinenum)[curindent : -1]
  let prevline = getline(prevlinenum)[previndent : -1]

  if s:CheckOutdent(prevline, curline)
    return curindent - &shiftwidth
  endif

  if s:CheckIndentAfter(prevline)
    return previndent + &shiftwidth
  endif

  if s:CheckOutdentAfter(prevline)
    return previndent - &shiftwidth
  endif

  " No indenting or outdenting is needed
  return previndent
endfunction
