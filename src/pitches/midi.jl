# midi intervals and classes
# ==========================

export MidiInterval, midi, midis, @midi, midip, midips, @midip
export MidiIC, midic, midics, @midic, midipc, midipcs, @midipc
export tomidi

# special interface

"""
    tomidi(i [, ...])
    tomidi(p [, ...])

Converts a pitch or interval to the corresponding midi type.
Depending on the input type, this might require additional parameters.
"""
function tomidi end

# types

"""
    MidiInterval <: Interval

Intervals represented as chromatic integers.
`60` is Middle C.
"""
struct MidiInterval <: Interval
    interval :: Int
end

"""
    MidiIC <: IntervalClass

Interval classes represented as cromatic integers in Z_12, where `0` is C.
"""
struct MidiIC <: IntervalClass
    ic :: Int
    MidiIC(ic) = new(mod(ic,12))
end

# constructors

"""
    midi(interval)

Creates a `MidiInterval` from an integer.
"""
midi(interval::Int) = MidiInterval(interval)

"""
    midip(n)

Creates a midi pitch (`Pitch{MidiInterval}`) from an integer.
"""
midip(n::Int) = Pitch(midi(n))

"""
    midic(interval)

Creates a `MidiIC` from an integer.
"""
midic(interval::Int) = MidiIC(interval)

"""
    midipc(n)

Creates a midi pitch class (`Pitch{MidiIC}`) from an integer.
"""
midipc(n::Int) = Pitch(midic(n))

# constructor macros

"""
    @midi expr

Replaces all `Int`s in `expr` with a call to `midi(::Int)`.
This allows the user to write integers where midi intervals are required.
Does not work when `expr` contains integers that should not be converted
or intervals that are not written as literal integers.
"""
macro midi(expr)
    mkmidi(x) = x
    mkmidi(e::Expr) = Expr(e.head, map(mkmidi, e.args)...)
    mkmidi(n::Int) = :(Pitches.midi($n))

    return esc(mkmidi(expr))
end

"""
    @midic expr

Replaces all `Int`s in `expr` with a call to `midi(::Int)`.
This allows the user to write integers where midi intervals are required.
Does not work when `expr` contains integers that should not be converted
or intervals that are not written as literal integers.
"""
macro midic(expr)
    mkmidi(x) = x
    mkmidi(e::Expr) = Expr(e.head, map(mkmidi, e.args)...)
    mkmidi(n::Int) = :(Pitches.midic($n))

    return esc(mkmidi(expr))
end

"""
    @midip expr

Replaces all `Int`s in `expr` with a call to `midip(::Int)`.
This allows the user to write integers where midi intervals are required.
Does not work when `expr` contains integers that should not be converted
or intervals that are not written as literal integers.
"""
macro midip(expr)
    mkmidi(x) = x
    mkmidi(e::Expr) = Expr(e.head, map(mkmidi, e.args)...)
    mkmidi(n::Int) = :(Pitches.midip($n))

    return esc(mkmidi(expr))
end

"""
    @midipc expr

Replaces all `Int`s in `expr` with a call to `midipc(::Int)`.
This allows the user to write integers where midi intervals are required.
Does not work when `expr` contains integers that should not be converted
or intervals that are not written as literal integers.
"""
macro midipc(expr)
    mkmidi(x) = x
    mkmidi(e::Expr) = Expr(e.head, map(mkmidi, e.args)...)
    mkmidi(n::Int) = :(Pitches.midipc($n))

    return esc(mkmidi(expr))
end

# Base interface

show(io::IO, p::MidiInterval) = print(io, string("i", p.interval))
show(io::IO, p::MidiIC) = print(io, string("ic", p.ic))
show(io::IO, p::Pitch{MidiInterval}) = print(io, string("p", p.pitch.interval))
show(io::IO, p::Pitch{MidiIC}) = print(io, string("pc", p.pitch.ic))

