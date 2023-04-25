

# What is this?

Code to reproduce Fig. 2f from: [Marc Serra-Garcia, André Foehr, Miguel Molerón, Joseph Lydon, Christopher Chong, and Chiara Daraio
Phys. Rev. Lett. 117, 010602](https://journals.aps.org/prl/abstract/10.1103/PhysRevLett.117.010602)
# Why does this exist?
1. To understand the Mechanical Autonomous Stochastic Heat Engine by reproducing key results.

2. To experiment with simulating the governing SDE in Julia.

# How should I use it?
Clone this repo, and install Julia. Then, open the Julia REPL in the repo directory and run
```
julia> using Pkg
julia> Pkg.instantiate()
```
This will install all the packages needed to run the code, defined in `Manifest.toml` and `Project.toml`. Then, exit the REPL and execute
```
julia --threads=auto simulate.jl
```
to run the simulation. The results will be saved as `SRIW1_t00.0_t1500.0_3.0e-6.arrow`. To plot the results, run
```
julia --threads=auto plot_fig2f.jl <data_file_name> 
```
where <data_file_name> is `SRIW1_t00.0_t1500.0_3.0e-6.arrow` by default, but will change if you modify any of: the solver, simulation start time, simulation end time, or step size. This script will create the plot and save it as `fig2f.png` in the repo directory.
