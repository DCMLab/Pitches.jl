# MIDI Pitch

## Overview

MIDI pitches and intervals are specified in 12-TET semitones, with 60 as Middle C.
Both MIDI pitches and intervals can be represented by integers.
However, we provides lightweight wrapper types around `Int` to distinguish
the different interpretations as pitches and intervals (and their respective class variants).
Midi pitches can be easily created using the `midi*` constructors, all of which take integers.

| constructor example  | type                  | printed representation |
|:---------------------|:----------------------|:-----------------------|
| [`midi(15)`](@ref)   | `MidiInterval`        | `i15`                  |
| [`midic(15)`](@ref)  | `MidiIC`              | `ic3`                  |
| [`midip(60)`](@ref)  | `Pitch{MidiInterval}` | `p60`                  |
| [`midipc(60)`](@ref) | `Pitch{MidiIC}`       | `pc0`                  |

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

## Reference

### Types

```@docs
MidiInterval
MidiIC
```

### Constructors

```@docs
midi
midic
midip
midipc
@midi
@midic
@midip
@midipc
```

### Conversion

```@docs
tomidi
```
