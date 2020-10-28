@testset "MIDI pitches" begin
    @testset "types ok and compact" begin
        @test isbitstype(MidiInterval)
        @test isbitstype(MidiIC)
        @test isbitstype(Pitch{MidiInterval})
        @test isbitstype(Pitch{MidiIC})
    end

    @testset "constructors" begin
        @test midi(3) == midi(3)
        @test midip(60) == midip(60)
        @test midic(15) == midic(3)
        @test midipc(63) == midipc(3)
    end

    @testset "macro constructors" begin
        @test (@midi [1,2,3]) == midi.([1,2,3])
        @test (@midip [1,2,3]) == midip.([1,2,3])
        @test (@midic [1,2,3]) == midic.([1,2,3])
        @test (@midipc [1,2,3]) == midipc.([1,2,3])
    end

    @testset "String conversion" begin
        @test string(midi(3)) == "i3"
        @test string(midip(63)) == "p63"
        @test string(midic(15)) == "ic3"
        @test string(midipc(63)) == "pc3"
    end

    @testset "Int conversion" begin
        @test Int(midi(3)) == 3
        @test Int(midip(63)) == 63
        @test Int(midic(15)) == 3
        @test Int(midipc(63)) == 3
    end

    @testset "hashing" begin
        @test hash(midi(3)) == hash(midi(3))
        @test hash(midip(3)) == hash(midip(3))
        @test hash(midic(3)) == hash(midic(3))
        @test hash(midipc(3)) == hash(midipc(3))
    end

    @testset "interval interface" begin
        @test midi(3) + midi(10) == midi(13)
        @test midi(-3) + midi(4) == midi(1)
        @test midi(3) + midi(-4) == midi(-1)
        @test midi(3) - midi(4) == midi(-1)
        @test -midi(5) == midi(-5)
        @test -midi(7) == midi(0) - midi(7)

        @test zero(MidiInterval) == midi(0)
        @test zero(midi(3)) == midi(0)

        @test midi(2) * 7 == midi(14)
        @test midi(-3) * 4 == midi(-12)
        @test midi(4) * -3 == midi(-12)
        @test 6 * midi(2) == midi(12)
        @test 4 * midi(-4) == midi(-16)
        @test 5 * midi(4) == midi(20)

        @test tomidi(midi(42)) == midi(42)
        @test octave(MidiInterval) == midi(12)
        @test sign(midi(3)) == 1
        @test sign(midi(0)) == 0
        @test sign(midi(-3)) == -1
        @test abs(midi(-3)) == midi(3)

        @test ic(midi(15)) == midic(3)
        @test ic(midi(-3)) == midic(9)
        @test embed(midi(42)) == midi(42)
        @test intervaltype(MidiInterval) == MidiInterval
        @test intervalclasstype(MidiInterval) == MidiIC

        for i in -2:2
            @test isstep(midi(i)) == true
        end
        for i in -13:-3
            @test isstep(midi(i)) == false
        end
        for i in 3:13
            @test isstep(midi(i)) == false
        end

        @test chromsemi(MidiInterval) == midi(1)
    end

    @testset "interval class interface" begin
        @test midic(3) + midic(10) == midic(1)
        @test midic(-3) + midic(4) == midic(1)
        @test midic(3) + midic(-4) == midic(11)
        @test midic(3) - midic(4) == midic(11)
        @test -midic(5) == midic(-5)
        @test -midic(7) == midic(0) - midic(7)

        @test zero(MidiIC) == midic(0)
        @test zero(midic(3)) == midic(0)

        @test midic(2) * 7 == midic(14)
        @test midic(-3) * 4 == midic(-12)
        @test midic(4) * -3 == midic(-12)
        @test 6 * midic(2) == midic(12)
        @test 4 * midic(-4) == midic(-16)
        @test 5 * midic(4) == midic(20)

        @test tomidi(midic(42)) == midic(42)
        @test octave(MidiIC) == midic(0)
        @test sign(midic(3)) == 1
        @test sign(midic(0)) == 0
        @test sign(midic(-3)) == -1
        @test abs(midic(-3)) == midic(3)

        @test ic(midic(15)) == midic(3)
        @test ic(midic(-3)) == midic(9)
        @test embed(midic(3)) == midi(3)
        @test embed(midic(-3)) == midi(9)
        @test intervaltype(MidiIC) == MidiInterval
        @test intervalclasstype(MidiIC) == MidiIC

        for i in -2:2
            @test isstep(midic(i)) == true
        end
        for i in -9:-3
            @test isstep(midic(i)) == false
        end
        for i in 3:9
            @test isstep(midic(i)) == false
        end

        @test chromsemi(MidiIC) == midic(1)
    end

    @testset "pitch interface" begin
        @test topitch(midi(3)) == midip(3)
        @test tointerval(midip(42)) == midi(42)

        @test midip(63) + midi(7) == midip(70)
        @test midip(63) + midi(-3) == midip(60)
        @test midip(63) - midi(7) == midip(56)
        @test midip(67) - midip(61) == midi(6)

        @test pc(midip(63)) == midipc(3)
        @test embed(midip(8)) == midip(8)
    end

    @testset "pitch class interface" begin
        @test topitch(midic(3)) == midipc(3)
        @test tointerval(midipc(42)) == midic(42)
        
        @test midipc(63) + midic(7) == midipc(70)
        @test midipc(63) + midic(-3) == midipc(60)
        @test midipc(63) - midic(7) == midipc(56)
        @test midipc(67) - midipc(61) == midic(6)

        @test pc(midipc(63)) == midipc(3)
        @test embed(midipc(8)) == midip(8)
    end
end
