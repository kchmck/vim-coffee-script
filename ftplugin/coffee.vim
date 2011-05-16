" Language:    CoffeeScript
" Maintainer:  Mick Koch <kchmck@gmail.com>
" URL:         http://github.com/kchmck/vim-coffee-script
" License:     WTFPL

if exists("b:did_ftplugin")
  finish
endif

let b:did_ftplugin = 1

setlocal formatoptions-=t formatoptions+=croql
setlocal comments=f-1:###,:#
setlocal commentstring=#\ %s

setlocal makeprg=coffee\ -c\ $*\ '%'
setlocal errorformat=Error:\ In\ %f\\,\ %m\ on\ line\ %l,
                    \Error:\ In\ %f\\,\ Parse\ error\ on\ line\ %l:\ %m,
                    \SyntaxError:\ In\ %f\\,\ %m.,
                    \%-G%.%#

" Fold by indentation, but only if enabled.
setlocal foldmethod=indent

if !exists("coffee_folding")
  setlocal nofoldenable
endif

if !exists("coffee_make_options")
  let coffee_make_options = ""
endif

" Compile some CoffeeScript.
command! -range=% CoffeeCompile <line1>,<line2>:w !coffee -scb
" Compile the current file.
command! -bang -bar -nargs=* CoffeeMake exec 'make<bang>' coffee_make_options '<args>'

" Deprecated: Compile the current file on write.
if exists("coffee_compile_on_save")
  autocmd BufWritePost,FileWritePost *.coffee silent !coffee -c "<afile>" &
endif
