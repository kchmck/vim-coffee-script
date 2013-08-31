" Language:    CoffeeScript
" Maintainer:  Mick Koch <kchmck@gmail.com>
" URL:         http://github.com/kchmck/vim-coffee-script
" License:     WTFPL

if exists('b:did_indent')
  finish
endif

let b:did_indent = 1

setlocal autoindent
setlocal indentexpr=GetCoffeeIndent(v:lnum)
" Make sure GetCoffeeIndent is run when these are typed so they can be
" indented or outdented.
setlocal indentkeys+=0],0),0.,=else,=when,=catch,=finally

" If no indenting or outdenting is needed, either keep the indent of the cursor
" (use autoindent) or match the indent of the previous line.
if exists('g:coffee_indent_keep_current')
  let s:DEFAULT_LEVEL = '-1'
else
  let s:DEFAULT_LEVEL = 'previndent'
endif

" Only define the function once.
if exists('*GetCoffeeIndent')
  finish
endif

" Keywords to indent after
let s:INDENT_AFTER_KEYWORD = '^\%(if\|unless\|else\|for\|while\|until\|'
\                          . 'loop\|switch\|when\|try\|catch\|finally\|'
\                          . 'class\)\>'

" Operators to indent after but also count as a continuation
let s:INITIAL_CONTINUATION = '[([{:=]$'

" Operators to indent after
let s:INDENT_AFTER_OPERATOR = s:INITIAL_CONTINUATION . '\|[-=]>$'

" Keywords and operators that continue a line
let s:CONTINUATION = '\<\%(is\|isnt\|and\|or\)\>$'
\                  . '\|'
\                  . '\%([^-]-\|[^+]+\|<\|[^-=]>\|\*\|[^/]/\|%\||\|'
\                  . '&\|,\|[^.]\.\)$'

" Ancestor operators that prevent continuation indenting
let s:ALL_CONTINUATION = s:CONTINUATION . '\|' . s:INITIAL_CONTINUATION

" A continuation dot access
let s:DOT_ACCESS = '^\.'

" Keywords to outdent after
let s:OUTDENT_AFTER = '^\%(return\|break\|continue\|throw\)\>'

" A compound assignment like `... = if ...`
let s:COMPOUND_ASSIGNMENT = '[:=]\s*\%(if\|unless\|for\|while\|until\|'
\                         . 'loop\|switch\|try\|class\)\>'

" A postfix condition like `return ... if ...`.
let s:POSTFIX_CONDITION = '\S\s\+\zs\<\%(if\|unless\)\>'

" A single line else statement like `else ...` but not `else if ...`
let s:SINGLE_LINE_ELSE = '^else\s\+\%(\<\%(if\|unless\)\>\)\@!'

" Max lines to look back for a match
let s:MAX_LOOKBACK = 50

" Syntax names for strings
let s:SYNTAX_STRING = 'coffee\%(String\|AssignString\|Embed\|Regex\|Heregex\|'
\                   . 'Heredoc\)'

" Syntax names for comments
let s:SYNTAX_COMMENT = 'coffee\%(Comment\|BlockComment\|HeregexComment\)'

" Syntax names for strings and comments
let s:SYNTAX_STRING_COMMENT = s:SYNTAX_STRING . '\|' . s:SYNTAX_COMMENT

" Get the linked syntax name of a character.
function! s:SyntaxName(lnum, col)
  return synIDattr(synID(a:lnum, a:col, 1), 'name')
endfunction

" Check if a character is in a comment.
function! s:IsComment(lnum, col)
  return s:SyntaxName(a:lnum, a:col) =~ s:SYNTAX_COMMENT
endfunction

" Check if a character is in a string.
function! s:IsString(lnum, col)
  return s:SyntaxName(a:lnum, a:col) =~ s:SYNTAX_STRING
endfunction

" Check if a character is in a comment or string.
function! s:IsCommentOrString(lnum, col)
  return s:SyntaxName(a:lnum, a:col) =~ s:SYNTAX_STRING_COMMENT
endfunction

" Check if a whole line is a comment.
function! s:IsCommentLine(lnum)
  " Check the first non-whitespace character.
  return s:IsComment(a:lnum, indent(a:lnum) + 1)
endfunction

" Search a line for a regex until one is found outside a string or comment.
function! s:SearchCode(lnum, regex)
  " Start at the first column.
  let col = 0

  " Search until there are no more matches, unless a good match is found.
  while 1
    call cursor(a:lnum, col + 1)
    let [_, col] = searchpos(a:regex, 'cn', a:lnum)

    " No more matches.
    if !col
      break
    endif

    if !s:IsCommentOrString(a:lnum, col)
      return 1
    endif
  endwhile

  " No good match found.
  return 0
endfunction

" Check if a match should be skipped.
function! s:ShouldSkip(startlnum, lnum, col)
  " Skip if in a comment or string.
  if s:IsCommentOrString(a:lnum, a:col)
    return 1
  endif

  " Skip if a single line statement that isn't adjacent.
  if s:SearchCode(a:lnum, '\<then\>') && a:startlnum - a:lnum > 1
    return 1
  endif

  " Skip if a postfix condition.
  if s:SearchCode(a:lnum, s:POSTFIX_CONDITION) &&
  \ !s:SearchCode(a:lnum, s:COMPOUND_ASSIGNMENT)
    return 1
  endif

  return 0
endfunction

" Find the farthest line to look back to, capped to line 1 (zero and negative
" numbers cause bad things).
function! s:MaxLookback(startlnum)
  return max([1, a:startlnum - s:MAX_LOOKBACK])
endfunction

" Get the skip expression for searchpair().
function! s:SkipExpr(startlnum)
  return "s:ShouldSkip(" . a:startlnum . ", line('.'), col('.'))"
