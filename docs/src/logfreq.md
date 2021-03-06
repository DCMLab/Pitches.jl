# Frequencies and Ratios

## Overview

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

## Reference

### Types

```@docs
FreqInterval
FreqIC
```

### Constructors

| octave equivalent | takes log | interval            | pitch               |
|:------------------|:----------|:--------------------|:--------------------|
| no                | no        | [`freqi`](@ref)     | [`freqp`](@ref)     |
|                   | yes       | [`logfreqi`](@ref)  | [`logfreqp`](@ref)  |
| yes               | no        | [`freqic`](@ref)    | [`freqpc`](@ref)    |
|                   | yes       | [`logfreqic`](@ref) | [`logfreqpc`](@ref) |

```@docs
freqi
freqic
freqp
freqpc
logfreqi
logfreqp
logfreqic
logfreqpc
```
