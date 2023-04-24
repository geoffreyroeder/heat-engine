include("units.jl")
include("parameters.jl")
println(stderr, "Checking if a precomputed solution exists...")

dt = 3*micro*sec
u0 = [0.0,0.0,0.0,0.0,0.0,0.0]

t0 = 0.0*sec
t1 = 500.0*sec

tspan = (t0,t1)


solver_str = "SRIW1"
fp = "$(solver_str)_t0$(t0)_t1$(t1)_$(dt).arrow"

# --- compute or load
if isfile(fp)
  println("Found precomputed solution $(pwd())/$(fp); nothing to do!")
  exit(0)
end

println(stderr, "No precomputed solution found.")


println(stderr, "Loading packages...")
using DifferentialEquations: solve, SDEProblem, SRIW1


using Plots
using Arrow
using DataFrames

println(stderr, "Setting up system to solve...")


function drift!(dw,w,p,t)
  # --- unpack parameters from p
  m, k, b, T = p
  mH, mM, mW = m
  bH, bM, bW = b
  kH, kM, kW, kHM = k
  xH, xM, xW, vH, vM, vW = w
  # --- write differential into pre-allocated data structure
  dw[1] = vH
  dw[2] = vM
  dw[3] = vW
  # dw[4] = (-1/mH)*(bH*vH + kH*xH + kHM*(xH - xM) + mu*xH^3)
  dw[4] = (-1/mH)*(bH*vH + kH*xH + kHM*(0*xH - xM))
  # dw[5] = (-1/mM)*(bM*vM + (kM - 2*gamma*xW)*xM + kHM*(xM - xH) + mu*xM^3)  
  dw[5] = (-1/mM)*(bM*vM + (kM - 2*gamma*xW)*xM + kHM*(0*xM - xH))
  dw[6] = (-1/mW)*(bW*vW + kW*xW - gamma*xM^2)
end

function noise!(dw,w,p,t)
  m, k, b, T = p
  mH, mM, mW = m
  bH, bM, bW = b
  TH, TC, TW = T
  dw[1] = 0.0
  dw[2] = 0.0
  dw[3] = 0.0
  dw[4] = (1/mH)*sqrt(2*kb*bH*TH) 
  dw[5] = (1/mM)*sqrt(2*kb*bM*TC)
  dw[6] = (1/mW)*sqrt(2*kb*bW*TW)
end



println(stderr, "Solving SDEProblem with $(solver_str)...")

# --- do solve
heatengine = SDEProblem(drift!, noise!, u0, (t0,t1), params)
solver = SRIW1
sol = solve(heatengine, solver(),dt=dt, maxiters=10^9+1)
ttotal = sol.t[end]
println(stderr, "Finished solve")

# --- write to file
Arrow.write(fp, sol)
println(stderr, "Wrote solution to: \n $(fp)")
