This project adds [CoffeeScript] support to the vim editor. Currently, it
supports [almost][todo] all of CoffeeScript's syntax and indentation style.

![Screenshot][screenshot]

[CoffeeScript]: http://coffeescript.org
[todo]: http://github.com/kchmck/vim-coffee-script/blob/master/todo.md
[screenshot]: http://i.imgur.com/xbto8.png

### Installing and using

1. Install [pathogen] into `~/.vim/autoload/` and add the following line to your
   `~/.vimrc`:

        call pathogen#runtime_append_all_bundles()

     Be aware that it must be added before any `filetype plugin indent on`
     lines according to the install page:

     > Note that you need to invoke the pathogen functions before invoking
     > "filetype plugin indent on" if you want it to load ftdetect files. On
     > Debian (and probably other distros), the system vimrc does this early on,
     > so you actually need to "filetype off" before "filetype plugin indent on"
     > to force reloading.

[pathogen]: http://www.vim.org/scripts/script.php?script_id=2332

2. Create, and change into, the `~/.vim/bundle/` directory:

        $ mkdir -p ~/.vim/bundle
        $ cd ~/.vim/bundle

3. Make a clone of the `vim-coffee-script` repository:

        $ git clone git://github.com/kchmck/vim-coffee-script.git
        [...]
        $ ls
        vim-coffee-script/

Thatʼs it. Pathogen should handle the rest. Opening a file with a `.coffee`
extension or a `Cakefile` will load all the CoffeeScript stuff.

### Updating

1. Change into the `~/.vim/bundle/vim-coffee-script/` directory:

        $ cd ~/.vim/bundle/vim-coffee-script

2. Pull in the latest changes:

        $ git pull

Everything will then be brought up to date.

### Customizing

#### Compile the current file on write/save

If you are using the NodeJS version of CofeeScript, with the `coffee` command 
in your `$PATH`, you can enable auto-compiling on file write/save like so:
	
    let coffee_compile_on_save = 1

This will compile the CoffeeScript to JavaScript. For example,
`/Users/brian/ZOMG.coffee` will compile to `/Users/brian/ZOMG.js`.

#### Disable trailing whitespace error highlighting

If having trailing whitespace highlighted as an error is a bit much, the
following line can be added to your `~/.vimrc` to disable it:

    let coffee_no_trailing_space_error = 1

#### Disable trailing semicolon error highlighting

Likewise for the highlighting of trailing semicolons:

    let coffee_no_trailing_semicolon_error = 1

#### Disable future/reserved words error highlighting

The same for reserved words:

    let coffee_no_reserved_words_error = 1
