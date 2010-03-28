These files add Vim syntax highlighting and indenting support for the fantastic
[CoffeeScript language](http://coffeescript.org).

![Screenshot](http://i.imgur.com/9T58b.png)

Currently, all keywords, function syntaxes (`->`, `=>`, and `<-`), special
variables (`@vars`, `this`, `arguments`, etc.), numbers, comments, multiline
strings, regular expressions, and interpolations are highlighted.

In addition, the cursor is automatically indented or outdented based on the
surrounding context. For example, hitting the return key after an `if` statement
will indent the cursor one `shiftwidth`; doing the same after *most* `return`
statements will instead outdent the cursor (since nothing after the `return`
will be evaluated).

### Installation

1. **Download** and **extract** the [tarball] or [zipball].
2. **Copy** the extracted folders (`syntax`, `indent`, etc.) into the `~/.vim/`
   directory.
3. ???
4. Profit!

[tarball]: http://github.com/kchmck/vim-coffee-script/tarball/master
[zipball]: http://github.com/kchmck/vim-coffee-script/zipball/master
