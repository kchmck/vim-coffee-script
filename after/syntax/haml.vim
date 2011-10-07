" Language:    CoffeeScript
" Maintainer:  Sven Felix Oberquelle <Svelix.Github@gmail.com>
" URL:         http://github.com/kchmck/vim-coffee-script
" License:     WTFPL

syn include @hamlCoffeeScript syntax/coffee.vim
syn region  hamlCoffeescriptFilter matchgroup=hamlFilter start="^\z(\s*\):coffeescript\s*$" end="^\%(\z1 \| *$\)\@!" contains=@hamlCoffeeScript,hamlInterpolation keepend
