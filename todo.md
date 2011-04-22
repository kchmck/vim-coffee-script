# Todo for Full Support

#### Support destructuring assignments

Highlight the identifier parts:

    [a, b] = c
    {a, b} = c

#### Fix assignments with brackets

Fix the highlighting of these:

    a[b] = c[d]
    a[b -= c] = d

And still highlight these correctly:

    a[b] = c
    a[b[c]] = d
    a[b[c] -= d] = e
