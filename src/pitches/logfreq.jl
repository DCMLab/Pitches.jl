export FreqInterval, logfreqi, logfreqp, freqi, freqp 
export FreqIC, logfreqic, logfreqpc, freqic, freqpc

import Base: +, -, *, ==

# some helper constants
const oct = log(2)
const halfoct = oct/2

# FreqInterval
# ============    

"""
    FreqInterval <: Interval

A frequency ratio interval.
Is internally represented by the logarithm of the frequency ratio,
so conversion to Float64 will return a log-frequency ratio!
"""
struct FreqInterval <: Interval
    lfr :: Float64
end

# constructors

"""
    logfreqi(logratio)

Creates a frequency ratio interval from a log-ratio.
"""
logfreqi(lfr) = FreqInterval(lfr)

"""
    logfreqp(logfrequency)

Creates a frequency pitch from a log-frequency.
"""
logfreqp(lf) = Pitch(FreqInterval(lf))

"""
    freqi(ratio)

Creates a frequency ratio interval from a frequency ratio.
"""
freqi(ratio) = FreqInterval(log(ratio))

"""
    freqp(frequency)

Creates a frequency pitch from a frequency.
"""
freqp(freq) = Pitch(FreqInterval(log(freq)))

# Base interface

Base.show(io::IO, i::FreqInterval) = print(io, string("fr", exp(i.lfr)))
Base.show(io::IO, p::Pitch{FreqInterval}) = print(io, string(exp(p.pitch.lfr), "Hz"))

Base.isless(i1::FreqInterval, i2::FreqInterval) =
    i1.lfr < i2.lfr

Base.isequal(i1::FreqInterval, i2::FreqInterval) =
    i1.lfr == i2.lfr

Base.isapprox(a::FreqInterval, b::FreqInterval; kwargs...) =
    Base.isapprox(a.lfr, b.lfr; kwargs...)

Base.hash(i::FreqInterval, x::UInt64) = hash(i.lfr, x)

Base.Float64(i::FreqInterval) = i.lfr
Base.Float64(p::Pitch{FreqInterval}) = p.pitch.lfr

convert(::Type{FreqInterval}, x::N) where {N<:Real} = logfreqi(Float64(x))
convert(::Type{N}, i::FreqInterval) where {N<:Real} = convert(N, i.lfr)
# TODO: conversion to other pitch types, in particular tomidi

# interval interface

+(i1::FreqInterval, i2::FreqInterval) = logfreqi(i1.lfr + i2.lfr)
-(i1::FreqInterval, i2::FreqInterval) = logfreqi(i1.lfr - i2.lfr)
-(i::FreqInterval) = logfreqi(-i.lfr)

*(i::FreqInterval, n::Integer) = logfreqi(n*i.lfr)
*(n::Integer, i::FreqInterval) = logfreqi(n*i.lfr)

Base.sign(i::FreqInterval) = sign(i.lfr)
Base.abs(i::FreqInterval) = logfreqi(abs(i.lfr))

Base.zero(::Type{FreqInterval}) = logfreqi(0.)
Base.zero(::FreqInterval) = logfreqi(0.)
octave(::Type{FreqInterval}) = logfreqi(oct)
chromsemi(::Type{FreqInterval}) = logfreqi(oct/12)
# isstep is left unimplemented

ic(i::FreqInterval) = logfreqic(i.lfr)
embed(i::FreqInterval) = i
intervaltype(::Type{FreqInterval}) = FreqInterval
intervalclasstype(::Type{FreqInterval}) = FreqIC

# FreqIC
# ======

"""
    FreqIC <: Interval

A frequency ratio interval class.
Is internally represented by the logarithm of the frequency ratio,
so conversion to Float64 will return a log-frequency ratio!
Maintains octave equivalence.
"""
struct FreqIC <: IntervalClass
    lfr :: Float64
end

# constructors

"""
    logfreqic(logratio)

Creates a frequency ratio interval class from a log-ratio.
"""
logfreqic(lfr) = FreqIC(mod(lfr, oct))

"""
    logfreqpc(logfrequency)

Creates a frequency pitch class from a log-frequency.
"""
logfreqpc(lf) = Pitch(logfreqic(lf))

"""
    freqic(ratio)

Creates a frequency ratio interval class from a frequency ratio.
"""
freqic(ratio) = logfreqic(log(ratio))

"""
    freqpc(frequency)

Creates a frequency pitch class from a frequency.
"""
freqpc(freq) = Pitch(freqic(freq))

# Base interface

Base.show(io::IO, i::FreqIC) = print(io, string("fr[", exp(i.lfr), "]"))
Base.show(io::IO, p::Pitch{FreqIC}) = print(io, string("[", exp(p.pitch.lfr), "]Hz"))

Base.isless(i1::FreqIC, i2::FreqIC) =
    i1.lfr < i2.lfr

Base.isequal(i1::FreqIC, i2::FreqIC) =
    i1.lfr == i2.lfr

Base.isapprox(a::FreqIC, b::FreqIC; kwargs...) =
    Base.isapprox(a.lfr, b.lfr; kwargs...) ||
    Base.isapprox(a.lfr + log(2), b.lfr; kwargs...) ||
    Base.isapprox(a.lfr, b.lfr + log(2); kwargs...)

Base.hash(i::FreqIC, x::UInt64) = hash(i.lfr, x)

Base.Float64(i::FreqIC) = i.lfr
Base.Float64(p::Pitch{FreqIC}) = p.pitch.lfr

convert(::Type{FreqIC}, x::N) where {N<:Real} = logfreqic(Float64(x))
convert(::Type{N}, i::FreqIC) where {N<:Real} = convert(N, i.lfr)
# TODO: conversion to other pitch types, in particular tomidi

# interval interface

+(i1::FreqIC, i2::FreqIC) = logfreqic(i1.lfr + i2.lfr)
-(i1::FreqIC, i2::FreqIC) = logfreqic(i1.lfr - i2.lfr)
-(i::FreqIC) = logfreqic(-i.lfr)

*(i::FreqIC, n::Integer) = logfreqic(n*i.lfr)
*(n::Integer, i::FreqIC) = logfreqic(n*i.lfr)

Base.sign(i::FreqIC) = i.lfr == 0 ? 0 : -sign(i.lfr - halfoct)
Base.abs(i::FreqIC) = logfreqic(abs(mod(i.lfr + halfoct, oct) - halfoct))

Base.zero(::Type{FreqIC}) = logfreqic(0)
Base.zero(::FreqIC) = logfreqic(0)
octave(::Type{FreqIC}) = logfreqic(0)
chromsemi(::Type{FreqIC}) = logfreqic(oct/12)
# isstep is left unimplemented

ic(i::FreqIC) = i
embed(i::FreqIC) = logfreqi(i.lfr)
intervaltype(::Type{FreqIC}) = FreqInterval
intervalclasstype(::Type{FreqIC}) = FreqIC
