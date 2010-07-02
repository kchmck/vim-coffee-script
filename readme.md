This project adds [CoffeeScript] support to the vim editor. Specifically, it
adds support for CoffeeScriptʼs syntax, including string interpolations and
block comments, and indentation style.

![Screenshot][screenshot]

[CoffeeScript]: http://coffeescript.org
[screenshot]: http://i.imgur.com/JTSPz.png

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

[pathogen]: http://vim.org/scripts/script.php?script_id=2332

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

Everything will then be brought up to date!
