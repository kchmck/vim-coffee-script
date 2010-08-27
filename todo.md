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

      + - * / % | & , . is isnt and or && || 

- Support `else unless` in indentation:

      unless a
        b
      else unless c
        d
