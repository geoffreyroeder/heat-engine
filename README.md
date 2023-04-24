

# What is this?

A reproduction of Fig. 2e from: Marc Serra-Garcia, André Foehr, Miguel Molerón, Joseph Lydon, Christopher Chong, and Chiara Daraio
Phys. Rev. Lett. 117, 010602
# Why does this exist?
1. To understand the Mechanical Autonomous Stochastic Heat Engine paper by reproducing key results

2. To experiment with simulating the SDE in Julia


# How should I use it?
Clone this repo, and install Julia. Then, open the Julia REPL in the main directory and run
```
julia> using Pkg
julia> Pkg.instantiate()
julia> include("src/fig2f.jl")
```


# Getting started
1. Rename repo to sane project name
2. Create new git repo with sane name
3. Rename conda env in /environment.yml
4. rename source code package dir in /src
5. Run `conda env create -f environment.yml`. See https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#creating-an-environment-from-an-environment-yml-file for more details
6. Then, run `conda activate project_environment`, `cd src`, `pip install -e .` Now you can import anything from the custom source package.

# TODOs:
0. Make script for renaming conda env and source package
1. Add MyPy running via GitHub action, e.g. https://doedotdev.medium.com/mypy-for-github-action-7da1ebee99e7
2. Singularity for managing system-wide libraries
3. Docker for system-wide libraries
4. Review https://docs.python-guide.org/writing/structure/ 



