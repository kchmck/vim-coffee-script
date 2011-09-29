syn include @hamlCoffeeScript syntax/coffee.vim
syn region  hamlCoffeescriptFilter matchgroup=hamlFilter start="^\z(\s*\):coffeescript\s*$" end="^\%(\z1 \| *$\)\@!" contains=@hamlCoffeeScript,hamlInterpolation keepend
