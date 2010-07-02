- Bracketed assignments like:

      a[b]: c
      a[b[c]]: d
      a[b[c[d]]]: e
      a[b][c]: d

- Destructuring assignments like:

      [a, b]: c

- Smart, lookback outdenting for cases like:

      a: {
        b: ->
          c
        }
      └─ bracket should be put here

- Bracket errors, like the C syntax highlighter:

      a [b, c, d])
