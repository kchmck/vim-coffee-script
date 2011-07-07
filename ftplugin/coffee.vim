" Language:    CoffeeScript
" Maintainer:  Mick Koch <kchmck@gmail.com>
" URL:         http://github.com/kchmck/vim-coffee-script
" License:     WTFPL

if exists("b:did_ftplugin")
  finish
endif

let b:did_ftplugin = 1

" Don't let new windows overwrite these.
if !exists("s:coffee_compile_prev_buf")
  " Buffer and cursor position before the `CoffeeCompile` buffer was opened
  let s:coffee_compile_prev_buf = -1
  let s:coffee_compile_prev_pos = []
  " Previously-opened `CoffeeCompile` buffer
  let s:coffee_compile_buf = -1
endif

setlocal formatoptions-=t formatoptions+=croql
setlocal comments=:#
setlocal commentstring=#\ %s

setlocal errorformat=Error:\ In\ %f\\,\ %m\ on\ line\ %l,
                    \Error:\ In\ %f\\,\ Parse\ error\ on\ line\ %l:\ %m,
                    \SyntaxError:\ In\ %f\\,\ %m,
                    \%-G%.%#

" Fold by indentation, but only if enabled.
setlocal foldmethod=indent

if !exists("coffee_folding")
  setlocal nofoldenable
endif

" Extra options passed to `CoffeeMake`
if !exists("coffee_make_options")
  let coffee_make_options = ""
endif

" Update `makeprg` for the current filename. This is needed to support filenames
" with spaces and quotes while also supporting generic `make`.
function! s:SetMakePrg()
  let &l:makeprg = "coffee -c " . g:coffee_make_options . ' $* '
  \              . fnameescape(expand('%'))
endfunction

" Set `makeprg` initially.
call s:SetMakePrg()
" Reset `makeprg` on rename.
autocmd BufFilePost,BufWritePost,FileWritePost <buffer> call s:SetMakePrg()

" Save the cursor position.
function! s:CoffeeCompileSavePos()
  let buf = bufnr('%')

  if buf != s:coffee_compile_buf
    let s:coffee_compile_prev_buf = buf
    let s:coffee_compile_prev_pos = getpos('.')
  endif
endfunction

" Try to reset the cursor position.
function! s:CoffeeCompileResetPos()
  let win = bufwinnr(s:coffee_compile_prev_buf)

  if win != -1
    exec win 'wincmd w'
    call setpos('.', s:coffee_compile_prev_pos)
  endif

  autocmd! CoffeeCompileSavePos
endfunction

" Compile some CoffeeScript and show it in a scratch buffer. We handle ranges
" like this to stop the cursor from being moved before the function is called.
function! s:CoffeeCompile(startline, endline)
  " Store the current buffer and cursor.
  call s:CoffeeCompileSavePos()

  " Build stdin lines.
  let lines = join(getline(a:startline, a:endline), "\n")
  " Get compiler output.
  let output = system('coffee -scb 2>&1', lines)

  " Use at most half of the screen.
  let max_height = winheight('%') / 2
  " Try to get the old window.
  let win = bufwinnr(s:coffee_compile_buf)

  if win == -1
    " Make a new window and store its ID.
    botright new
    let s:coffee_compile_buf = bufnr('%')

    setlocal bufhidden=wipe buftype=nofile
    setlocal nobuflisted noswapfile nowrap

    autocmd BufWipeout <buffer> call s:CoffeeCompileResetPos()
    nnoremap <buffer> <silent> q :hide<CR>

    " Save the cursor position on each buffer switch.
    augroup CoffeeCompileSavePos
      autocmd BufEnter,BufLeave * call s:CoffeeCompileSavePos()
    augroup END
  else
    " Move to the old window and clear the buffer.
    exec win 'wincmd w'
    setlocal modifiable
    exec '% delete _'
  endif

  " Paste in the output and delete the last empty line.
  put! =output
  exec '$ delete _'

  exec 'resize' min([max_height, line('$') + 1])
  call cursor(1, 1)

  if v:shell_error
    " A compile error occurred.
    setlocal filetype=
  else
    " Coffee was compiled successfully.
    setlocal filetype=javascript
  endif

  setlocal nomodifiable
endfunction

" Peek at compiled CoffeeScript.
command! -range=% -bar CoffeeCompile call s:CoffeeCompile(<line1>, <line2>)
" Compile the current file.
command! -bang -bar -nargs=* CoffeeMake make<bang> <args>
" Run some CoffeeScript.
command! -range=% -bar CoffeeRun <line1>,<line2>:w !coffee -s
