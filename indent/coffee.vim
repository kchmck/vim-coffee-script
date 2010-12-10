" Language:    CoffeeScript
" Maintainer:  Mick Koch <kchmck@gmail.com>
" URL:         http://github.com/kchmck/vim-coffee-script
" License:     WTFPL

if exists("b:did_indent")
  finish
endif

let b:did_indent = 1

setlocal autoindent
setlocal indentexpr=GetCoffeeIndent(v:lnum)
" Make sure GetCoffeeIndent is run when these are typed so they can be
" indented or outdented.
setlocal indentkeys+=0],0),0.,=else,=when,=catch,=finally

" Only define the function once.
if exists("*GetCoffeeIndent")
  finish
endif

" Join a list of regexps as branches.
function! s:RegexpJoin(regexps)
  return join(a:regexps, '\|')
endfunction

" Create a regexp group from a list of regexps.
function! s:RegexpGroup(...)
  return '\%(' . s:RegexpJoin(a:000) . '\)'
endfunction

" Outdent certain keywords and brackets.
let s:outdent = '^'
\             . s:RegexpGroup('else', 'when', 'catch', 'finally', ']', '}', ')')

" Indent after certain keywords.
let s:indent_after_keywords = '^'
\                           . s:RegexpGroup('if', 'unless', 'else', 'for',
\                                           'while', 'until', 'loop', 'switch',
\                                           'when', 'try', 'catch', 'finally',
\                                           'class')
\                           . '\>'

" Indent after brackets, functions, and assignments.
let s:indent_after_literals = s:RegexpGroup('\[', '{', '(', '->', '=>', ':', '=')
\                           . '$'

" Combine the two regexps above.
let s:indent_after = s:RegexpJoin([s:indent_after_keywords,
\                                  s:indent_after_literals])

" Indent after operators at the end of lines.
let s:continuations = s:RegexpGroup('-\@<!>', '=\@<!>', '-\@<!-', '+\@<!+',
\                                   '<', '\*', '/', '%', '|', '&', ',',
\                                   '\.\@<!\.', 'is', 'isnt', 'and', 'or')
\                   . '$'

" Indent after certain keywords used as multi-line assignments.
let s:assignment_keywords = s:RegexpGroup(':', '=')
\                         . '\s*\<'
\                         . s:RegexpGroup('if', 'unless', 'for', 'while',
\                                         'until', 'switch', 'try', 'class')
\                         . '\>'

" Outdent after certain keywords.
let s:outdent_after = '^'
\                   . s:RegexpGroup('return', 'break', 'continue', 'throw')
\                   . '\>'

" Don't outdent if the line contains one of these keywords (for cases like
" 'return if a is b', 'break unless a', etc.)
let s:dont_outdent_after = '\<' . s:RegexpGroup('if', 'unless') . '\>'

" Check for a single-line statement (e.g., 'if a then b'), which doesn't need an
" indent afterwards.
function! s:IsSingleLineStatement(line)
  " The 'then' keyword is usually a good hint.
  return a:line =~ '\<then\>'
endfunction

" Check for a single-line 'else' statement (e.g., 'else return a' but
" not 'else if a'), which doesn't need an indent afterwards.
function! s:IsSingleLineElse(line)
  " Check if the line actually starts with 'else', then if the line contains
  " anything other than 'else', then finally if the line is actually an 'else'
  " statement rather than an 'else if' or 'else unless' statement.
  return a:line =~ '^else\>'
  \   && a:line !~ '^else$'
  \   && a:line !~ '^else if\>'
  \   && a:line !~ '^else unless\>'
endfunction

" Check if a 'when' statement is the first in a switch block by searching the
" previous line for the 'switch' keyword. The first 'when' shouldn't be
" outdented.
function! s:IsFirstWhen(curline, prevline)
  return a:curline =~ '^when\>' && a:prevline =~ '\<switch\>'
endfunction

" Check for a multi-line assignment like
"   a = if b
"     c
"   else
"     d
function! s:IsMultiLineAssignment(line)
  return a:line =~ s:assignment_keywords
endfunction

" Check if a line is a comment.
function! s:IsComment(line)
  return a:line =~ '^#'
endfunction

" Check if a line is a dot-access.
function! s:IsDotAccess(line)
  return a:line =~ '^\.'
endfunction

" Check if a line is a continuation.
function! s:IsContinuation(line)
  return a:line =~ s:continuations
endfunction

function! s:ShouldOutdent(curline, prevline)
  return !s:IsSingleLineStatement(a:prevline)
  \   && !s:IsFirstWhen(a:curline, a:prevline)
  \   &&  a:prevline !~ s:outdent_after
  \   &&  a:curline =~ s:outdent
endfunction

function! s:ShouldIndent(curline, prevline)
  return !s:IsDotAccess(a:prevline) && s:IsDotAccess(a:curline)
endfunction

function! s:ShouldIndentAfter(prevline, prevprevline)
  return !s:IsSingleLineStatement(a:prevline)
  \   && !s:IsSingleLineElse(a:prevline)
  \   && !s:IsComment(a:prevline)
  \
  \   && (a:prevline =~ s:indent_after
  \   ||  s:IsMultiLineAssignment(a:prevline)
  \
  \   || (s:IsContinuation(a:prevline)
  \   && !s:IsContinuation(a:prevprevline)
  \   &&  a:prevprevline !~ s:indent_after_literals))
endfunction

function! s:ShouldOutdentAfter(prevline)
  return (a:prevline !~ s:dont_outdent_after
  \   ||  s:IsSingleLineStatement(a:prevline))
  \   &&  a:prevline =~ s:outdent_after
endfunction

" Get the nearest previous non-blank line.
function! s:GetPrevLineNum(linenum)
  return prevnonblank(a:linenum - 1)
endfunction

" Get the contents of a line without leading whitespace.
function! s:GetTrimmedLine(linenum, indent)
  return substitute(getline(a:linenum)[a:indent : -1], '\s\+$', '', '')
endfunction

function! GetCoffeeIndent(curlinenum)
  let prevlinenum = s:GetPrevLineNum(a:curlinenum)
  let prevprevlinenum = s:GetPrevLineNum(prevlinenum)

  " No indenting is needed at the start of a file.
  if prevlinenum == 0
    return 0
  endif

  let curindent = indent(a:curlinenum)
  let previndent = indent(prevlinenum)
  let prevprevindent = indent(prevprevlinenum)

  let curline = s:GetTrimmedLine(a:curlinenum, curindent)
  let prevline = s:GetTrimmedLine(prevlinenum, previndent)
  let prevprevline = s:GetTrimmedLine(prevprevlinenum, prevprevindent)

  if s:ShouldIndent(curline, prevline)
    return previndent + &shiftwidth
  endif

  if s:ShouldOutdent(curline, prevline)
    " Is the line already outdented?
    if curindent < previndent
      return curindent
    else
      return curindent - &shiftwidth
    endif
  endif

  if s:ShouldIndentAfter(prevline, prevprevline)
    return previndent + &shiftwidth
  endif

  if s:ShouldOutdentAfter(prevline)
    return previndent - &shiftwidth
  endif

  " No indenting or outdenting is needed
  return curindent
endfunction
