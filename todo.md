# To do for full support

- Destructuring assignments like:

      [a, b] = c
      {a, b} = c
       └──┴─ these should be highlighted as identifiers

- Assignments inside brackets (sounds simple enough):

      a[b -= c] = d

  this should still be highlighted correctly:

      a[b[c]] = d

- Smart, lookback outdenting for cases like:

      a = {
        b: ->
          c
        }
      └─ bracket should be put here

- Should indent if the previous line ends, or the current line starts, with one
  of these:

      + - * / % | & , . == != <= >= += -= (etc) is isnt and or && || 

- Keywords and operators shouldn't be highlighted as such inside assignments.
  This will probably require turning any "syntax keyword" commands:

      syntax keyword coffeeStatement return break continue throw

  into regexp matches:

      syntax match coffeeStatement /\<return\|break\|continue\|throw\>/
