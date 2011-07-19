" Language:    CoffeeScript
" Maintainer:  Mick Koch <kchmck@gmail.com>
" URL:         http://github.com/kchmck/vim-coffee-script
" License:     WTFPL

" Syntax highlighting for text/coffeescript script tags
unlet b:current_syntax
syn include @htmlCoffeeScript syntax/coffee.vim
syn region javaScript start=+<script [^>]*type *=[^>]*text/coffeescript[^>]*>+ keepend end=+</script>+me=s-1 contains=@htmlCoffeeScript,htmlScriptTag,@htmlPreproc
let b:current_syntax = "html"
