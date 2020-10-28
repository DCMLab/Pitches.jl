const feps = 0.00001

import Base: ≈

≈(a::FreqInterval, b::FreqInterval) =
    a.lfr ≈ b.lfr
≈(a::FreqIC, b::FreqIC) =
    (a.lfr ≈ b.lfr) || (a.lfr + log(2) ≈ b.lfr) || (a.lfr ≈ b.lfr + log(2))
≈(a::Pitch, b::Pitch) = a.pitch ≈ b.pitch

@testset "Frequency pitches" begin
    @testset "types ok and compact" begin
        @test isbitstype(FreqInterval)
        @test isbitstype(FreqIC)
        @test isbitstype(Pitch{FreqInterval})
        @test isbitstype(Pitch{FreqIC})
    end

    @testset "constructors" begin
        @test logfreqi(log(3.8)) == freqi(3.8)
        @test logfreqic(log(3.8)) == freqic(3.8)
        @test logfreqic(log(3.8) + log(2)) ≈ freqic(3.8)
        @test logfreqp(log(441)) == freqp(441)
        @test logfreqpc(log(441)) == freqpc(441)
        @test logfreqpc(log(441) + log(2)) ≈ freqpc(441)
    end

    @testset "printing" begin
        @test string(freqi(3.8))  == "fr3.8"
        @test string(freqic(3.8)) == "fr[1.9]"
        @test string(freqp(441)) == "441.0Hz"
        @test string(freqpc(441)) == "[1.7226562500000004]Hz"
    end

    @testset "hashing" begin
        @test hash(logfreqi(log(3.8))) == hash(freqi(3.8))
        @test hash(logfreqic(log(3.8))) == hash(freqic(3.8))
        @test hash(logfreqi(log(441))) == hash(freqi(441))
        @test hash(logfreqic(log(441))) == hash(freqic(441))
    end

    @testset "interval interface" begin
        @test freqi(3/2) + freqi(4/3) ≈ freqi(2)
        @test freqi(2/3) + freqi(4/3) ≈ freqi(8/9)
        @test (-freqi(3/2)) + freqi(4/3) ≈ freqi(8/9)
        @test freqi(4/3) - freqi(3/2) ≈ -freqi(9/8)
        @test -freqi(3/2) ≈ freqi(2/3)
        @test -freqi(4/5) ≈ unison(FreqInterval) - freqi(4/5)

        @test unison(FreqInterval) == freqi(1)
        @test unison(freqi(0.42)) == freqi(1)

        @test freqi(3/2) * 2 == freqi(9/4)
        @test freqi(3/2) * -2 == freqi(4/9)
        @test 2 * freqi(3/2) == freqi(9/4)
        @test -2 * freqi(3/2) == freqi(4/9)

        @test sign(freqi(3/2)) == 1
        @test sign(freqi(2/3)) == -1
        @test sign(freqi(1)) == 0
        @test abs(freqi(3/2)) == freqi(3/2)
        @test abs(freqi(2/3)) ≈ freqi(3/2)
        @test abs(freqi(1)) == freqi(1)

        @test octave(FreqInterval) == freqi(2)
        @test chromsemi(FreqInterval) == logfreqi(log(2)/12)

        @test ic(freqi(3)) ≈ freqic(3)
        @test ic(freqi(3)) ≈ freqic(3/2)
        @test ic(freqi(3/2)) ≈ freqic(3)
        @test embed(freqi(3/2)) == freqi(3/2)
        @test intervaltype(FreqInterval) == FreqInterval
        @test intervalclasstype(FreqInterval) == FreqIC
    end

    @testset "interval class interface" begin
        @test freqic(3/2) + freqic(4/3) ≈ freqic(2)
        @test freqic(2/3) + freqic(4/3) ≈ freqic(8/9)
        @test (-freqic(3/2)) + freqic(4/3) ≈ freqic(8/9)
        @test freqic(4/3) - freqic(3/2) ≈ -freqic(9/8)
        @test -freqic(3/2) ≈ freqic(2/3)
        @test -freqic(4/5) ≈ unison(FreqIC) - freqic(4/5)

        @test unison(FreqIC) == freqic(1)
        @test unison(freqic(0.42)) == freqic(1)

        @test freqic(3/2) * 2 == freqic(9/4)
        @test freqic(3/2) * -2 == freqic(4/9)
        @test 2 * freqic(3/2) == freqic(9/4)
        @test -2 * freqic(3/2) == freqic(4/9)

        @test sign(freqic(3/2)) == -1
        @test sign(freqic(2/3)) == 1
        @test sign(freqic(1)) == 0
        @test abs(freqic(3/2)) == freqic(2/3)
        @test abs(freqic(2/3)) ≈ freqic(2/3)
        @test abs(freqic(1)) == freqic(1)

        @test octave(FreqIC) == freqic(2)
        @test chromsemi(FreqIC) == logfreqic(log(2)/12)

        @test ic(freqic(3)) ≈ freqic(3)
        @test ic(freqic(3)) ≈ freqic(3/2)
        @test ic(freqic(3/2)) ≈ freqic(3)
        @test embed(freqic(3/2)) == freqi(3/2)
        @test intervaltype(FreqIC) == FreqInterval
        @test intervalclasstype(FreqIC) == FreqIC
    end

    @testset "pitch interface" begin
        @test topitch(freqi(441)) == freqp(441)
        @test tointerval(freqp(441)) == freqi(441)

        @test freqp(441) + freqi(2) ≈ freqp(882)
        @test freqp(441) + freqi(1/2) ≈ freqp(220.5)
        @test freqp(441) - freqi(2) ≈ freqp(220.5)
        @test freqp(441) - freqp(431.5) ≈ freqi(441/431.5)
        
        @test pc(freqp(441)) == freqpc(441)
        @test embed(freqp(441)) == freqp(441)
    end

    @testset "pitch class interface" begin
        @test topitch(freqic(441)) == freqpc(441)
        @test tointerval(freqpc(441)) == freqic(441)

        @test freqpc(441) + freqic(3/2) ≈ freqpc(661.5)
        @test freqpc(441) + freqic(2/3) ≈ freqpc(294)
        @test freqpc(441) - freqic(3/2) ≈ freqpc(294)
        @test freqpc(441) - freqpc(431.5) ≈ freqic(441/431.5)
        
        @test pc(freqpc(441)) == freqpc(441)
        @test embed(freqpc(441)) == logfreqp(mod(log(441), log(2)))
        @test embed(freqpc(441), 8) == freqp(441)        
    end
end
