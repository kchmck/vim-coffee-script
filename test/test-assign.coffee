# Basics
abc = 42
abc and= 42
abc.def = 42
abc.?def = 42
abc::def = 42
abc[def] = 42
abc[42] = 42
@abc[def] = 42
@[abc] = 42

# Don't highlight other operators
abc == 42
abc <= 42
abc >= 42

# Increment and Decrement
--abc
++abc
abc--
abc++
--abc[def]
++abc[def]
abc[def]--
abc[def]++

# Nested brackets
abc[def[42]] = 42

# Nested assignments
abc[def = ghi] = 42

# Interpolations
abc["#{def = 42}"] = 42
abc["#{def.ghi = 42}"] = 42
abc["#{def[ghi] = 42}"] = 42
abc["#{def['ghi']}"] = 42

# Don't overrun brackets
abc[def] = ghi[hij]

# Destructuring
[abc, def] = 42
{abc, def} = 42
