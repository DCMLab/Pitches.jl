# Spelled Pitch

## Overview

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

## Details about the Representation

Internally, spelled intervals are represented by two dimentions, fifths and octaves.
The dimention of fifths is interpreted in an octave-equivalent fashion
and represents an upwards interval within an octave.
For example `1` is a fifth upwards, `2` is a major 2nd upwards, and `-3` is a minor 3rd upwards.
This corresponds to the "line-of-fifths" representation of interval classes.

The octave dimension is orthogonal to the fifths:
When the octave is 0, the interval is upward within one octave;
when the the octave is not 0, the corresponding number of octaves is added to the interval.
In particular, negative intervals are expressed using negative octaves.
For example, a m3 down is equivalent to an octave down + a M6 up,
so the internal representation of `-m3` is `M6-1`,
or `fifths=3, octaves=-1`.
Fifths and octaves can be accessed using the functions [`fifths`](@ref) and [`octaves`](@ref), respectively.

In addition to the line-of-fifths representation,
it can be useful to think about the interval
in terms of diatonic steps (the "generic interval") and alterations.
The function [`diasteps`](@ref) returns the diatonic steps of an interval (class)
within an octave, i.e, `0` for any unison (and any multiple of an octave), `1` for any 2nd, `2` for any 3rd, etc.
If you need the total number of diatonic taken by the interval, use `diasteps(i) + 7*octaves(i)`.
Since diasteps only considers the fifths dimension, negative intervals return the complementary number of steps!

The function [`alteration`](@ref) returns the deviation of the interval class
from its major or perfect version in chromatic semitones,
e.g. `1` for augmented, `-1` for minor imperfect and diminished perfect,
and `-2` for diminished imperfect (or double-diminished perfect) intervals.
Note that for negative intervals the returned value refers to the complementary interval class!

Since both [`diasteps`](@ref) and [`alteration`](@ref)
behave somewhat unituitively for negative intervals,
it can be useful to apply them to the positive interval obtained with `abs` instead.

Both functions also work on spelled pitches,
where they return the name (C=`0`, D=`1`, ...) and the accidentals (positive = sharps).

## Reference

### Types

```@docs
SpelledInterval
SpelledIC
```

### Constructors

```@docs
spelled
spelledp
sic
spc
@i_str
@p_str
parsespelled
parsespelledpitch
```

### Other Special Functions

Internally, spelled intervals are represented as an interval class on the line of fifths
plus an octave offset.
These two parts can be accessed separately.
The interval class part can also be converted into diatonic steps (i.e. the generic interval)
and the alteration (i.e. the specific variant) relative to the major or perfect version of the interval.

```@docs
octaves
fifths
diasteps
alteration
```
