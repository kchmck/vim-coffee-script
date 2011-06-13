" Language:    CoffeeScript
" Maintainer:  Mick Koch <kchmck@gmail.com>
" URL:         http://github.com/kchmck/vim-coffee-script
" License:     WTFPL

if exists("b:did_ftplugin")
  finish
endif

let b:did_ftplugin = 1

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

if !exists("coffee_make_options")
  let coffee_make_options = ""
endif

" Function that sets the correct makeprg.
function! s:SetMakePrg()
  let &l:makeprg = "coffee -c " . g:coffee_make_options . ' $* ' . fnameescape(expand('%'))
endfunction

" Set makeprg.
call s:SetMakePrg()
" Reset makeprg on rename.
autocmd BufFilePost,BufWritePost,FileWritePost <buffer> call s:SetMakePrg()

" Compile some CoffeeScript.
command! -range=% CoffeeCompile <line1>,<line2>:w !coffee -scb
" Compile the current file.
command! -bang -bar -nargs=* CoffeeMake make<bang> <args>
" Run the selected text or the entire file and show output on vim command line
command! -range=% CoffeeRun <line1>,<line2>:w !coffee -s

" Deprecated: Compile the current file on write.
if exists("coffee_compile_on_save")
  autocmd BufWritePost,FileWritePost *.coffee silent !coffee -c "<afile>" &
endif
