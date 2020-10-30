import Pkg; Pkg.activate("."); Pkg.instantiate()
using Documenter

#include("../src/Pitches.jl")
push!(LOAD_PATH, "../src/")
using Pitches

makedocs(
    sitename="My Documentation",
    pages = [
        "index.md",
        "tutorial.md",
        "interface.md",
        "Pitch and Interval Types" => [
            "spelled.md",
            "midi.md",
            "logfreq.md",
        ]
    ]
)
