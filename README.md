

# What is this?

Code to reproduce Fig. 2e from: Marc Serra-Garcia, André Foehr, Miguel Molerón, Joseph Lydon, Christopher Chong, and Chiara Daraio
Phys. Rev. Lett. 117, 010602
# Why does this exist?
1. To understand the Mechanical Autonomous Stochastic Heat Engine by reproducing key results.

2. To experiment with simulating the SDE in Julia. The Julia package specification is in Project.toml and Manfist.toml, and the environment is instantiated with Pkg.instantiate(). Call this will trigger a precompilation of the packages and may take a while.

# How should I use it?
Clone this repo, and install Julia. Then, open the Julia REPL in the repo directory and run
```
julia> using Pkg
julia> Pkg.instantiate()
julia> include("fig2f.jl")
```