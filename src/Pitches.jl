module Pitches

import Base: show, +, -, *, convert, zero, isless, isequal, isapprox

export Interval, IntervalClass, Pitch
export octave, unison, ic, isstep, chromsemi, embed
export intervaltype, intervalclasstype
export topitch, tointerval, pc


# Pitch: basic Types and Interfaces
# =================================

"""
   abstract type Interval end 

Any interval type should be a subtype of `Interval`.
Intervals should implement the following operations as far as possible:
- `ic`
- `octave(T)`
- `isstep`
- `chromsemi(T)`
- `intervalclasstype(T)`
- `Base.+`
- `Base.-` (negation and substraction)
- `Base.*` (with integers, both sides)
- `Base.zero(T)`
- `Base.sign`
Where `(T)` marks operations on the type itself.
"""
abstract type Interval end

"""
    abstract type IntervalClass <: Interval end

Any interval class type should be a subtype of `IntervalClass`.
In addition to the methods on intervals, interval classes should implement:
- `embed`
- `intervaltype(T)`
`intervalclasstype(T)` and `ic` should be identities.
"""
abstract type IntervalClass <: Interval end

# interfaces
# ----------

"""
    unison(T)

Returns the interval of a unison for interval type `T`.
Alias for `Base.zero`.
New interval types should implement `Base.zero`,
but user code should call `unison` for better interpretability.
"""
const unison = Base.zero

"""
    octave(T, [n=1])

Returns the interval corresponding to an octave for interval type `T`.
For interval classes, this should return `zero(T)`
(a default method is provided).

If `n` is specified, the octave is multiplied by `n` first.
This is equivalent to `octave(T) * n`.

For convenience, a fallback for `octave(p::T, [n])` is provided.
Only `octave(T)` needs to be implemented.
"""
function octave end
octave(T::Type{PC}) where {PC<:IntervalClass} = zero(T)
octave(T, n::Int) = octave(T) * n
octave(p::Interval) = octave(typeof(p))

"""
    ic(i)

Returns the interval class of an interval, removing the octave
"""
function ic end

"""
    embed(ic, [oct=0])
    embed(pc, [oct=0])

Converts an interval class to an interval in the canonical octave,
adding `oct` octaves, if supplied.
Also works for pitches.
"""
function embed end
embed(ic, oct) = embed(ic) + octave(intervaltype(typeof(ic)), oct)

"""
    intervaltype(IC::Type)

Returns for an interval class type `IC` the corresponding interval type.
For convenience, `intervaltype(ic::IC)` is also provided.
"""
function intervaltype end
intervaltype(::Any) = nothing
intervaltype(::IC) where {IC<:IntervalClass} = intervaltype(IC)

"""
    intervalclasstype(I::Type)

Returns for an interval type `I` the corresponding interval class type.
For convenience, `intervalclasstype(p::P)` is also provided.
"""
function intervalclasstype end
intervalclasstype(::Any) = nothing
intervalclasstype(::I) where {I<:Interval} = intervalclasstype(I)

"""
    isstep(p)

For diatonic intervals, indicates whether `p` is a step.
"""
function isstep end

"""
    chromsemi(I::Type)

Returns a chromatic semitone of type `I`.
"""
function chromsemi end

# pitches
# =======

"""
    Pitch{I}

Represents a pitch for the interval type `I`.
The interval is interpreted as an absolute pitch
by assuming a reference pitch.
The reference pitch is type dependent and known from context.
"""
struct Pitch{I<:Interval}
    pitch :: I
end

topitch(i::I) where {I<:Interval} = Pitch(i)

tointerval(p::Pitch{I}) where {I<:Interval} = p.pitch

+(p::Pitch{I}, i::I) where {I<:Interval} = Pitch(p.pitch + i)
+(i::I, p::Pitch{I}) where {I<:Interval} = Pitch(p.pitch + i)
-(p::Pitch{I}, i::I) where {I<:Interval} = Pitch(p.pitch - i)
-(p1::Pitch{I}, p2::Pitch{I}) where {I<:Interval} = p1.pitch - p2.pitch

"""
    pc(p)

Return the pitch class that corresponds to `p`.
"""
pc(p::Pitch{I}) where {I<:Interval} = Pitch(ic(p.pitch))
embed(p::Pitch{I}, octs::Int=0) where {I<:Interval} = Pitch(embed(p.pitch, octs))

Base.isequal(p1::Pitch{I}, p2::Pitch{I}) where {I<:Interval} = p1.pitch == p2.pitch
Base.isapprox(p1::Pitch, p2::Pitch; kwargs...) =
    Base.isapprox(p1.pitch, p2.pitch; kwargs...)
Base.isless(p1::Pitch{I}, p2::Pitch{I}) where {I<:Interval} = p1.pitch < p2.pitch
Base.hash(p::Pitch, x::UInt) = hash(p.pitch, x)

# specific interval types
# =======================

include("pitches/midi.jl")
include("pitches/spelled.jl")
include("pitches/logfreq.jl")

end # module
