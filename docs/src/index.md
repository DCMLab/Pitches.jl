# Pitches.jl

```@meta
CurrentModule = Pitches
```

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