Base.isless(p1::MidiInterval, p2::MidiInterval) = isless(p1.interval, p2.interval)
Base.isless(p1::MidiIC, p2::MidiIC) = isless(p1.ic, p2.ic)

Base.isequal(p1::MidiInterval, p2::MidiInterval) = p1.interval == p2.interval
Base.isequal(p1::MidiIC, p2::MidiIC) = p1.ic == p2.ic

Base.hash(p::MidiInterval, x::UInt) = hash(p.interval, x)
Base.hash(p::MidiIC, x::UInt) = hash(p.ic, x)

Base.Int64(p::MidiInterval) = p.interval
Base.Int64(p::MidiIC) = p.ic
Base.Int64(p::Pitch{MidiInterval}) = p.pitch.interval
Base.Int64(p::Pitch{MidiIC}) = p.pitch.ic

# conversion

convert(::Type{MidiInterval}, x::N) where {N<:Number} = midi(convert(Int, x))
convert(::Type{Interval}, x::N) where {N<:Number} = midi(convert(Int, x))
convert(::Type{Int}, p::MidiInterval) = p.interval
convert(::Type{N}, p::MidiInterval) where {N<:Number} = convert(N, p.interval)

convert(::Type{MidiIC}, x::N) where {N<:Number} = midic(convert(Int, x))
convert(::Type{IntervalClass}, x::N) where {N<:Number} = midic(convert(Int, x))
convert(::Type{Int}, p::MidiIC) = p.ic
convert(::Type{N}, p::MidiIC) where {N<:Number} = convert(N, p.ic)

## tomidi (identities)
tomidi(i::MidiInterval) = i
tomidi(i::MidiIC) = i
tomidi(p::Pitch{MidiInterval}) = p
tomidi(p::Pitch{MidiIC}) = p

# interval interface (midi interval)

+(p1::MidiInterval, p2::MidiInterval) = midi(p1.interval + p2.interval)
-(p1::MidiInterval, p2::MidiInterval) = midi(p1.interval - p2.interval)
-(p::MidiInterval) = midi(-p.interval)
zero(::Type{MidiInterval}) = midi(0)
zero(::MidiInterval) = midi(0)

*(p::MidiInterval, n::Integer) = midi(p.interval*n)
*(n::Integer, p::MidiInterval) = midi(p.interval*n)

octave(::Type{MidiInterval}) = midi(12)
Base.sign(p::MidiInterval) = sign(p.interval)
Base.abs(p::MidiInterval) = midi(abs(p.interval))

ic(p::MidiInterval) = midic(p.interval)
embed(p::MidiInterval) = p
intervaltype(::Type{MidiInterval}) = MidiInterval
intervalclasstype(::Type{MidiInterval}) = MidiIC

isstep(p::MidiInterval) = abs(p.interval) <= 2 
chromsemi(::Type{MidiInterval}) = midi(1)

# interval interface (midi interval class)

+(p1::MidiIC, p2::MidiIC) = midic(p1.ic + p2.ic)
-(p1::MidiIC, p2::MidiIC) = midic(p1.ic - p2.ic)
-(p::MidiIC) = midic(-p.ic)
zero(::Type{MidiIC}) = midic(0)
zero(::MidiIC) = midic(0)

*(p::MidiIC, n::Integer) = midic(p.ic*n)
*(n::Integer, p::MidiIC) = midic(p.ic*n)

octave(::Type{MidiIC}) = midic(0)
Base.sign(p::MidiIC) = p.ic == 0 ? 0 : -sign(p.ic-6)
Base.abs(p::MidiIC) = midic(abs(mod(p.ic + 6, 12) - 6))

ic(p::MidiIC) = p
embed(p::MidiIC) = midi(p.ic)
intervaltype(::Type{MidiIC}) = MidiInterval
intervalclasstype(::Type{MidiIC}) = MidiIC

isstep(p::MidiIC) = p.ic <= 2 || p.ic >= 10
chromsemi(::Type{MidiIC}) = midic(1)
