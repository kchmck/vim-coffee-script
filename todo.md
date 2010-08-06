- Destructuring assignments like:

      [a, b] = c
      {a, b} = c
       └──┴─ these should be highlighted as assignments

- Smart, lookback outdenting for cases like:

      a = {
        b: ->
          c
        }
      └─ bracket should be put here

- Bracket errors, like the C syntax highlighter:

      a [b, c, d])
