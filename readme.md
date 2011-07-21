This project adds [CoffeeScript] support to the vim editor. It handles syntax,
indenting, and compiling.

![Screenshot][screenshot]

[CoffeeScript]: http://coffeescript.org
[todo]: http://github.com/kchmck/vim-coffee-script/blob/master/todo.md
[screenshot]: http://i.imgur.com/xbto8.png

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

  ![CoffeeMake](http://i.imgur.com/vz10U.png)

  ![CoffeeMake](http://i.imgur.com/2vPNl.png)

  ![CoffeeMake](http://i.imgur.com/Dq3dj.png)

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
with the `-b` option, but shows any errors:

    autocmd BufWritePost *.coffee silent CoffeeMake! -b | cwindow | redraw!

The `redraw!` command is needed to fix a redrawing quirk in terminal vim, but
can removed for gVim.

#### Default compiler options

The `CoffeeMake` command passes any options in the `coffee_make_options`
variable along to the compiler. This can be used to set default options:

    let coffee_make_options = "-n"

### Compiling a CoffeeScript Snippet

The `CoffeeCompile` command shows how the current file or a snippet of
CoffeeScript would be compiled to JavaScript. Calling `CoffeeCompile` without a
range compiles the whole file:

  ![CoffeeCompile](http://i.imgur.com/gvgGi.png)

  ![Compiled](http://i.imgur.com/F18Vt.png)

Calling `CoffeeCompile` with a range, like in visual mode, compiles the selected
snippet of CoffeeScript:

  ![CoffeeCompile Snippet](http://i.imgur.com/yMJLd.png)

  ![Compiled Snippet](http://i.imgur.com/G0oJi.png)

This scratch buffer can be quickly closed by hitting the `q` key.

### Running some CoffeeScript

The `CoffeeRun` command compiles the current file or selected snippet and runs
the resulting JavaScript. Output is shown at the bottom of the screen:

  ![CoffeeRun](http://i.imgur.com/K32n7.png)

  ![CoffeeRun Output](http://i.imgur.com/4f9Xz.png)

### Customizing

These customizations can be enabled or disabled by adding the relevant `let`
statement to your `vimrc`.

#### Fold by indentation

Folding is automatically setup as indent-based:

  ![Folding](http://i.imgur.com/Cq9JA.png)

It's disabled by default, but can be enabled with:

    let coffee_folding = 1

Otherwise, it can be quickly toggled per-file by hitting `zi`.

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
