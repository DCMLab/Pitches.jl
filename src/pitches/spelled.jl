export SpelledInterval, spelled, spelledp
export SpelledIC, sic, spc
export octaves, internalocts, fifths
export degree, generic, diasteps, alteration, letter
export parsespelled, parsespelledpitch, @i_str, @p_str

import Base: +, -, *, ==

# helpers

const perfectints = Set{Int}([0,3,4])
accstr(n, u, d) =
    if n > 0; repeat(u,n) elseif n < 0; repeat(d,-n) else "" end
qualpf(n, a, p, d) =
    if n > 0; repeat(a,n) elseif n < 0; repeat(d,-n) else p end
qualimpf(n, a, mj, mn, d) =
    if n > 0; repeat(a,n) elseif n < -1; repeat(d,-n-1) elseif n == -1; mn else mj end

# common functions (special interface)

"""
    degree(i)
    degree(p)

Return the "relative scale degree" (0-6) to which the interval points
(unison=`0`, 2nd=`1`, octave=`0`, 2nd down=`6`, etc.).
For pitches, return the integer that corresponds to the letter (C=`0`, D=`1`, ...).

See also: [`generic`](@ref), [`diasteps`](@ref), [`letter`](@ref)
"""
function degree end
degree(fifths::Int) = mod(fifths*4,7)
degree(p::Pitch) = degree(p.pitch)

"""
    generic(i)

Return the generic interval, i.e. the number of diatonic steps modulo octave.
Unlike [`degree`](@ref), the result respects the sign of the interval
(unison=`0`, 2nd up=`1`, 2nd down=`-1`).
For pitches, use [`degree`](@ref).

See also: [`degree`](@ref), [`diasteps`](@ref)
"""
function generic end

"""
    letter(p)

Returns the letter of a pitch as a character.

See also: [`degree`](@ref).
"""
letter(p::Pitch) = 'A' + mod(degree(p)+2, 7)

"""
    diasteps(i)

Return the diatonic steps of the interval (unison=`0`, 2nd=`1`, ..., octave=`7`).
Respects both direction and octaves.

See also [`degree`](@ref) and [`generic`](@ref).
"""
function diasteps end

"""
    alteration(i)
    alteration(p)

Return the number of semitones by which the interval is altered from its the perfect or major variant.
Positive alteration always indicates augmentation,
negative alteration indicates diminution (minor or smaller) of the interval.
For pitches, return the accidentals (positive=sharps, negative=flats, `0`=natural).
"""
function alteration end
alteration(p::Pitch) = alteration(ic(p.pitch))

"""
    octaves(i)
    octaves(p)

Return the number of octaves the interval spans.
Positive intervals start at 0 octaves, increasing.
Negative intervals start at -1 octaves, decreasing.
(You might want to use `octaves(abs(i))` instead).

For a pitch, return its octave.
"""
function octaves end
octaves(p::Pitch) = octaves(p.pitch)

"""
    internalocts(i)

Return the internal octaves (i.e. dependent on the 5ths dimension) of an interval.
"""
function internalocts end

"""
    fifths(i)
    fifths(p)

Return the octave-invariant part of the interval in fifths
(unison=`0`, 5th up=`1`, 4th up/5th down=`-1`).
For a pitch, return the pitch class on the line of fifths.
"""
function fifths end
fifths(p::Pitch) = fifths(p.pitch)

# spelled interval
# ----------------

"""
    SpelledInterval <: Interval

Spelled intervals represented as pairs of fifths and octaves.
E.g., `SpelledInterval(-3, 2)` represents a minor 3rd upwards
(3 fifths down, 2 octaves up).
"""
struct SpelledInterval <: Interval
    fifths :: Int
    octaves :: Int
end

"""
    spelled(fifths, octaves)

Creates a spelled interval from `fifths` and `octaves`.
"""
spelled(f, o) = SpelledInterval(f, o)

"""
    spelledp(fifths, octaves)

Creates a spelled pitch from `fifths` and `octaves`.
"""
spelledp(f, o) = Pitch(spelled(f, o))

# accessors

degree(i::SpelledInterval) = degree(i.fifths)
generic(i::SpelledInterval) = if sign(i) < 0; -degree(-i.fifths) else degree(i.fifths) end
diasteps(i::SpelledInterval) = i.fifths*4 + i.octaves*7
alteration(i::SpelledInterval) = let absi = abs(i); fld(absi.fifths+1, 7) end
octaves(i::SpelledInterval) = i.octaves + fld(i.fifths*4, 7)
internalocts(i::SpelledInterval) = i.octaves
fifths(i::SpelledInterval) = i.fifths

# general interface

function Base.show(io::IO, i::SpelledInterval) 
   # negative? print as -abs(i)
    if sign(i) == -1
        print(io, "-")
        print(io, abs(i))
        return
    end

    dia = degree(i)
    diff = alteration(i) # interval is always positive, so direction is correct
    qual = if dia ∈ perfectints
        qualpf(diff, 'a', 'P', 'd')
    else
        qualimpf(diff, 'a', 'M', 'm', 'd')
    end

    octs = octaves(i)

    print(io, qual * string(dia+1) * ':' * string(octs))