endfunction

" Search for pairs of text.
function! s:SearchPair(start, end)
  " The cursor must be in the first column for regexes to match.
  call cursor(0, 1)

  let startlnum = line('.')

  " Don't need the W flag since MaxLookback caps the search to line 1.
  return searchpair(a:start, '', a:end, 'bcn',
  \                 s:SkipExpr(startlnum),
  \                 s:MaxLookback(startlnum))
endfunction

" Try to find a previous matching line.
function! s:GetMatch(curline)
  let firstchar = a:curline[0]

  if firstchar == '}'
    return s:SearchPair('{', '}')
  elseif firstchar == ')'
    return s:SearchPair('(', ')')
  elseif firstchar == ']'
    return s:SearchPair('\[', '\]')
  elseif a:curline =~ '^else\>'
    return s:SearchPair('\<\%(if\|unless\|when\)\>', '\<else\>')
  elseif a:curline =~ '^catch\>'
    return s:SearchPair('\<try\>', '\<catch\>')
  elseif a:curline =~ '^finally\>'
    return s:SearchPair('\<try\>', '\<finally\>')
  endif

  return 0
endfunction

" Get the nearest previous line that isn't a comment.
function! s:GetPrevNormalLine(startlnum)
  let curlnum = a:startlnum

  while curlnum
    let curlnum = prevnonblank(curlnum - 1)

    if !s:IsCommentLine(curlnum)
      return curlnum
    endif
  endwhile

  return 0
endfunction

" Try to find a comment in a line.
function! s:FindComment(lnum)
  call cursor(a:lnum, 0)

  " Current column
  let cur = 0
  " Last column in the line
  let end = col('$') - 1

  while cur != end
    call cursor(0, cur + 1)
    let [_, cur] = searchpos('#', 'cn', a:lnum)

    if !cur
      break
    endif

    if s:IsComment(a:lnum, cur)
      return cur
    endif
  endwhile

  return 0
endfunction

" Get a line without comments or surrounding whitespace.
function! s:GetTrimmedLine(lnum)
  let comment = s:FindComment(a:lnum)
  let line = getline(a:lnum)

  if comment
    " Subtract 1 to get to the column before the comment and another 1 for
    " zero-based indexing.
    let line = line[:comment - 2]
  endif

  return substitute(substitute(line, '^\s\+', '', ''),
  \                                  '\s\+$', '', '')
endfunction

function! GetCoffeeIndent(curlnum)
  " Get the previous non-blank line (may be a comment.)
  let prevlnum = prevnonblank(a:curlnum - 1)

  " Don't do anything if there's no code before.
  if !prevlnum
    return -1
  endif

  " Get the previous non-comment line.
  let prevnlnum = s:GetPrevNormalLine(a:curlnum)

  " Try to find a matching statement. This handles outdenting.
  let curline = s:GetTrimmedLine(a:curlnum)
  let matchlnum = s:GetMatch(curline)

  if matchlnum
    return indent(matchlnum)
  endif

  " If the current line is a `when` and not the first in the `switch` block,
  " look back for a matching `when`.
  if curline =~ '^when\>' && !s:SearchCode(prevnlnum, '\<switch\>')
    let lnum = a:curlnum

    while lnum
      let lnum = s:GetPrevNormalLine(lnum)

      " Don't use GetTrimmedLine here just for efficiency.
      if getline(lnum) =~ '^\s*when\>'
        return indent(lnum)
      endif
    endwhile

    return -1
  endif

  " If the previous line is a comment, use the indent of the comment.
  if prevlnum != prevnlnum
    return indent(prevlnum)
  endif

  " Indent based on the previous line.
  let prevline = s:GetTrimmedLine(prevnlnum)
  let previndent = indent(prevnlnum)

  " Always indent after these operators.
  if prevline =~ s:INDENT_AFTER_OPERATOR
    return previndent + &shiftwidth
  endif

  " Indent after a continuation if it's the first.
  if prevline =~ s:CONTINUATION
    " If the line ends in a slash, make sure it isn't a regex.
    if prevline =~ '/$'
      " Move to the line so we can get the last column.
      call cursor(prevnlnum)

      if s:IsString(prevnlnum, col('$') - 1)
        return -1
      endif
    endif

    let prevprevlnum = s:GetPrevNormalLine(prevnlnum)

    " If the continuation is the first in the file, there can't be others before
    " it.
    if !prevprevlnum
      return previndent + &shiftwidth
    endif

    let prevprevline = s:GetTrimmedLine(prevprevlnum)

    " Only indent after the first continuation.
    if prevprevline !~ s:ALL_CONTINUATION
      return previndent + &shiftwidth
    endif

    return -1
  endif

  " Indent after these keywords and compound assignments if they aren't a
  " single line statement.
  if prevline =~ s:INDENT_AFTER_KEYWORD || prevline =~ s:COMPOUND_ASSIGNMENT
    if !s:SearchCode(prevnlnum, '\<then\>') && prevline !~ s:SINGLE_LINE_ELSE
      return previndent + &shiftwidth
    endif

    return -1
  endif

  " Indent a dot access if it's the first.
  if curline =~ s:DOT_ACCESS && prevline !~ s:DOT_ACCESS
    return previndent + &shiftwidth
  endif

  " Outdent after these keywords if they don't have a postfix condition or are
  " a single-line statement.
  if prevline =~ s:OUTDENT_AFTER
    if !s:SearchCode(prevnlnum, s:POSTFIX_CONDITION) ||
    \   s:SearchCode(prevnlnum, '\<then\>')
      return previndent - &shiftwidth
    endif
  endif

  " No indenting or outdenting is needed so use the default policy.
  exec 'return' s:DEFAULT_LEVEL
endfunction
