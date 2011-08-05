This project adds [CoffeeScript] support to the vim editor. It handles syntax,
indenting, and compiling. Also included is an eco syntax and support for
`text/coffeescript` in html.

![Screenshot](http://i.imgur.com/xeLqC.png)

[CoffeeScript]: http://coffeescript.org

### Simple Installation

Installing the typical way takes less time, but leaves plugin files scattered.

1. Download the latest zipball off this plugin's [vim.org page][zipball].

2. Extract the archive into `~/.vim/`:

        unzip -od ~/.vim vim-coffee-script-HASH.zip

These steps are also used to update the plugin.

[zipball]: http://www.vim.org/scripts/script.php?script_id=3590

### Pathogen Installation

Since this plugin uses "rolling releases" based on git commits, using pathogen
and git is the preferred way to install. It takes more steps, but ends up
cleaner and easier to keep up-to-date.

1. Install tpope's [pathogen] into `~/.vim/autoload/` and add this line to your
   `vimrc`:

        call pathogen#runtime_append_all_bundles()

    Be aware that it must be added before any `filetype plugin indent on`
    lines according to the install page:

    > Note that you need to invoke the pathogen functions before invoking
    > "filetype plugin indent on" if you want it to load ftdetect files. On
    > Debian (and probably other distros), the system vimrc does this early on,
    > so you actually need to "filetype off" before "filetype plugin indent on"
    > to force reloading.

    To get the all the features of this plugin, be sure you do have a `filetype
    plugin indent on` line.

[pathogen]: http://www.vim.org/scripts/script.php?script_id=2332

2. Create, and change into, the `~/.vim/bundle/` directory:

        $ mkdir -p ~/.vim/bundle
        $ cd ~/.vim/bundle

3. Make a clone of the `vim-coffee-script` repository:

        $ git clone https://github.com/kchmck/vim-coffee-script.git

#### Updating

1. Change into the `~/.vim/bundle/vim-coffee-script/` directory:

        $ cd ~/.vim/bundle/vim-coffee-script

2. Pull in the latest changes:

        $ git pull

### Compiling the Current File and Autocompiling

The `CoffeeMake` command compiles the current file and parses any errors.

  ![CoffeeMake](http://i.imgur.com/OKRKE.png)

  ![CoffeeMake](http://i.imgur.com/PQ6ed.png)

  ![CoffeeMake](http://i.imgur.com/Jp6NI.png)

By default, `CoffeeMake` shows all compiler output and jumps to the first line
reported as an error by `coffee`:

    :CoffeeMake

Compiler output can be hidden with `silent`:

    :silent CoffeeMake

Line-jumping can be turned off by adding a bang:

    :CoffeeMake!

Options given to `CoffeeMake` are passed along to `coffee`:

    :CoffeeMake --bare

#### Autocompiling

To get autocompiling when a file is written (formerly `coffee_compile_on_save`),
add an `autocmd` like this to your `vimrc`:

    autocmd BufWritePost *.coffee silent CoffeeMake!

All of the customizations above can be used, too. This one compiles silently
and with the `-b` option, but shows any errors:

    autocmd BufWritePost *.coffee silent CoffeeMake! -b | cwindow | redraw!

The `redraw!` command is needed to fix a redrawing quirk in terminal vim, but
can removed for gVim.

#### Default compiler options

The `CoffeeMake` command passes any options in the `coffee_make_options`
variable along to the compiler. This can be used to set default options:

    let coffee_make_options = "--bare"

### Compiling a CoffeeScript Snippet

The `CoffeeCompile` command shows how the current file or a snippet of
CoffeeScript would be compiled to JavaScript. Calling `CoffeeCompile` without a
range compiles the whole file:

  ![CoffeeCompile](http://i.imgur.com/pTesp.png)

  ![Compiled](http://i.imgur.com/81QMf.png)

Calling `CoffeeCompile` with a range, like in visual mode, compiles the selected
snippet of CoffeeScript:

  ![CoffeeCompile Snippet](http://i.imgur.com/Rm7iu.png)

  ![Compiled Snippet](http://i.imgur.com/KmrG8.png)

This scratch buffer can be quickly closed by hitting the `q` key.

### Running some CoffeeScript

The `CoffeeRun` command compiles the current file or selected snippet and runs
the resulting JavaScript. Output is shown at the bottom of the screen:

  ![CoffeeRun](http://i.imgur.com/d4yXC.png)

  ![CoffeeRun Output](http://i.imgur.com/m6UID.png)

### Configuration

This plugin can be configured by adding the relevant `let` statement to your
`vimrc`.

#### Disable trailing whitespace error

Trailing whitespace is highlighted as an error by default. This can be disabled
with:

    let coffee_no_trailing_space_error = 1

#### Disable trailing semicolon error

Trailing semicolons are also considered an error for help transitioning from
JavaScript. This can be disabled with:

    let coffee_no_trailing_semicolon_error = 1

#### Disable reserved words error

Reserved words like `function` and `var` are highlighted as an error in contexts
disallowed by CoffeeScript. This can be disabled with:

    let coffee_no_reserved_words_error = 1

### Tuning Vim for CoffeeScript

Changing these core settings can make vim more CoffeeScript-friendly.

#### Fold by indentation

Folding by indentation is a good fit for CoffeeScript functions and classes.

  ![Folding](http://i.imgur.com/lpDWo.png)

To fold by indentation in CoffeeScript files, add this line to your `vimrc`:

    au BufNewFile,BufReadPost *.coffee setl foldmethod=indent nofoldenable

With this, folding is disabled by default but can be quickly toggled per-file
by hitting `zi`. To enable it by default, remove `nofoldenable`:

    au BufNewFile,BufReadPost *.coffee setl foldmethod=indent

#### Two-space indentation

To get standard two-space indentation in CoffeeScript files, add this line to
your `vimrc`:

    au BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab
