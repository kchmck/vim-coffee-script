### Version 001 (Mid October 2011)

Removed deprecated `coffee_folding` option, split out compiler, fixed
indentation and syntax bugs, and added Haml support and omnicompletion.

 - The coffee compiler is now a proper vim compiler that can be loaded with
   `compiler coffee`.
 - CoffeeScript is now highlighted inside the `:coffeescript` filter in Haml.
 - Omnicompletion (`help compl-omni`) now uses JavaScript's dictionary to
   complete words
