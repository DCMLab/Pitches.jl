export SpelledInterval, spelled, spelledp
export SpelledIC, sic, spc
export parsespelled, parsespelledpitch, @i_str, @p_str

import Base: +, -, *, ==

# helpers

#const dianames = String["F","C", "G", "D", "A", "E", "B"]
#const dianames_lookup = Dict(l => i-1 for (i, l) in enumerate(dianames))
const perfectints = Set{Int}([0,3,4])
diasteps(fifths) = mod(fifths*4,7)
chromshift(fifths) = fld(fifths + 1, 7) # like div, but rounds down
accstr(n, u, d) =
    if n > 0; repeat(u,n) elseif n < 0; repeat(d,-n) else "" end
qualpf(n, a, p, d) =
    if n > 0; repeat(a,n) elseif n < 0; repeat(d,-n) else p end
qualimpf(n, a, mj, mn, d) =
    if n > 0; repeat(a,n) elseif n < -1; repeat(d,-n-1) elseif n == -1; mn else mj end

# spelled interval
# ----------------

"""
    SpelledInterval <: Interval

Spelled intervals represented as pairs of (abstract) fifths and octaves.
E.g., `SpelledInterval(-3, 1)` represents a minor decime upwards (-3 fifths, 1 octave).
"""
struct SpelledInterval <: Interval
    fifths :: Int # modulo octaves
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

function Base.show(io::IO, i::SpelledInterval) 
   # negative? print as -abs(i)
    if sign(i) == -1
        print(io, "-")
        print(io, abs(i))
        return
    end

    dia = diasteps(i.fifths)
    diff = chromshift(i.fifths)
    qual = if dia ∈ perfectints
        qualpf(diff, 'a', 'P', 'd')
    else
        qualimpf(diff, 'a', 'M', 'm', 'd')
    end
    
    octstr = if i.octaves >= 0; '+' * string(i.octaves) else string(i.octaves) end

    print(io, qual * string(dia+1) * octstr)
end

function Base.show(io::IO, p::Pitch{SpelledInterval})
    i = p.pitch
    dia = diasteps(i.fifths)
    alter = chromshift(i.fifths)
    print(io, string('A' + mod(dia + 2, 7), accstr(alter, '♯', '♭'), string(i.octaves)))
end

Base.isless(i1::SpelledInterval, i2::SpelledInterval) =
    (i1.octaves, diasteps(i1.fifths), chromshift(i1.fifths)) <
    (i2.octaves, diasteps(i2.fifths), chromshift(i2.fifths))

Base.isequal(i1::SpelledInterval, i2::SpelledInterval) =
    i1.octaves == i2.octaves && i1.fifths == i2.fifths

Base.hash(i::SpelledInterval, x::UInt) = hash(i.octaves, hash(i.fifths, x))

+(i1::SpelledInterval, i2::SpelledInterval) =
    spelled(i1.fifths + i2.fifths,
            i1.octaves + i2.octaves + fld(diasteps(i1.fifths) + diasteps(i2.fifths), 7))
-(i1::SpelledInterval, i2::SpelledInterval) =
    spelled(i1.fifths - i2.fifths,
            i1.octaves - i2.octaves + fld(diasteps(i1.fifths) - diasteps(i2.fifths), 7))
function -(i::SpelledInterval)
    off = mod(i.fifths,7) == 0 ? 0 : 1
    spelled(-i.fifths, (-i.octaves) - off)
end
Base.zero(::Type{SpelledInterval}) = spelled(0,0)
Base.zero(::SpelledInterval) = spelled(0,0)
*(i::SpelledInterval, n::Integer) = spelled(i.fifths*n, i.octaves*n + fld(diasteps(i.fifths)*n, 7))
*(n::Integer,i::SpelledInterval) = spelled(i.fifths*n, i.octaves*n + fld(diasteps(i.fifths)*n, 7))

tomidi(i::SpelledInterval) = midi(mod(7*i.fifths,12) + 12*i.octaves)
tomidi(p::Pitch{SpelledInterval}) = Pitch(midi(p.pitch) + midi(12))  # C4 = 48 semitones above C0 = midi(60)
octave(::Type{SpelledInterval}) = spelled(0,1)

function Base.sign(i::SpelledInterval)
    so = sign(i.octaves)
    sd = sign(diasteps(i.fifths))
    if so != 0
        so
    else
        sd
    end
end
Base.abs(i::SpelledInterval) = if sign(i) < 0; -i else i end

ic(i::SpelledInterval) = sic(i.fifths)
embed(i::SpelledInterval) = i
intervaltype(::Type{SpelledInterval}) = SpelledInterval
intervalclasstype(::Type{SpelledInterval}) = SpelledIC

function isstep(i::SpelledInterval)
    iabs = abs(i)
    (iabs.octaves == 0) && (diasteps(iabs.fifths) <= 1)
end 
chromsemi(::Type{SpelledInterval}) = spelled(7,0)

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

function Base.show(io::IO, ic::SpelledIC)
    dia = diasteps(ic.fifths)
    diff = chromshift(ic.fifths)
    qual = if dia ∈ perfectints
        qualpf(diff, 'a', 'P', 'd')
    else
        qualimpf(diff, 'a', 'M', 'm', 'd')
    end
    
    print(io, qual * string(dia+1))
end

function Base.show(io::IO, p::Pitch{SpelledIC})
    i = p.pitch
    dia = diasteps(i.fifths)
    alter = chromshift(i.fifths)
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

tomidi(i::SpelledIC) = midic(i.fifths * 7)
tomidi(p::Pitch{SpelledIC}) = midipc(p.interval.fifths * 7)
octave(::Type{SpelledIC}) = sic(0)
function Base.sign(i::SpelledIC)
    dia = diasteps(i.fifths)
    if dia == 0; 0 elseif dia > 3; -1 else 1 end
end
Base.abs(i::SpelledIC) = i

ic(i::SpelledIC) = i
function embed(i::SpelledIC)
    spelled(i.fifths, 0)
end
intervaltype(::Type{SpelledIC}) = SpelledInterval
intervalclasstype(::Type{SpelledIC}) = SpelledIC

isstep(i::SpelledIC) = diasteps(i.fifths) ∈ [0,1,6]
chromsemi(::Type{SpelledIC}) = sic(7)

# parsing

const rgsic = r"^(-?)(a+|d+|[MPm])([1-7])$"
const rgspelled = r"^(-?)(a+|d+|[MPm])([1-7])(\+|-)(\d+)$"

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

# TODO: write tests
function parsespelled(str)
    m = match(rgsic, str)
    if m != nothing
        int = sic(matchinterval(m[2], m[3]))
    else
        m = match(rgspelled, str)
        if m != nothing
            fifths = matchinterval(m[2], m[3])
            octs = parse(Int, m[4]*m[5])
            int = spelled(fifths, octs)
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

function parsespelledpitch(str)
    m = match(rgspelledpc, str)
    if m != nothing
        spc(matchpitch(m[1], m[2]))
    else
        m = match(rgspelledp, str)
        if m != nothing
            octs = parse(Int, m[3])
            fifths = matchpitch(m[1], m[2])
            spelledp(fifths, octs)
        else
            error("cannot parse pitch \"$str\"")
        end
    end
end

macro p_str(str)
    parsespelledpitch(str)
end
