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

function! GetCoffeeIndent(curlinenum)
  " Find a non-blank line above the current line
  let prevlinenum = prevnonblank(a:curlinenum - 1)

  " No indenting is needed at the start of a file
  if prevlinenum == 0
    return 0
  endif

  let previndent = indent(prevlinenum)
  let curindent = indent(a:curlinenum)

  " Strip off leading whitespace
  let curline = getline(a:curlinenum)[curindent : -1]
  let prevline = getline(prevlinenum)[previndent : -1]

  for regexp in s:outdent
    if curline =~ regexp
      if prevline !~ ' then '
        return curindent - &shiftwidth
      endif
    endif
  endfor

  for regexp in s:indent_after
    if prevline =~ regexp
      if prevline !~ ' then '
        return previndent + &shiftwidth
      endif
    endif
  endfor

  for regexp in s:outdent_after
    if prevline =~ regexp
      return previndent - &shiftwidth
    endif
  endfor

  " No indenting or outdenting is needed
  return previndent
endfunction