end

function Base.show(io::IO, p::Pitch{SpelledInterval})
    i = p.pitch
    dia = degree(i)
    alter = alteration(i)
    print(io, string('A' + mod(dia + 2, 7), accstr(alter, '♯', '♭'), string(octaves(i))))
end

Base.isless(i1::SpelledInterval, i2::SpelledInterval) =
    (diasteps(i1), alteration(i1)) <
    (diasteps(i2), alteration(i2))

Base.isequal(i1::SpelledInterval, i2::SpelledInterval) =
    i1.octaves == i2.octaves && i1.fifths == i2.fifths

Base.hash(i::SpelledInterval, x::UInt) = hash(i.octaves, hash(i.fifths, x))

+(i1::SpelledInterval, i2::SpelledInterval) =
    spelled(i1.fifths + i2.fifths, i1.octaves + i2.octaves)
-(i1::SpelledInterval, i2::SpelledInterval) =
    spelled(i1.fifths - i2.fifths, i1.octaves - i2.octaves)
-(i::SpelledInterval) = spelled(-i.fifths, -i.octaves)
Base.zero(::Type{SpelledInterval}) = spelled(0,0)
Base.zero(::SpelledInterval) = spelled(0,0)
*(i::SpelledInterval, n::Integer) = spelled(i.fifths*n, i.octaves*n)
*(n::Integer,i::SpelledInterval) = spelled(i.fifths*n, i.octaves*n)

octave(::Type{SpelledInterval}) = spelled(0,1)

Base.sign(i::SpelledInterval) = sign(diasteps(i))
Base.abs(i::SpelledInterval) = if sign(i) < 0; -i else i end

ic(i::SpelledInterval) = sic(i.fifths)
embed(i::SpelledInterval) = i
intervaltype(::Type{SpelledInterval}) = SpelledInterval
intervalclasstype(::Type{SpelledInterval}) = SpelledIC

isstep(i::SpelledInterval) = abs(diasteps(i)) <= 1
chromsemi(::Type{SpelledInterval}) = spelled(7,-4)

# conversion

tomidi(i::SpelledInterval) = midi(7*i.fifths + 12*i.octaves)
tomidi(p::Pitch{SpelledInterval}) = Pitch(tomidi(p.pitch) + midi(12))  # C4 = 48 semitones above C0 = midi(60)

# spelled interval class
# ----------------------

"""
    SpelledIC <: IntervalClass

Spelled interval class represented on the line of 5ths with `0 = C`.
E.g., `SpelledIC(3)` represents a major 6th upwards or minor 3rd downwards
(i.e., three 5ths up modulo octave).
"""
struct SpelledIC <: IntervalClass
    fifths :: Int
end

"""
    sic(fifths)

Creates a spelled interval class going `fifths` 5ths upwards.
"""
sic(fs) = SpelledIC(fs)

"""
    spc(fifths)

Creates a spelled pitch class.
In analogy to `sic`, this function takes a number of 5ths.
"""
spc(fs) = Pitch(sic(fs))

# accessors

degree(i::SpelledIC) = degree(i.fifths)
generic(i::SpelledIC) = degree(i.fifths)
diasteps(i::SpelledIC) = degree(i.fifths)
alteration(i::SpelledIC) = fld(i.fifths + 1, 7)
octaves(i::SpelledIC) = 0
internalocts(i::SpelledIC) = 0
fifths(i::SpelledIC) = i.fifths

# interface functions

function Base.show(io::IO, ic::SpelledIC)
    dia = degree(ic)
    diff = alteration(ic)
    qual = if dia ∈ perfectints
        qualpf(diff, 'a', 'P', 'd')
    else
        qualimpf(diff, 'a', 'M', 'm', 'd')
    end
    
    print(io, qual * string(dia+1))
end

function Base.show(io::IO, p::Pitch{SpelledIC})
    i = p.pitch
    dia = degree(i)
    alter = alteration(i)
    print(io, ('A' + mod(dia+2, 7)) * accstr(alter, '♯', '♭'))
end

Base.isless(i1::SpelledIC, i2::SpelledIC) = isless(i1.fifths,i2.fifths)
Base.isequal(i1::SpelledIC, i2::SpelledIC) = isequal(i1.fifths,i2.fifths)
Base.hash(i::SpelledIC, x::UInt) = hash(i.fifths, x)

+(i1::SpelledIC, i2::SpelledIC) = sic(i1.fifths + i2.fifths)
-(i1::SpelledIC, i2::SpelledIC) = sic(i1.fifths - i2.fifths)
-(i::SpelledIC) = sic(-i.fifths)
Base.zero(::Type{SpelledIC}) = sic(0)
Base.zero(::SpelledIC) = sic(0)
*(i::SpelledIC, n::Integer) = sic(i.fifths * n)
*(n::Integer,i::SpelledIC) = sic(i.fifths * n)

