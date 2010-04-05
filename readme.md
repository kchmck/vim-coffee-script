These files add Vim syntax highlighting and indenting support for the fantastic
[CoffeeScript language](http://coffeescript.org).

![Screenshot](http://i.imgur.com/aLMl3.png)

Currently, all keywords, function syntaxes (`->`, `=>`, and `<-`), special
variables (`@vars`, `this`, `arguments`, etc.), numbers, comments, multiline
strings, regular expressions, and interpolations are highlighted.

In addition, the cursor is automatically indented or outdented based on the
surrounding context. For example, hitting the return key after an `if` statement
will indent the cursor one `shiftwidth`; doing the same after certain `return`
statements -- ones without an attached `if` or `unless` statement, that is --
will instead outdent the cursor.

### Installation

1. **Download** and **extract** the [tarball] or [zipball].
2. **Copy** the extracted folders (`syntax`, `indent`, etc.) into the `~/.vim/`
   directory (or any directory in your [runtimepath]).
3. ???
4. Profit!

[tarball]: http://github.com/kchmck/vim-coffee-script/tarball/master
[zipball]: http://github.com/kchmck/vim-coffee-script/zipball/master
[runtimepath]: http://vimdoc.sourceforge.net/htmldoc/options.html#'runtimepath'
