# The Generic Interface

## Overview

### Handling Intervals

The operations of the generic interface are based on intervals as the fundamental elements.
Intervals can be thought of as vectors in a vector space (or more precisely: a module over integers).
They can be added, subtracted, negated, and multiplied with integers.
Pitches, on the other hand, can be seen as points in this space and are represented as intervals
in relation to an (implicit) origin.
Therefore, pitch types are mainly defined as a wrapper type `Pitch{Interval}`
that generically defines its arithmetic operations in terms of the corresponding interval type.

Interval types (here denoted as `I`) define the following operations:

- `I + I`
- `I - I`
- `-I`
- `I * Integer`
- `Integer * I`
- `sign(I)`
- `abs(I)`

The sign indicates the logical direction of the interval by musical convention
(upward = positive, downward = negative),
even if the interval space is multi-dimensional.
Consequently, `abs` ensures that an interval is neutral or upward-directed.
For interval classes (which are generally undirected),
the sign indicates the direction of the "shortest" class member:

```julia-repl
julia> sign(i"P4")
1

julia> sign(i"P5") # == -i"P4"
-1
```

In addition to arithmetic operations, some special intervals are defined:

- `unison(Type{I})` / `zero(Type{I})`
- `octave(Type{I})`
- `chromsemi(Type{I})` (a chromatic semitone, optional)
- `isstep(I)` (optional, a predicate that test whether the interval is considered a "step")

Finally, some operations specify the relationship between intervals and interval classes:

- `ic(I)`: Returns the corresponding interval class.
- `embed(IC [, octs::Int])`: Returns a canonical embedding of an interval class into interval space.
- `intervaltype(Type{IC}) = I`
- `intervalclasstype(Type{I}) = IC`

### Handling Pitches

Pitch operations generally interact with intervals
(and can be derived from the interval operations):

- `P + I -> P`
- `I + P -> P`
- `P - I -> P`
- `P - P -> I`
- `pc(P) -> PC`
- `embed(PC [, octaves]) -> P`

### Other useful functions

Besides the specific functions of the interface,
pitch and interval types generally implement basic functions such as

- `isless` / `<`
- `isequal` / `==`
- `hash`
- `show` (usually also specialized for `Pitch{I}`)

Note that the ordering of pitches is generally not unique,
so `isless` uses an appropriate convention for each interval type.

## Generic API Reference

Here we only list the new functions that are introduced by this library,
not the ones that are already defined in `Base`.

### Special Intervals

```@docs
unison
octave
chromsemi
isstep
```

### Classes (Octave Equivalence)

```@docs
ic
pc
embed
intervaltype
intervalclasstype
```