octave(::Type{SpelledIC}) = sic(0)
function Base.sign(i::SpelledIC)
    dia = degree(i)
    if dia == 0; 0 elseif dia > 3; -1 else 1 end
end
Base.abs(i::SpelledIC) = if sign(i) < 0; -i else i end

ic(i::SpelledIC) = i
embed(i::SpelledIC) = spelled(i.fifths, -fld(i.fifths*4, 7))
intervaltype(::Type{SpelledIC}) = SpelledInterval
intervalclasstype(::Type{SpelledIC}) = SpelledIC

isstep(i::SpelledIC) = degree(i) ∈ [0,1,6]
chromsemi(::Type{SpelledIC}) = sic(7)

# conversion

tomidi(i::SpelledIC) = midic(i.fifths * 7)
tomidi(p::Pitch{SpelledIC}) = midipc(p.pitch.fifths * 7)

# parsing
# -------

const rgsic = r"^(-?)(a+|d+|[MPm])([1-7])$"
const rgspelled = r"^(-?)(a+|d+|[MPm])([1-7]):(-?)(\d+)$"

function matchinterval(modifier, num)
    dia = parse(Int, num) - 1
    perfect = dia ∈ perfectints

    alt = if modifier == "M" && !perfect
        0
    elseif modifier == "m" && !perfect
        -1
    elseif lowercase(modifier) == "p" && perfect
        0
    elseif occursin(r"^a+$", modifier)
        length(modifier)
    elseif occursin(r"^d+$", modifier)
        -length(modifier) - (perfect ? 0 : 1)
    else
        error("cannot parse interval \"$modifier$num\"")
    end

    mod(dia*2+1, 7) - 1 + 7*alt
end

"""
    parsespelled(str)

Parse a spelled interval or interval class string.
The type is determined from the string,
so `i"M3:0"` returns an interval while `i"M3"` returns an interval class.

See also: [`@i_str`](@ref), [`parsespelledpitch`](@ref).
"""
function parsespelled(str)
    m = match(rgsic, str)
    if m != nothing
        int = sic(matchinterval(m[2], m[3]))
    else
        m = match(rgspelled, str)
        if m != nothing
            fifths = matchinterval(m[2], m[3])
            octs = parse(Int, m[4]*m[5])
            int = spelled(fifths, octs - fld(fifths*4, 7))
        else
            error("cannot parse interval \"$str\"")
        end
    end

    # invert if necessary
    if m[1] == "-"
        -int
    else
        int
    end
end

"""
    i"str"

Parse a spelled interval or interval class string.
The type is determined from the string,
so `i"M3:0"` returns an interval while `i"M3"` returns an interval class.

See also: [`@p_str`](@ref), [`parsespelled`](@ref), [`parsespelledpitch`](@ref).
"""
macro i_str(str)
    parsespelled(str)
end

const rgspelledpc = r"^([a-g])(♭+|♯+|b+|#+)?$"i
const rgspelledp = r"^([a-g])(♭+|♯+|b+|#+)?(-?\d+)$"i

function matchpitch(letter, accs)
    letter = uppercase(letter)[1]
    if letter >= 'A' && letter <= 'G'
        dia = mod(letter - 'A' - 2, 7)
    else
        error("cannot parse pitch letter \"$letter\"")
    end
    
    alt = if accs == nothing || accs == ""
        0
    elseif occursin(r"^♭+|b+$"i, accs)
        -length(accs)
    elseif occursin(r"^♯+|#+$"i, accs)
        length(accs)
    else
        error("cannot parse accidentals \"$accs\"")
    end

    mod(dia*2 + 1, 7) - 1 + 7*alt
end

"""
    parsespelledpitch(str)

Parse a spelled pitch or pitch class string.
The type is determined from the string,
so `p"G4"` returns a pitch while `p"G"` returns a pitch class.

See also: [`@p_str`](@ref), [`parsespelled`](@ref).
"""
function parsespelledpitch(str)
    m = match(rgspelledpc, str)
    if m != nothing
        spc(matchpitch(m[1], m[2]))
    else
        m = match(rgspelledp, str)
        if m != nothing
            octs = parse(Int, m[3])
            fifths = matchpitch(m[1], m[2])
            spelledp(fifths, octs - fld(fifths*4, 7))
        else
            error("cannot parse pitch \"$str\"")
        end
    end
end

"""
    p"str"

Parse a spelled pitch or pitch class string.
The type is determined from the string,
so `p"G4"` returns a pitch while `p"G"` returns a pitch class.

See also: [`@i_str`](@ref), [`parsespelledpitch`](@ref), [`parsespelled`](@ref).
"""
macro p_str(str)
    parsespelledpitch(str)
end
