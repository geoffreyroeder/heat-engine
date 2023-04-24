

# What is this?

Code to reproduce Fig. 2f from: [Marc Serra-Garcia, André Foehr, Miguel Molerón, Joseph Lydon, Christopher Chong, and Chiara Daraio
Phys. Rev. Lett. 117, 010602](https://journals.aps.org/prl/abstract/10.1103/PhysRevLett.117.010602)
# Why does this exist?
1. To understand the Mechanical Autonomous Stochastic Heat Engine by reproducing key results.

2. To experiment with simulating the governing SDE in Julia. The Julia package specification is in Project.toml and Manfist.toml, and the environment is instantiated with Pkg.instantiate(). Call this will trigger a precompilation of the packages and may take a while.

# How should I use it?
Clone this repo, and install Julia. Then, open the Julia REPL in the repo directory and run
```
julia> using Pkg
julia> Pkg.instantiate()
```
This will install all the packages needed to run the code. Then, exit the REPL and execute
```
julia --threads=auto simulate.jl
```
to run the simulation. The results will be saved as "SRIW1_t00.0_t1500.0_3.0e-6.arrow." To plot the results, run
```
julia --threads=auto plot_fig2f.jl
```
This will create the plot and save it as "fig2f.pdf" in the repo directory.
