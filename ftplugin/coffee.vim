" Language:    CoffeeScript
" Maintainer:  Mick Koch <kchmck@gmail.com>
" URL:         http://github.com/kchmck/vim-coffee-script
" License:     WTFPL

if exists("b:did_ftplugin")
  finish
endif

let b:did_ftplugin = 1

" Previously-opened `CoffeeCompile` buffer
let s:coffee_compile_buf = -1

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

" Compile some CoffeeScript and show it in a scratch buffer. We handle ranges
" like this to stop the cursor from being moved before the function is called.
function! s:CoffeeCompile(startline, endline)
  " Store the current buffer and cursor.
  let s:coffee_compile_prev_buf = bufnr('%')
  let s:coffee_compile_prev_pos = getpos('.')

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

    nnoremap <buffer> <silent> q :hide<CR>
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

" Deprecated: Compile the current file on write.
if exists("coffee_compile_on_save")
  autocmd BufWritePost,FileWritePost *.coffee silent !coffee -c "<afile>" &
endif
