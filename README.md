# Pitches.jl

![tests](https://github.com/DCMLab/Pitches.jl/workflows/Tests/badge.svg)
[![codecov](https://codecov.io/gh/DCMLab/Pitches.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/DCMLab/Pitches.jl)
[![docs (development version)](https://img.shields.io/badge/docs-dev-blue.svg)](https://dcmlab.github.io/Pitches.jl/dev)

A library for handling musical pitches and intervals in a systematic way.
For other (and mostly compatible) implementations see:

- [pitchtypes](https://github.com/DCMLab/pitchtypes) (Python)
- a Haskell implementation (WIP, coming soon)
- a Clojure(Script) implementation (WIP, coming soon)

The general interface is described [in a separate specification](https://github.com/DCMLab/standards/blob/master/pitch-libraries/Spec.md).

## Overview

This library defines types for musical intervals and pitches
as well as a generic interface for writing algorithms
that work with different pitch and interval types.
For example, you can write a function like this

```julia
transposeby(pitches, interval) = [pitch + interval for pitch in pitches]
```

and it will work with any midi pitch:

```julia-repl
julia> transposeby((@midip [60, 63, 67]), midi(3))
3-element Array{Pitch{MidiInterval},1}:
 p63
 p66
 p70
```

... midi pitch classes:

```julia-repl
julia> transposeby(map(midipc, [3,7,10]), midic(3))
3-element Array{Pitch{MidiIC},1}:
 pc6
 pc10
 pc1
```

... spelled pitch:

```julia-repl
julia> transposeby([p"C4", p"E4", p"G4"], i"m3+0")
3-element Array{Pitch{SpelledInterval},1}:
 E♭4
 G4
 B♭4
```

... spelled pitch classes:

```julia-repl
julia> transposeby([p"C", p"E", p"G"], i"m3")
3-element Array{Pitch{SpelledIC},1}:
 E♭
 G
 B♭
```

... or any other pitch type.

## The Pitch/Interval Interface

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

Pitch operations generally interact with intervals
(and can be derived from the interval operations):

- `P + I -> P`
- `I + P -> P`
- `P - I -> P`
- `P - P -> I`
- `pc(P) -> PC`
- `embed(PC [, octaves]) -> P`

Besides the specific functions of the interface,
pitch and interval types generally implement basic functions such as

- `isless`
- `isequal`
- `hash`
- `show` (usually also specialized for `Pitch{I}`)

Note that the ordering of pitches is generally not unique,
so `isless` uses an appropriate convention for each interval type.

## Implemented Pitch and Interval Types

### Spelled Pitch

Spelled pitches and intervals are the standard types of the Western music notation system.
Unlike MIDI pitches, spelled pitches distinguish between enharmonically equivalent pitches
such as `E♭` and `D♯`.
Similarly, spelled intervals distinguish between intervals
such as `m3` (minor 3rd) and `a2` (augmented second) that would be equivalent in the MIDI system.

The easiest way to use spelled pitches and intervals is
to use the string macros `i` (for intervals) and `p` (for pitches),
which parse a string in a standard notation
that corresponds to how spelled pitches and intervals are printed.
For parsing these representations programmatically,
use `parsespelled` and `parsespelledpitch` for intervals and pitches, respectively.
Spelled pitch classes are represented by an uppercase letter followed by zero or more accidentals,
which can be either written as `b/#` or as `♭/♯`.
Spelled pitches take an additional octave number after the letter and the accidentals.

```julia-repl
julia> p"Eb"
E♭

julia> parsespelledpitch("Eb")
E♭

julia> typeof(p"Eb")
Pitch{SpelledIC}

julia> p"Eb4"
E♭4

julia> typeof(p"Eb4")
Pitch{SpelledInterval}
```

Spelled interval classes consist of one or more letters that indicate the quality of the interval
and a number between 1 and 7 that indicates the generic interval,
e.g. `P1` for a perfect unison, `m3` for a minor 3rd or `aa4` for a double augmented 4th.

|letter|quality                  |
|:-----|:------------------------|
|dd... |diminished multiple times|
|d     |diminished               |
|m     |minor                    |
|P     |perfect                  |
|M     |major                    |
|a     |augmented                |
|aa... |augmented multiple times |

Spelled intervals have the same elements as intervals but additionally take a number of octaves,
written a suffix `+n`, e.g. `P1+0` or `m3+20`.
By default, intervals are directed upwards. Downwards intervals are indicated by a negative sign,
e.g. `-M2+1` (a major 9th down).
For interval classes, downward and upward intervals cannot be distinguish,
so a downward interval is represented by its complementary upward interval:

```julia-repl
julia> i"-M3"
m6

julia> -i"M3"
m6
```

### MIDI Pitch

MIDI pitches and intervals are specified in 12-TET semitones, with 60 as Middle C.
Both MIDI pitches and intervals can be represented by integers.
However, we provides lightweight wrapper types around `Int` to distinguish
the different interpretations as pitches and intervals (and their respective class variants).
Midi pitches can be easily created using the `midi*` constructors, all of which take integers.

|constructor |type                 |printed representation|
|:-----------|:--------------------|:---------------------|
|`midi(15)`  |`MidiInterval`       |`i15`                 |
|`midic(15)` |`MidiIC`             |`ic3`                 |
|`midip(60)` |`Pitch{MidiInterval}`|`p60`                 |
|`midipc(60)`|`Pitch{MidiIC}`      |`pc0`                 |

For quick experiments on the REPL, using these constructors every time can be cumbersome.
For those cases, we provide a set of macros with the same names at the constructors
that turn all integer literals in the subsequent expression
into the respective pitch or interval type.
You can use parentheses to limit the scope of the macros.

```julia-repl
julia> @midi [1,2,3], [2,3,4]
(MidiInterval[i1, i2, i3], MidiInterval[i2, i3, i4])

julia> @midi([1,2,3]), [2,3,4]
(MidiInterval[i1, i2, i3], [2, 3, 4])

julia> (@midi [1,2,3]), [2,3,4]
(MidiInterval[i1, i2, i3], [2, 3, 4])
```

### Frequencies and Ratios

Pitches and intervals can also be expressed
as physical frequencies and freqency ratios, respectively.
We provide wrappers around `Float64` that represent log frequencies and log freqency ratios,
and perform arithmetic with and without octave equivalence.
There are two versions of each constructor depending on whether you provide log or non-log values.
All values are printed as non-log.
Pitch and interval classes are printed in brackets to indicate that they are representatives of an equivalence class.

```julia-repl
julia> freqi(3/2)
fr1.5

julia> logfreqi(log(3/2))
fr1.5

julia> freqic(3/2)
fr[1.5]

julia> freqp(441)
441.0Hz

julia> freqpc(441)
[1.7226562500000004]Hz
```

Because of the use of floats, rounding errors can occur:

```julia-repl
julia> freqp(440)
439.99999999999983Hz
```

You can use Julia's builtin method `isapprox`/`≈` to test for approximate equality:

```julia-repl
julia> freqp(220) + freqi(2) ≈ freqp(440)
true
```
