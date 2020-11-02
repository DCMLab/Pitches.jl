var documenterSearchIndex = {"docs":
[{"location":"spelled/#Spelled-Pitch","page":"Spelled Pitch","title":"Spelled Pitch","text":"","category":"section"},{"location":"spelled/#Overview","page":"Spelled Pitch","title":"Overview","text":"","category":"section"},{"location":"spelled/","page":"Spelled Pitch","title":"Spelled Pitch","text":"Spelled pitches and intervals are the standard types of the Western music notation system. Unlike MIDI pitches, spelled pitches distinguish between enharmonically equivalent pitches such as E♭ and D♯. Similarly, spelled intervals distinguish between intervals such as m3 (minor 3rd) and a2 (augmented second) that would be equivalent in the MIDI system.","category":"page"},{"location":"spelled/","page":"Spelled Pitch","title":"Spelled Pitch","text":"The easiest way to use spelled pitches and intervals is to use the string macros i (for intervals) and p (for pitches), which parse a string in a standard notation that corresponds to how spelled pitches and intervals are printed. For parsing these representations programmatically, use parsespelled and parsespelledpitch for intervals and pitches, respectively. Spelled pitch classes are represented by an uppercase letter followed by zero or more accidentals, which can be either written as b/# or as ♭/♯. Spelled pitches take an additional octave number after the letter and the accidentals.","category":"page"},{"location":"spelled/","page":"Spelled Pitch","title":"Spelled Pitch","text":"julia> p\"Eb\"\nE♭\n\njulia> parsespelledpitch(\"Eb\")\nE♭\n\njulia> typeof(p\"Eb\")\nPitch{SpelledIC}\n\njulia> p\"Eb4\"\nE♭4\n\njulia> typeof(p\"Eb4\")\nPitch{SpelledInterval}","category":"page"},{"location":"spelled/","page":"Spelled Pitch","title":"Spelled Pitch","text":"Spelled interval classes consist of one or more letters that indicate the quality of the interval and a number between 1 and 7 that indicates the generic interval, e.g. P1 for a perfect unison, m3 for a minor 3rd or aa4 for a double augmented 4th.","category":"page"},{"location":"spelled/","page":"Spelled Pitch","title":"Spelled Pitch","text":"letter quality\ndd... diminished multiple times\nd diminished\nm minor\nP perfect\nM major\na augmented\naa... augmented multiple times","category":"page"},{"location":"spelled/","page":"Spelled Pitch","title":"Spelled Pitch","text":"Spelled intervals have the same elements as intervals but additionally take a number of octaves, written a suffix +n, e.g. P1+0 or m3+20. By default, intervals are directed upwards. Downwards intervals are indicated by a negative sign, e.g. -M2+1 (a major 9th down). For interval classes, downward and upward intervals cannot be distinguish, so a downward interval is represented by its complementary upward interval:","category":"page"},{"location":"spelled/","page":"Spelled Pitch","title":"Spelled Pitch","text":"julia> i\"-M3\"\nm6\n\njulia> -i\"M3\"\nm6","category":"page"},{"location":"spelled/#Representations-of-Spelled-Intervals","page":"Spelled Pitch","title":"Representations of Spelled Intervals","text":"","category":"section"},{"location":"spelled/#Fifths-and-Octaves","page":"Spelled Pitch","title":"Fifths and Octaves","text":"","category":"section"},{"location":"spelled/","page":"Spelled Pitch","title":"Spelled Pitch","text":"Internally, spelled intervals are represented by, 5ths and octaves. Both dimensions are logically dependent: a major 2nd up is represented by going two 5ths up and one octave down.","category":"page"},{"location":"spelled/","page":"Spelled Pitch","title":"Spelled Pitch","text":"julia> spelled(2,-1) # two 5ths, one octave\nM2+0","category":"page"},{"location":"spelled/","page":"Spelled Pitch","title":"Spelled Pitch","text":"This representation is convenient for arithmetics, which can usually be done component-wise. However, special care needs to be taken when converting to other representations. For example, the notated octave number (e.g. +0 in i\"M2+0\") does not correspond to the internal octaves of the interval (-1 in this case). In the notation, the interval class (M2) and the octave (+0) are independent.","category":"page"},{"location":"spelled/","page":"Spelled Pitch","title":"Spelled Pitch","text":"Interpreting the \"internal\" (or dependent) octave dimension of the interval does not make much sense without looking at the fifths. Therefore, the function octaves returns the \"external\" (or independent) octaves as used in the string representation, e.g.","category":"page"},{"location":"spelled/","page":"Spelled Pitch","title":"Spelled Pitch","text":"julia> octaves(i\"M2+0\")\n0\n\njulia> octaves(i\"M2+1\")\n1\n\njulia> octaves(i\"M2-1\")\n-1","category":"page"},{"location":"spelled/","page":"Spelled Pitch","title":"Spelled Pitch","text":"If you want to look at the internal octaves, use internalocts. This corresponds to looking at the .octaves field, but works on interval classes too.","category":"page"},{"location":"spelled/#Diatonic-Steps-and-Alterations","page":"Spelled Pitch","title":"Diatonic Steps and Alterations","text":"","category":"section"},{"location":"spelled/","page":"Spelled Pitch","title":"Spelled Pitch","text":"We provide a number of convenience functions to derive other properties from this representation. The generic interval (i.e. the number of diatonic steps) can be obtained using generic. generic respects the direction of the interval but is limitied to a single octave (0 to ±6). If you need the total number of diatonic steps, including octaves, use diasteps. The function degree returns the scale degree implied by the interval relative to some root. Since scale degrees are always above the root, degree, it treats negative intervals like their positive complements:","category":"page"},{"location":"spelled/","page":"Spelled Pitch","title":"Spelled Pitch","text":"julia> Pitches.generic(Pitches.i\"-M3+1\") # some kind of 3rd down\n-2\n\njulia> Pitches.diasteps(Pitches.i\"-M3+1\") # a 10th down\n-9\n\njulia> Pitches.degree(Pitches.i\"-M3+1\") # scale degree VI\n5","category":"page"},{"location":"spelled/","page":"Spelled Pitch","title":"Spelled Pitch","text":"For interval classes, all three functions are equivalent. Note that all three count from 0 (for unison/I), not 1.","category":"page"},{"location":"spelled/","page":"Spelled Pitch","title":"Spelled Pitch","text":"Complementary to the generic interval functions, alteration returns the specific quality of the interval. For perfect or major intervals, it returns 0. Larger absolute intervals return positive values, smaller intervals return negative values.","category":"page"},{"location":"spelled/","page":"Spelled Pitch","title":"Spelled Pitch","text":"degree and alteration also work on pitches. degree(p) returns an integer corresponding to the letter (C=0, D=1, ...), while alteration(p) provides the accidentals (natural=0, sharps -> positive, flats -> negative). For convenience, letter(p) returns the letter as an uppercase character.","category":"page"},{"location":"spelled/#Reference","page":"Spelled Pitch","title":"Reference","text":"","category":"section"},{"location":"spelled/#Types","page":"Spelled Pitch","title":"Types","text":"","category":"section"},{"location":"spelled/","page":"Spelled Pitch","title":"Spelled Pitch","text":"SpelledInterval\nSpelledIC","category":"page"},{"location":"spelled/#Pitches.SpelledInterval","page":"Spelled Pitch","title":"Pitches.SpelledInterval","text":"SpelledInterval <: Interval\n\nSpelled intervals represented as pairs of fifths and octaves. E.g., SpelledInterval(-3, 2) represents a minor 3rd upwards (3 fifths down, 2 octaves up).\n\n\n\n\n\n","category":"type"},{"location":"spelled/#Pitches.SpelledIC","page":"Spelled Pitch","title":"Pitches.SpelledIC","text":"SpelledIC <: IntervalClass\n\nSpelled interval class represented on the line of 5ths with 0 = C. E.g., SpelledIC(3) represents a major 6th upwards or minor 3rd downwards (i.e., three 5ths up modulo octave).\n\n\n\n\n\n","category":"type"},{"location":"spelled/#Constructors","page":"Spelled Pitch","title":"Constructors","text":"","category":"section"},{"location":"spelled/","page":"Spelled Pitch","title":"Spelled Pitch","text":"spelled\nspelledp\nsic\nspc\n@i_str\n@p_str\nparsespelled\nparsespelledpitch","category":"page"},{"location":"spelled/#Pitches.spelled","page":"Spelled Pitch","title":"Pitches.spelled","text":"spelled(fifths, octaves)\n\nCreates a spelled interval from fifths and octaves.\n\n\n\n\n\n","category":"function"},{"location":"spelled/#Pitches.spelledp","page":"Spelled Pitch","title":"Pitches.spelledp","text":"spelledp(fifths, octaves)\n\nCreates a spelled pitch from fifths and octaves.\n\n\n\n\n\n","category":"function"},{"location":"spelled/#Pitches.sic","page":"Spelled Pitch","title":"Pitches.sic","text":"sic(fifths)\n\nCreates a spelled interval class going fifths 5ths upwards.\n\n\n\n\n\n","category":"function"},{"location":"spelled/#Pitches.spc","page":"Spelled Pitch","title":"Pitches.spc","text":"spc(fifths)\n\nCreates a spelled pitch class. In analogy to sic, this function takes a number of 5ths.\n\n\n\n\n\n","category":"function"},{"location":"spelled/#Pitches.@i_str","page":"Spelled Pitch","title":"Pitches.@i_str","text":"i\"str\"\n\nParse a spelled interval or interval class string. The type is determined from the string, so i\"M3+0\" returns an interval while i\"M3\" returns an interval class.\n\nSee also: @p_str, parsespelled, parsespelledpitch.\n\n\n\n\n\n","category":"macro"},{"location":"spelled/#Pitches.@p_str","page":"Spelled Pitch","title":"Pitches.@p_str","text":"p\"str\"\n\nParse a spelled pitch or pitch class string. The type is determined from the string, so p\"G4\" returns a pitch while p\"G\" returns a pitch class.\n\nSee also: @i_str, parsespelledpitch, parsespelled.\n\n\n\n\n\n","category":"macro"},{"location":"spelled/#Pitches.parsespelled","page":"Spelled Pitch","title":"Pitches.parsespelled","text":"parsespelled(str)\n\nParse a spelled interval or interval class string. The type is determined from the string, so i\"M3+0\" returns an interval while i\"M3\" returns an interval class.\n\nSee also: @i_str, parsespelledpitch.\n\n\n\n\n\n","category":"function"},{"location":"spelled/#Pitches.parsespelledpitch","page":"Spelled Pitch","title":"Pitches.parsespelledpitch","text":"parsespelledpitch(str)\n\nParse a spelled pitch or pitch class string. The type is determined from the string, so p\"G4\" returns a pitch while p\"G\" returns a pitch class.\n\nSee also: @p_str, parsespelled.\n\n\n\n\n\n","category":"function"},{"location":"spelled/#Other-Special-Functions","page":"Spelled Pitch","title":"Other Special Functions","text":"","category":"section"},{"location":"spelled/","page":"Spelled Pitch","title":"Spelled Pitch","text":"octaves\ninternalocts\nfifths\ndegree\ngeneric\ndiasteps\nalteration\nletter","category":"page"},{"location":"spelled/#Pitches.octaves","page":"Spelled Pitch","title":"Pitches.octaves","text":"octaves(i)\noctaves(p)\n\nReturn the number of octaves the interval spans. Positive intervals start at 0 octaves, increasing. Negative intervals start at -1 octaves, decreasing. (You might want to use octaves(abs(i)) instead).\n\nFor a pitch, return its octave.\n\n\n\n\n\n","category":"function"},{"location":"spelled/#Pitches.internalocts","page":"Spelled Pitch","title":"Pitches.internalocts","text":"internalocts(i)\n\nReturn the internal octaves (i.e. dependent on the 5ths dimension) of an interval.\n\n\n\n\n\n","category":"function"},{"location":"spelled/#Pitches.fifths","page":"Spelled Pitch","title":"Pitches.fifths","text":"fifths(i)\nfifths(p)\n\nReturn the octave-invariant part of the interval in fifths (unison=0, 5th up=1, 4th up/5th down=-1). For a pitch, return the pitch class on the line of fifths.\n\n\n\n\n\n","category":"function"},{"location":"spelled/#Pitches.degree","page":"Spelled Pitch","title":"Pitches.degree","text":"degree(i)\ndegree(p)\n\nReturn the \"relative scale degree\" (0-6) to which the interval points (unison=0, 2nd=1, octave=0, 2nd down=6, etc.). For pitches, return the integer that corresponds to the letter (C=0, D=1, ...).\n\nSee also: generic, diasteps, letter\n\n\n\n\n\n","category":"function"},{"location":"spelled/#Pitches.generic","page":"Spelled Pitch","title":"Pitches.generic","text":"generic(i)\n\nReturn the generic interval, i.e. the number of diatonic steps modulo octave. Unlike degree, the result respects the sign of the interval (unison=0, 2nd up=1, 2nd down=-1). For pitches, use degree.\n\nSee also: degree, diasteps\n\n\n\n\n\n","category":"function"},{"location":"spelled/#Pitches.diasteps","page":"Spelled Pitch","title":"Pitches.diasteps","text":"diasteps(i)\n\nReturn the diatonic steps of the interval (unison=0, 2nd=1, ..., octave=7). Respects both direction and octaves.\n\nSee also degree and generic.\n\n\n\n\n\n","category":"function"},{"location":"spelled/#Pitches.alteration","page":"Spelled Pitch","title":"Pitches.alteration","text":"alteration(i)\nalteration(p)\n\nReturn the number of semitones by which the interval is altered from its the perfect or major variant. Positive alteration always indicates augmentation, negative alteration indicates diminution (minor or smaller) of the interval. For pitches, return the accidentals (positive=sharps, negative=flats, 0=natural).\n\n\n\n\n\n","category":"function"},{"location":"spelled/#Pitches.letter","page":"Spelled Pitch","title":"Pitches.letter","text":"letter(p)\n\nReturns the letter of a pitch as a character.\n\nSee also: degree.\n\n\n\n\n\n","category":"function"},{"location":"midi/#MIDI-Pitch","page":"MIDI Pitch","title":"MIDI Pitch","text":"","category":"section"},{"location":"midi/#Overview","page":"MIDI Pitch","title":"Overview","text":"","category":"section"},{"location":"midi/","page":"MIDI Pitch","title":"MIDI Pitch","text":"MIDI pitches and intervals are specified in 12-TET semitones, with 60 as Middle C. Both MIDI pitches and intervals can be represented by integers. However, we provides lightweight wrapper types around Int to distinguish the different interpretations as pitches and intervals (and their respective class variants). Midi pitches can be easily created using the midi* constructors, all of which take integers.","category":"page"},{"location":"midi/","page":"MIDI Pitch","title":"MIDI Pitch","text":"constructor example type printed representation\nmidi(15) MidiInterval i15\nmidic(15) MidiIC ic3\nmidip(60) Pitch{MidiInterval} p60\nmidipc(60) Pitch{MidiIC} pc0","category":"page"},{"location":"midi/","page":"MIDI Pitch","title":"MIDI Pitch","text":"For quick experiments on the REPL, using these constructors every time can be cumbersome. For those cases, we provide a set of macros with the same names at the constructors that turn all integer literals in the subsequent expression into the respective pitch or interval type. You can use parentheses to limit the scope of the macros.","category":"page"},{"location":"midi/","page":"MIDI Pitch","title":"MIDI Pitch","text":"julia> @midi [1,2,3], [2,3,4]\n(MidiInterval[i1, i2, i3], MidiInterval[i2, i3, i4])\n\njulia> @midi([1,2,3]), [2,3,4]\n(MidiInterval[i1, i2, i3], [2, 3, 4])\n\njulia> (@midi [1,2,3]), [2,3,4]\n(MidiInterval[i1, i2, i3], [2, 3, 4])","category":"page"},{"location":"midi/#Reference","page":"MIDI Pitch","title":"Reference","text":"","category":"section"},{"location":"midi/#Types","page":"MIDI Pitch","title":"Types","text":"","category":"section"},{"location":"midi/","page":"MIDI Pitch","title":"MIDI Pitch","text":"MidiInterval\nMidiIC","category":"page"},{"location":"midi/#Pitches.MidiInterval","page":"MIDI Pitch","title":"Pitches.MidiInterval","text":"MidiInterval <: Interval\n\nIntervals represented as chromatic integers. 60 is Middle C.\n\n\n\n\n\n","category":"type"},{"location":"midi/#Pitches.MidiIC","page":"MIDI Pitch","title":"Pitches.MidiIC","text":"MidiIC <: IntervalClass\n\nInterval classes represented as cromatic integers in Z_12, where 0 is C.\n\n\n\n\n\n","category":"type"},{"location":"midi/#Constructors","page":"MIDI Pitch","title":"Constructors","text":"","category":"section"},{"location":"midi/","page":"MIDI Pitch","title":"MIDI Pitch","text":"midi\nmidic\nmidip\nmidipc\n@midi\n@midic\n@midip\n@midipc","category":"page"},{"location":"midi/#Pitches.midi","page":"MIDI Pitch","title":"Pitches.midi","text":"midi(interval)\n\nCreates a MidiInterval from an integer.\n\n\n\n\n\n","category":"function"},{"location":"midi/#Pitches.midic","page":"MIDI Pitch","title":"Pitches.midic","text":"midic(interval)\n\nCreates a MidiIC from an integer.\n\n\n\n\n\n","category":"function"},{"location":"midi/#Pitches.midip","page":"MIDI Pitch","title":"Pitches.midip","text":"midip(n)\n\nCreates a midi pitch (Pitch{MidiInterval}) from an integer.\n\n\n\n\n\n","category":"function"},{"location":"midi/#Pitches.midipc","page":"MIDI Pitch","title":"Pitches.midipc","text":"midipc(n)\n\nCreates a midi pitch class (Pitch{MidiIC}) from an integer.\n\n\n\n\n\n","category":"function"},{"location":"midi/#Pitches.@midi","page":"MIDI Pitch","title":"Pitches.@midi","text":"@midi expr\n\nReplaces all Ints in expr with a call to midi(::Int). This allows the user to write integers where midi intervals are required. Does not work when expr contains integers that should not be converted or intervals that are not written as literal integers.\n\n\n\n\n\n","category":"macro"},{"location":"midi/#Pitches.@midic","page":"MIDI Pitch","title":"Pitches.@midic","text":"@midic expr\n\nReplaces all Ints in expr with a call to midi(::Int). This allows the user to write integers where midi intervals are required. Does not work when expr contains integers that should not be converted or intervals that are not written as literal integers.\n\n\n\n\n\n","category":"macro"},{"location":"midi/#Pitches.@midip","page":"MIDI Pitch","title":"Pitches.@midip","text":"@midip expr\n\nReplaces all Ints in expr with a call to midip(::Int). This allows the user to write integers where midi intervals are required. Does not work when expr contains integers that should not be converted or intervals that are not written as literal integers.\n\n\n\n\n\n","category":"macro"},{"location":"midi/#Pitches.@midipc","page":"MIDI Pitch","title":"Pitches.@midipc","text":"@midipc expr\n\nReplaces all Ints in expr with a call to midipc(::Int). This allows the user to write integers where midi intervals are required. Does not work when expr contains integers that should not be converted or intervals that are not written as literal integers.\n\n\n\n\n\n","category":"macro"},{"location":"midi/#Conversion","page":"MIDI Pitch","title":"Conversion","text":"","category":"section"},{"location":"midi/","page":"MIDI Pitch","title":"MIDI Pitch","text":"tomidi","category":"page"},{"location":"midi/#Pitches.tomidi","page":"MIDI Pitch","title":"Pitches.tomidi","text":"tomidi(i [, ...])\ntomidi(p [, ...])\n\nConverts a pitch or interval to the corresponding midi type. Depending on the input type, this might require additional parameters.\n\n\n\n\n\n","category":"function"},{"location":"interface/#The-Generic-Interface","page":"The Generic Interface","title":"The Generic Interface","text":"","category":"section"},{"location":"interface/#Overview","page":"The Generic Interface","title":"Overview","text":"","category":"section"},{"location":"interface/#Handling-Intervals","page":"The Generic Interface","title":"Handling Intervals","text":"","category":"section"},{"location":"interface/","page":"The Generic Interface","title":"The Generic Interface","text":"The operations of the generic interface are based on intervals as the fundamental elements. Intervals can be thought of as vectors in a vector space (or more precisely: a module over integers). They can be added, subtracted, negated, and multiplied with integers. Pitches, on the other hand, can be seen as points in this space and are represented as intervals in relation to an (implicit) origin. Therefore, pitch types are mainly defined as a wrapper type Pitch{Interval} that generically defines its arithmetic operations in terms of the corresponding interval type.","category":"page"},{"location":"interface/","page":"The Generic Interface","title":"The Generic Interface","text":"Interval types (here denoted as I) define the following operations:","category":"page"},{"location":"interface/","page":"The Generic Interface","title":"The Generic Interface","text":"I + I\nI - I\n-I\nI * Integer\nInteger * I\nsign(I)\nabs(I)","category":"page"},{"location":"interface/","page":"The Generic Interface","title":"The Generic Interface","text":"The sign indicates the logical direction of the interval by musical convention (upward = positive, downward = negative), even if the interval space is multi-dimensional. Consequently, abs ensures that an interval is neutral or upward-directed. For interval classes (which are generally undirected), the sign indicates the direction of the \"shortest\" class member:","category":"page"},{"location":"interface/","page":"The Generic Interface","title":"The Generic Interface","text":"julia> sign(i\"P4\")\n1\n\njulia> sign(i\"P5\") # == -i\"P4\"\n-1","category":"page"},{"location":"interface/","page":"The Generic Interface","title":"The Generic Interface","text":"In addition to arithmetic operations, some special intervals are defined:","category":"page"},{"location":"interface/","page":"The Generic Interface","title":"The Generic Interface","text":"unison(Type{I}) / zero(Type{I})\noctave(Type{I})\nchromsemi(Type{I}) (a chromatic semitone, optional)\nisstep(I) (optional, a predicate that test whether the interval is considered a \"step\")","category":"page"},{"location":"interface/","page":"The Generic Interface","title":"The Generic Interface","text":"Finally, some operations specify the relationship between intervals and interval classes:","category":"page"},{"location":"interface/","page":"The Generic Interface","title":"The Generic Interface","text":"ic(I): Returns the corresponding interval class.\nembed(IC [, octs::Int]): Returns a canonical embedding of an interval class into interval space.\nintervaltype(Type{IC}) = I\nintervalclasstype(Type{I}) = IC","category":"page"},{"location":"interface/#Handling-Pitches","page":"The Generic Interface","title":"Handling Pitches","text":"","category":"section"},{"location":"interface/","page":"The Generic Interface","title":"The Generic Interface","text":"Pitch operations generally interact with intervals (and can be derived from the interval operations):","category":"page"},{"location":"interface/","page":"The Generic Interface","title":"The Generic Interface","text":"P + I -> P\nI + P -> P\nP - I -> P\nP - P -> I\npc(P) -> PC\nembed(PC [, octaves]) -> P","category":"page"},{"location":"interface/#Other-useful-functions","page":"The Generic Interface","title":"Other useful functions","text":"","category":"section"},{"location":"interface/","page":"The Generic Interface","title":"The Generic Interface","text":"Besides the specific functions of the interface, pitch and interval types generally implement basic functions such as","category":"page"},{"location":"interface/","page":"The Generic Interface","title":"The Generic Interface","text":"isless / <\nisequal / ==\nhash\nshow (usually also specialized for Pitch{I})","category":"page"},{"location":"interface/","page":"The Generic Interface","title":"The Generic Interface","text":"Note that the ordering of pitches is generally not unique, so isless uses an appropriate convention for each interval type.","category":"page"},{"location":"interface/#Generic-API-Reference","page":"The Generic Interface","title":"Generic API Reference","text":"","category":"section"},{"location":"interface/","page":"The Generic Interface","title":"The Generic Interface","text":"Here we only list the new functions that are introduced by this library, not the ones that are already defined in Base.","category":"page"},{"location":"interface/#Special-Intervals","page":"The Generic Interface","title":"Special Intervals","text":"","category":"section"},{"location":"interface/","page":"The Generic Interface","title":"The Generic Interface","text":"unison\noctave\nchromsemi\nisstep","category":"page"},{"location":"interface/#Pitches.unison","page":"The Generic Interface","title":"Pitches.unison","text":"unison(T)\n\nReturns the interval of a unison for interval type T. Alias for Base.zero. New interval types should implement Base.zero, but user code should call unison for better interpretability.\n\n\n\n\n\n","category":"function"},{"location":"interface/#Pitches.octave","page":"The Generic Interface","title":"Pitches.octave","text":"octave(T, [n=1])\n\nReturns the interval corresponding to an octave for interval type T. For interval classes, this should return zero(T) (a default method is provided).\n\nIf n is specified, the octave is multiplied by n first. This is equivalent to octave(T) * n.\n\nFor convenience, a fallback for octave(p::T, [n]) is provided. Only octave(T) needs to be implemented.\n\n\n\n\n\n","category":"function"},{"location":"interface/#Pitches.chromsemi","page":"The Generic Interface","title":"Pitches.chromsemi","text":"chromsemi(I::Type)\n\nReturns a chromatic semitone of type I.\n\n\n\n\n\n","category":"function"},{"location":"interface/#Pitches.isstep","page":"The Generic Interface","title":"Pitches.isstep","text":"isstep(p)\n\nFor diatonic intervals, indicates whether p is a step.\n\n\n\n\n\n","category":"function"},{"location":"interface/#Classes-(Octave-Equivalence)","page":"The Generic Interface","title":"Classes (Octave Equivalence)","text":"","category":"section"},{"location":"interface/","page":"The Generic Interface","title":"The Generic Interface","text":"ic\npc\nembed\nintervaltype\nintervalclasstype","category":"page"},{"location":"interface/#Pitches.ic","page":"The Generic Interface","title":"Pitches.ic","text":"ic(i)\n\nReturns the interval class of an interval, removing the octave\n\n\n\n\n\n","category":"function"},{"location":"interface/#Pitches.pc","page":"The Generic Interface","title":"Pitches.pc","text":"pc(p)\n\nReturn the pitch class that corresponds to p.\n\n\n\n\n\n","category":"function"},{"location":"interface/#Pitches.embed","page":"The Generic Interface","title":"Pitches.embed","text":"embed(ic, [oct=0])\nembed(pc, [oct=0])\n\nConverts an interval class to an interval in the canonical octave, adding oct octaves, if supplied. Also works for pitches.\n\n\n\n\n\n","category":"function"},{"location":"interface/#Pitches.intervaltype","page":"The Generic Interface","title":"Pitches.intervaltype","text":"intervaltype(IC::Type)\n\nReturns for an interval class type IC the corresponding interval type. For convenience, intervaltype(ic::IC) is also provided.\n\n\n\n\n\n","category":"function"},{"location":"interface/#Pitches.intervalclasstype","page":"The Generic Interface","title":"Pitches.intervalclasstype","text":"intervalclasstype(I::Type)\n\nReturns for an interval type I the corresponding interval class type. For convenience, intervalclasstype(p::P) is also provided.\n\n\n\n\n\n","category":"function"},{"location":"#Pitches.jl","page":"Pitches.jl","title":"Pitches.jl","text":"","category":"section"},{"location":"","page":"Pitches.jl","title":"Pitches.jl","text":"CurrentModule = Pitches","category":"page"},{"location":"","page":"Pitches.jl","title":"Pitches.jl","text":"A library for handling musical pitches and intervals in a systematic way. For other (and mostly compatible) implementations see:","category":"page"},{"location":"","page":"Pitches.jl","title":"Pitches.jl","text":"pitchtypes (Python)\na Haskell implementation (WIP, coming soon)\na Clojure(Script) implementation (WIP, coming soon)","category":"page"},{"location":"","page":"Pitches.jl","title":"Pitches.jl","text":"The general interface is described in a separate specification.","category":"page"},{"location":"#Overview","page":"Pitches.jl","title":"Overview","text":"","category":"section"},{"location":"","page":"Pitches.jl","title":"Pitches.jl","text":"This library defines types for musical intervals and pitches as well as a generic interface for writing algorithms that work with different pitch and interval types. For example, you can write a function like this","category":"page"},{"location":"","page":"Pitches.jl","title":"Pitches.jl","text":"transposeby(pitches, interval) = [pitch + interval for pitch in pitches]","category":"page"},{"location":"","page":"Pitches.jl","title":"Pitches.jl","text":"and it will work with any midi pitch:","category":"page"},{"location":"","page":"Pitches.jl","title":"Pitches.jl","text":"julia> transposeby((@midip [60, 63, 67]), midi(3))\n3-element Array{Pitch{MidiInterval},1}:\n p63\n p66\n p70","category":"page"},{"location":"","page":"Pitches.jl","title":"Pitches.jl","text":"... midi pitch classes:","category":"page"},{"location":"","page":"Pitches.jl","title":"Pitches.jl","text":"julia> transposeby(map(midipc, [3,7,10]), midic(3))\n3-element Array{Pitch{MidiIC},1}:\n pc6\n pc10\n pc1","category":"page"},{"location":"","page":"Pitches.jl","title":"Pitches.jl","text":"... spelled pitch:","category":"page"},{"location":"","page":"Pitches.jl","title":"Pitches.jl","text":"julia> transposeby([p\"C4\", p\"E4\", p\"G4\"], i\"m3+0\")\n3-element Array{Pitch{SpelledInterval},1}:\n E♭4\n G4\n B♭4","category":"page"},{"location":"","page":"Pitches.jl","title":"Pitches.jl","text":"... spelled pitch classes:","category":"page"},{"location":"","page":"Pitches.jl","title":"Pitches.jl","text":"julia> transposeby([p\"C\", p\"E\", p\"G\"], i\"m3\")\n3-element Array{Pitch{SpelledIC},1}:\n E♭\n G\n B♭","category":"page"},{"location":"","page":"Pitches.jl","title":"Pitches.jl","text":"... or any other pitch type.","category":"page"},{"location":"tutorial/#Getting-Started","page":"Getting Started","title":"Getting Started","text":"","category":"section"},{"location":"tutorial/","page":"Getting Started","title":"Getting Started","text":"TODO","category":"page"},{"location":"logfreq/#Frequencies-and-Ratios","page":"Frequencies and Ratios","title":"Frequencies and Ratios","text":"","category":"section"},{"location":"logfreq/#Overview","page":"Frequencies and Ratios","title":"Overview","text":"","category":"section"},{"location":"logfreq/","page":"Frequencies and Ratios","title":"Frequencies and Ratios","text":"Pitches and intervals can also be expressed as physical frequencies and freqency ratios, respectively. We provide wrappers around Float64 that represent log frequencies and log freqency ratios, and perform arithmetic with and without octave equivalence. There are two versions of each constructor depending on whether you provide log or non-log values. All values are printed as non-log. Pitch and interval classes are printed in brackets to indicate that they are representatives of an equivalence class.","category":"page"},{"location":"logfreq/","page":"Frequencies and Ratios","title":"Frequencies and Ratios","text":"julia> freqi(3/2)\nfr1.5\n\njulia> logfreqi(log(3/2))\nfr1.5\n\njulia> freqic(3/2)\nfr[1.5]\n\njulia> freqp(441)\n441.0Hz\n\njulia> freqpc(441)\n[1.7226562500000004]Hz","category":"page"},{"location":"logfreq/","page":"Frequencies and Ratios","title":"Frequencies and Ratios","text":"Because of the use of floats, rounding errors can occur:","category":"page"},{"location":"logfreq/","page":"Frequencies and Ratios","title":"Frequencies and Ratios","text":"julia> freqp(440)\n439.99999999999983Hz","category":"page"},{"location":"logfreq/","page":"Frequencies and Ratios","title":"Frequencies and Ratios","text":"You can use Julia's builtin method isapprox/≈ to test for approximate equality:","category":"page"},{"location":"logfreq/","page":"Frequencies and Ratios","title":"Frequencies and Ratios","text":"julia> freqp(220) + freqi(2) ≈ freqp(440)\ntrue","category":"page"},{"location":"logfreq/#Reference","page":"Frequencies and Ratios","title":"Reference","text":"","category":"section"},{"location":"logfreq/#Types","page":"Frequencies and Ratios","title":"Types","text":"","category":"section"},{"location":"logfreq/","page":"Frequencies and Ratios","title":"Frequencies and Ratios","text":"FreqInterval\nFreqIC","category":"page"},{"location":"logfreq/#Pitches.FreqInterval","page":"Frequencies and Ratios","title":"Pitches.FreqInterval","text":"FreqInterval <: Interval\n\nA frequency ratio interval. Is internally represented by the logarithm of the frequency ratio, so conversion to Float64 will return a log-frequency ratio!\n\n\n\n\n\n","category":"type"},{"location":"logfreq/#Pitches.FreqIC","page":"Frequencies and Ratios","title":"Pitches.FreqIC","text":"FreqIC <: Interval\n\nA frequency ratio interval class. Is internally represented by the logarithm of the frequency ratio, so conversion to Float64 will return a log-frequency ratio! Maintains octave equivalence.\n\n\n\n\n\n","category":"type"},{"location":"logfreq/#Constructors","page":"Frequencies and Ratios","title":"Constructors","text":"","category":"section"},{"location":"logfreq/","page":"Frequencies and Ratios","title":"Frequencies and Ratios","text":"octave equivalent takes log interval pitch\nno no freqi freqp\n yes logfreqi logfreqp\nyes no freqic freqpc\n yes logfreqic logfreqpc","category":"page"},{"location":"logfreq/","page":"Frequencies and Ratios","title":"Frequencies and Ratios","text":"freqi\nfreqic\nfreqp\nfreqpc\nlogfreqi\nlogfreqp\nlogfreqic\nlogfreqpc","category":"page"},{"location":"logfreq/#Pitches.freqi","page":"Frequencies and Ratios","title":"Pitches.freqi","text":"freqi(ratio)\n\nCreates a frequency ratio interval from a frequency ratio.\n\n\n\n\n\n","category":"function"},{"location":"logfreq/#Pitches.freqic","page":"Frequencies and Ratios","title":"Pitches.freqic","text":"freqic(ratio)\n\nCreates a frequency ratio interval class from a frequency ratio.\n\n\n\n\n\n","category":"function"},{"location":"logfreq/#Pitches.freqp","page":"Frequencies and Ratios","title":"Pitches.freqp","text":"freqp(frequency)\n\nCreates a frequency pitch from a frequency.\n\n\n\n\n\n","category":"function"},{"location":"logfreq/#Pitches.freqpc","page":"Frequencies and Ratios","title":"Pitches.freqpc","text":"freqpc(frequency)\n\nCreates a frequency pitch class from a frequency.\n\n\n\n\n\n","category":"function"},{"location":"logfreq/#Pitches.logfreqi","page":"Frequencies and Ratios","title":"Pitches.logfreqi","text":"logfreqi(logratio)\n\nCreates a frequency ratio interval from a log-ratio.\n\n\n\n\n\n","category":"function"},{"location":"logfreq/#Pitches.logfreqp","page":"Frequencies and Ratios","title":"Pitches.logfreqp","text":"logfreqp(logfrequency)\n\nCreates a frequency pitch from a log-frequency.\n\n\n\n\n\n","category":"function"},{"location":"logfreq/#Pitches.logfreqic","page":"Frequencies and Ratios","title":"Pitches.logfreqic","text":"logfreqic(logratio)\n\nCreates a frequency ratio interval class from a log-ratio.\n\n\n\n\n\n","category":"function"},{"location":"logfreq/#Pitches.logfreqpc","page":"Frequencies and Ratios","title":"Pitches.logfreqpc","text":"logfreqpc(logfrequency)\n\nCreates a frequency pitch class from a log-frequency.\n\n\n\n\n\n","category":"function"}]
}
