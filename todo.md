# To do for full support

- Destructuring assignments like:

      [a, b] = c
      {a, b} = c
       └──┴─ these should be highlighted as identifiers

- Fix assignments with brackets in these cases:

      a[b] = c[d]
      a[b -= c] = d

  and still highlight these correctly:

      a[b] = c
      a[b[c]] = d
      a[b[c] -= d] = e
