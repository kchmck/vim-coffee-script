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
setlocal indentkeys+=0],0),=else,=catch,=finally

" Only define the function once
if exists("*GetCoffeeIndent")
  finish
endif

" Outdent certain keywords, '}', ']', and ')'
let s:outdent = ['^else', '^catch', '^finally', '^}', '^]', ')']

" Indent after certain keywords, '[', '{', '(', and functions
let s:indent_after = ['^if\>', '^else\>', '^for\>', '^while\>', '^switch\>',
\                     '^when\>', '^try\>', '^catch\>', '^finally\>', '^class\>',
\                     '[$', '{$', '($', '->$', '=>$']

" Outdent after certain keywords
let s:outdent_after = ['^return', '^break', '^continue', '^throw']

" A hint that the previous line is a one-liner
let s:oneliner_hint = '\<then\>'

function! s:Search(haystack, needle)
  for regexp in a:haystack
    if a:needle =~ regexp
      return 1
    endif
  endfor
endfunction

function! s:CheckOutdent(prevline, curline)
  " Don't double-outdent
  if a:prevline =~ s:oneliner_hint || s:Search(s:outdent_after, a:prevline)
    return 0
  endif

  return s:Search(s:outdent, a:curline)
endfunction

function! s:CheckIndentAfter(prevline)
  if a:prevline =~ s:oneliner_hint
    return 0
  endif

  return s:Search(s:indent_after, a:prevline)
endfunction

function! s:CheckOutdentAfter(prevline)
  return s:Search(s:outdent_after, a:prevline)
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
