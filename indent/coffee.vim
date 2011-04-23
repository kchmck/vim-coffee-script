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

" Join a list of regexs as branches.
function! s:RegexJoin(regexes)
  return join(a:regexes, '\|')
endfunction

" Create a regex group from a list of regexes.
function! s:RegexGroup(...)
  return '\%(' . s:RegexJoin(a:000) . '\)'
endfunction

" Outdent certain keywords and brackets.
let s:outdent = '^'
\             . s:RegexGroup('else', 'when', 'catch', 'finally', ']', '}', ')')

" Indent after certain keywords.
let s:indent_after_keywords = '^'
\                           . s:RegexGroup('if', 'unless', 'else', 'for',
\                                          'while', 'until', 'loop', 'switch',
\                                          'when', 'try', 'catch', 'finally',
\                                          'class')
\                           . '\>'

" Indent after brackets, functions, and assignments.
let s:indent_after_literals = s:RegexGroup('\[', '{', '(', '->', '=>', ':', '=')
\                           . '$'

" Combine the two regexes above.
let s:indent_after = s:RegexJoin([s:indent_after_keywords,
\                                 s:indent_after_literals])

" Indent after operators at the end of lines.
let s:continuations = s:RegexGroup('-\@<!>', '=\@<!>', '-\@<!-', '+\@<!+',
\                                  '<', '\*', '/', '%', '|', '&', ',',
\                                  '\.\@<!\.', 'is', 'isnt', 'and', 'or')
\                   . '$'

" Indent after certain keywords used as multi-line assignments.
let s:assignment_keywords = s:RegexGroup(':', '=')
\                         . '\s*\<'
\                         . s:RegexGroup('if', 'unless', 'for', 'while',
\                                        'until', 'switch', 'try', 'class')
\                         . '\>'

" Outdent after certain keywords.
let s:outdent_after = '^'
\                   . s:RegexGroup('return', 'break', 'continue', 'throw')
\                   . '\>'

" Don't outdent if the line contains one of these keywords (for cases like
" 'return if a is b', 'break unless a', etc.)
let s:postfix_keywords = '\<' . s:RegexGroup('if', 'unless') . '\>'

" Max lines to look back for a match
let s:max_lookback = 50

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

" Check if a line is a postfix condition (and not a conditional assignment).
function! s:IsPostfixCondition(line)
  return a:line =~ s:postfix_keywords
  \   && a:line !~ ('^' . s:postfix_keywords)
  \   && a:line !~ ('[:=]\s*' . s:postfix_keywords)
endfunction

" Check for a multi-line assignment like
"   a = if b
"     c
"   else
"     d
function! s:IsMultiLineAssignment(line)
  return a:line =~ s:assignment_keywords
endfunction

" Get the linked syntax name of some text.
function! s:SyntaxName(line, col)
  return synIDattr(synIDtrans(synID(a:line, a:col, 1)), 'name')
endfunction

" Check if some text is a comment or string.
function! s:IsCommentOrString(line, col)
  return s:SyntaxName(a:line, a:col) =~ 'Comment\|Constant'
endfunction

" Crudely check if a line is a comment.
function! s:IsCommentQuick(line)
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
  \   && !s:IsCommentQuick(a:prevline)
  \
  \   && (a:prevline =~ s:indent_after
  \   ||  s:IsMultiLineAssignment(a:prevline)
  \
  \   || (s:IsContinuation(a:prevline)
  \   && !s:IsContinuation(a:prevprevline)
  \   &&  a:prevprevline !~ s:indent_after_literals))
endfunction

function! s:ShouldOutdentAfter(prevline)
  return (a:prevline !~ s:postfix_keywords
  \   ||  s:IsSingleLineStatement(a:prevline))
  \   &&  a:prevline =~ s:outdent_after
endfunction

function! s:ShouldSkip(startlinenum, linenum, col)
  let line = s:GetTrimmedLine(a:linenum)

  return  s:IsCommentOrString(a:linenum, a:col)
  \   || (s:IsSingleLineStatement(line)
  \   &&  a:startlinenum - a:linenum > 1)
  \   ||  s:IsPostfixCondition(line)
endfunction

" Find the farthest line to look back to, capped to line 1 (zero and negative
" numbers cause bad things).
function! s:MaxLookback(startlinenum)
  return max([1, a:startlinenum - s:max_lookback])
endfunction

" Get the skip expression for searchpair().
function! s:SkipExpr(startlinenum)
  return "s:ShouldSkip(" . a:startlinenum . ", line('.'), col('.'))"
endfunction

" Search for pairs of text.
function! s:SearchPair(start, end)
  " The cursor must be in the first column for regexes to match.
  call cursor(0, 1)

  let startlinenum = line('.')

  " Don't need the W flag since MaxLookback caps the search to line 1.
  return searchpair(a:start, '', a:end, 'bn',
  \                 s:SkipExpr(startlinenum),
  \                 s:MaxLookback(startlinenum))
endfunction

" Try to find a previous matching line.
function! s:GetMatch(curline, prevline)
  let firstchar = a:curline[0]

  if firstchar == '}'
    return s:SearchPair('{', '}')
  elseif firstchar == ')'
    return s:SearchPair('(', ')')
  elseif firstchar == ']'
    return s:SearchPair('\[', '\]')
  elseif a:curline =~ '^else'
    return s:SearchPair('\<if\|unless\|when\>', '\<else\>')
  elseif a:curline =~ '^catch'
    return s:SearchPair('\<try\>', '\<catch\>')
  elseif a:curline =~ '^finally'
    return s:SearchPair('\<try\>', '\<finally\>')
  elseif a:curline =~ '^when' && !s:IsFirstWhen(a:curline, a:prevline)
    return s:SearchPair('\<when\>', '\<when\>')
  endif

  return 0
endfunction

" Get the nearest previous non-blank line.
function! s:GetPrevLineNum(linenum)
  return prevnonblank(a:linenum - 1)
endfunction

" Get the contents of a line without leading or trailing whitespace.
function! s:GetTrimmedLine(linenum)
  return substitute(substitute(getline(a:linenum), '^\s\+', '', ''),
  \                                                '\s\+$', '', '')
endfunction

function! GetCoffeeIndent(curlinenum)
  let prevlinenum = s:GetPrevLineNum(a:curlinenum)
  let prevprevlinenum = s:GetPrevLineNum(prevlinenum)

  " No indenting is needed at the start of a file.
  if prevlinenum == 0
    return 0
  endif

  if s:IsCommentOrString(a:curlinenum, col('.'))
    return -1
  endif

  let curindent = indent(a:curlinenum)
  let previndent = indent(prevlinenum)

  let curline = s:GetTrimmedLine(a:curlinenum)
  let prevline = s:GetTrimmedLine(prevlinenum)
  let prevprevline = s:GetTrimmedLine(prevprevlinenum)

  let matchlinenum = s:GetMatch(curline, prevline)

  if matchlinenum
    return indent(matchlinenum)
  endif

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
  return -1
endfunction
