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

- Interpolated assignments:

      "interpolated#{'key'}": 123
