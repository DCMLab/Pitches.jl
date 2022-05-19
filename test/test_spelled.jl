@testset "Spelled pitches" begin
    @testset "types ok and compact" begin
        @test isbitstype(SpelledInterval)
        @test isbitstype(SpelledIC)
        @test isbitstype(Pitch{SpelledInterval})
        @test isbitstype(Pitch{SpelledIC})
    end

    @testset "constructors" begin
        @test spelled(-3, 0) == spelled(-3, 0)
        @test spelledp(0, 4) == spelledp(0, 4)
        @test sic(-3) == sic(-3)
        @test spc(3) == spc(3)
    end

    @testset "string macros" begin
        @test i"M3:1" == spelled(4, -1)
        @test i"-M3:0" == spelled(-4, 2)
        @test p"C♭4" == spelledp(-7, 8)
        @test p"Cb4" == spelledp(-7, 8)
        @test i"m3" == sic(-3)
        @test i"-m3" == sic(3)
        @test p"C♯" == spc(7)
        @test p"C#" == spc(7)
        # TODO: test more complex parsing cases
    end

    @testset "accessors" begin
        @test octaves(i"M3:1") == 1
        @test internalocts(i"M3:1") == -1
        @test fifths(i"M3:1") == 4
        @test degree(i"M3:1") == 2
        @test generic(i"M3:1") == 2
        @test diasteps(i"M3:1") == 9
        @test alteration(i"M3:1") == 0
        
        @test octaves(i"-M3:1") == -2
        @test internalocts(i"-M3:1") == 1
        @test fifths(i"-M3:1") == -4
        @test degree(i"-M3:1") == 5
        @test generic(i"-M3:1") == -2
        @test diasteps(i"-M3:1") == -9
        @test alteration(i"-M3:1") == 0

        @test octaves(i"a5") == 0
        @test internalocts(i"a5") == 0
        @test fifths(i"a5") == 8
        @test degree(i"a5") == 4
        @test generic(i"a5") == 4
        @test diasteps(i"a5") == 4
        @test alteration(i"a5") == 1

        @test octaves(p"Ebb5") == 5
        @test fifths(p"Ebb5") == -10
        @test degree(p"Ebb5") == 2
        @test alteration(p"Ebb5") == -2
        @test letter(p"Ebb5") == 'E'
        
        @test octaves(p"F#") == 0
        @test fifths(p"F#") == 6
        @test degree(p"F#") == 3
        @test alteration(p"F#") == 1
        @test letter(p"F#") == 'F'

        # edge cases
        @test alteration(i"P4") == 0
        @test alteration(i"M7") == 0
        @test alteration(i"-P4:0") == 0
        @test alteration(i"-M7:0") == 0

        @test alteration(i"a4:0") == 1
        @test alteration(i"m7:0") == -1
        @test alteration(i"-a4:0") == 1
        @test alteration(i"-m7:0") == -1
        
        @test alteration(p"F") == 0
        @test alteration(p"B") == 0
    end

    @testset "printing" begin
        @test string(i"m3:1") == "m3:1"
        @test string(p"Eb4") == "E♭4"
        @test string(i"m3") == "m3"
        @test string(p"E#") == "E♯"
    end

    @testset "hashing" begin
        @test hash(spelled(-3,1)) == hash(spelled(-3,1))
        @test hash(spelledp(3,0)) == hash(spelledp(3,0))
        @test hash(sic(3)) == hash(sic(3))
        @test hash(spc(3)) == hash(spc(3))
    end

    @testset "interval interface" begin
        @test i"m3:0" + i"M3:0" == i"P5:0"
        @test i"m3:0" + i"M7:0" == i"M2:1"
        @test i"P5:0" + i"P5:0" == i"M2:1"
        @test i"-m3:0" + i"M3:0" == i"a1:0"
        @test i"m3:0" + i"-M3:0" == i"-a1:0"
        @test i"m3:0" - i"M3:0" == i"-a1:0"
        @test i"m3:0" - i"M6:0" == i"-a4:0"
        @test -i"P4:0" == i"-P4:0"
        @test -i"P4:0" == i"P5:-1"
        @test -i"P5:0" == zero(SpelledInterval) - i"P5:0"

        @test zero(SpelledInterval) == i"P1:0"
        @test zero(i"m3:0") == i"P1:0"

        @test i"P5:0" * 2 == i"M2:1"
        @test i"M2:0" * 4 == i"a5:0"
        @test i"-m3:0" * 4 == i"-d2:1"
        @test i"M3:0" * -3 == i"-a7:0"
        @test 4 * i"M2:0" == i"a5:0"
        @test 4 * i"-M3:0" == i"-aa2:1"
        @test 5 * i"M3:0" == i"aaa4:1"

        @test tomidi(i"aaa4:1") == midi(20)
        @test tomidi(i"-P5:0") == midi(-7)
        @test octave(SpelledInterval) == i"P1:1"
        @test sign(i"m2:0") == 1
        @test sign(i"P1:0") == 0
        @test sign(i"d1:0") == 0
        @test sign(i"a1:0") == 0
        @test sign(i"-m3:0") == -1
        @test abs(i"-m3:0") == i"m3:0"

        @test ic(i"M3:3") == i"M3"
        @test ic(i"-M3:1") == i"m6"
        @test embed(i"M3:3") == i"M3:3"
        @test intervaltype(SpelledInterval) == SpelledInterval
        @test intervalclasstype(SpelledInterval) == SpelledIC

        @test isstep(i"d1:0")
        @test isstep(i"P1:0")
        @test isstep(i"a1:0")
        @test isstep(i"d2:0")
        @test isstep(i"m2:0")
        @test isstep(i"M2:0")
        @test isstep(i"a2:0")
        @test isstep(i"-d2:0")
        @test isstep(i"-m2:0")
        @test isstep(i"-M2:0")
        @test isstep(i"-a2:0")

        @test !isstep(i"d3:0")
        @test !isstep(i"-d3:0")
        @test !isstep(i"M7:0")
        @test !isstep(i"-M7:0")
        @test !isstep(i"P1:1")
        @test !isstep(i"-P1:1")
        @test !isstep(i"m2:1")
        @test !isstep(i"-m2:1")
        
        @test chromsemi(SpelledInterval) == i"a1:0"
    end

    @testset "interval class interface" begin
        @test i"m3" + i"M3" == i"P5"
        @test i"m3" + i"M7" == i"M2"
        @test i"P5" + i"P5" == i"M2"
        @test i"-m3" + i"M3" == i"a1"
        @test i"m3" + i"-M3" == i"-a1"
        @test i"m3" - i"M3" == i"-a1"
        @test i"m3" - i"M6" == i"-a4"
        @test -i"P4" == i"-P4"
        @test -i"P4" == i"P5"
        @test -i"P5" == zero(SpelledIC) - i"P5"

        @test zero(SpelledIC) == i"P1"
        @test zero(i"m3") == i"P1"

        @test i"P5" * 2 == i"M2"
        @test i"M2" * 4 == i"a5"
        @test i"-m3" * 4 == i"-d2"
        @test i"M3" * -3 == i"-a7"
        @test 4 * i"M2" == i"a5"
        @test 4 * i"-M3" == i"-aa2"
        @test 5 * i"M3" == i"aaa4"

        @test tomidi(i"aaa4") == midic(8)
        @test tomidi(i"-P5") == midic(-7)
        @test octave(SpelledIC) == i"P1"
        @test sign(i"m2") == 1
        @test sign(i"P1") == 0
        @test sign(i"d1") == 0
        @test sign(i"a1") == 0
        @test sign(i"-m3") == -1
        @test abs(i"-m3") == i"m3"

        @test ic(i"-M3") == i"m6"
        @test embed(i"M3") == i"M3:0"
        @test embed(i"M7") == i"M7:0"
        @test embed(i"P4") == i"P4:0"
        @test embed(i"a1") == i"a1:0"
        @test intervaltype(SpelledIC) == SpelledInterval
        @test intervalclasstype(SpelledIC) == SpelledIC

        @test isstep(i"d1")
        @test isstep(i"P1")
        @test isstep(i"a1")
        @test isstep(i"d2")
        @test isstep(i"m2")
        @test isstep(i"M2")
        @test isstep(i"a2")
        @test isstep(i"-d2")
        @test isstep(i"-m2")
        @test isstep(i"-M2")
        @test isstep(i"-a2")

        @test !isstep(i"d3")
        @test !isstep(i"-d3")
        
        @test chromsemi(SpelledIC) == i"a1"
    end

    @testset "pitch interface" begin
        @test topitch(i"m3:4") == p"Eb4"
        @test tointerval(p"C#3") == i"a1:3"

        @test p"Eb4" + i"P5:0"  == p"Bb4"
        @test p"Eb4" + i"-m3:0" == p"C4"
        @test p"Eb4" - i"P5:0"  == p"Ab3"
        @test p"G4"  - p"C#4"   == i"d5:0"

        @test alteration(p"Ab-1") == -1
        @test alteration(p"A#-1") == 1

        @test pc(p"Eb4") == p"Eb"
        @test embed(p"Eb4") == p"Eb4"

        @test tomidi(p"C#3") == midip(49)
        @test tomidi(p"Db3") == midip(49)
    end

    @testset "pitch class interface" begin
        @test topitch(i"m3") == p"Eb"
        @test tointerval(p"E") == i"M3"

        @test p"Eb" + i"P5"  == p"Bb"
        @test p"Eb" + i"-m3" == p"C"
        @test p"Eb" - i"P5"  == p"Ab"
        @test p"G"  - p"C#"   == i"d5"
        
        @test pc(p"Eb") == p"Eb"
        @test embed(p"Eb") == p"Eb0"
        @test embed(p"Eb", 4) == p"Eb4"

        @test tomidi(p"C#") == midipc(1)
        @test tomidi(p"Db") == midipc(1)
    end
end
