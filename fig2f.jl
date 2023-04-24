println(stderr, "Loading packages...")
using DifferentialEquations: solve, SDEProblem, SRIW1
using Plots
using Arrow
using DataFrames

println(stderr, "Setting up system to solve...")


# --- physical relationships between eigenfrequencies and masses
function damping_coeff(Q, eigen_freq, m)
  # compute dimensionless damping coefficient 
  return m*(2*pi*eigen_freq)/Q
end

function stiffness(eigen_freq, mass)
  return mass*(2*pi*eigen_freq)^2
end

# xW: Cantilever displacement
# xM: Main ribbon displacement (attached to cantilever)
# xH: Secondary ribbon displacement, in heat bath, weakly coupled to main ribbon

# --- conversion functions
f_to_ω = (f) -> 2*pi*f                 # --- angular frequency in (rad) s^-1
fmQ_to_b = (f, m, Q) -> m*f_to_ω(f)/Q   # --- damping coefficient in kg (rad) s^-1
fm_to_k = (f, m) -> m*(f_to_ω(f))^2     # --- stiffness coefficient in kg (rad)^2 s^-2


# --- tuned parameters
kb = 1.380649e-23  # Boltzmann constant in m^2 kg s^-2 K^-1

# --- eigenfrequencies in Hz = s^-1
# note: these are not the angular eigenfrequencies so must be converted
fW = 26.87    # cantilever \pm 0.01
fH = 192.55   # hot ribbon \pm 0.02
fM = 165.37   # main ribbon \pm 0.02

# --- quality factors Q (dimensionless)
QW = 964 
QH = 59.3 
QM = 167.8

# --- effective masses in kg
mW = 1.27     # cantilever
mH = 0.207e-3 # secondary/hot ribbon
mM = mH       # primary/main/cold ribbon

gamma = 5.13*10^5  # nonlinear coupling between main ribbon and cantilever

# --- effective stiffness coefficients kX = mX fX^2 in N/m
kH = fm_to_k(fH, mH)
kW = fm_to_k(fW, mW)
kM = fm_to_k(fM, mM)

bH = fmQ_to_b(fH, mH, QH)
bW = fmQ_to_b(fW, mW, QW)
bM = fmQ_to_b(fM, mM, QM)

# --- linear coupling between hot ribbon and main ribbon (dimensionless)
kHM_kM = 0.0381 

# --- nonlinear coupling between cantilever and main ribbon in N/m^2
kHM = kHM_kM*kM  #  linear coupling coefficient between ribbons in Hz=1/s

# --- the heat bath is applied to the secondary ribbon xH
TH = 2*10^19 # temperature of hot ribbon in K
TC = 0       # TC, temperature of (cold) main ribbon in K
TW = 0       # TW, temperature of cantilever in K
T = (TH, TC, TW)
 

masses = (mH, mM, mW)
coeffs = (kH, kM, kW, kHM)
damping = (bH, bM, bW)
params = (masses, coeffs, damping, T)

# --- units for explicit conversions
sec = 1.0
meter = 1.0
milli = 10^-3
micro = 10^-6

# --- sanity checks
# main ribbon frequency lower than secondary (hot) ribbon
@assert fM < fH

# changes in main ribbon's vibration energy are modulated by cantilever motion; 
# modulation is maximal for weakly coupled ribbons when following LHS 
# of inequality is close to 0 
@assert fH - fM - fW < 4e-1

# sanity check relationships between Q, b, m, f 
# @show QW*bW / mW
# @show ω(fW)
@assert QW*bW / mW == f_to_ω(fW)
@assert QM*bM / mM == f_to_ω(fM)
@assert QH*bH / mH == f_to_ω(fH)

# sanity check relationship between natural frequency, stiffness, mass
@assert kW / mW == f_to_ω(fW)^2
@assert kM / mM == f_to_ω(fM)^2
@assert kH / mH == f_to_ω(fH)^2

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

@show dt = 3*micro*sec
u0 = [0.0,0.0,0.0,0.0,0.0,0.0]

t0 = 0.0*sec
t1 = 500.0*sec

tspan = (t0,t1)
solver = SRIW1

solver_str = String(Symbol(solver))
fp = "../data/$(solver_str)_t0$(t0)_t1$(t1)_$(dt).arrow"

if ! isfile(fp)
  println(stderr, "Solving SDEProblem with $(solver_str)...")

  # --- create the directory if it doesn't exist
  if ! isdir(dirname(fp))
    mkdir(dirname(fp))

  # --- do solve
  heatengine = SDEProblem(drift!, noise!, u0, (t0,t1), args);
  solver = SRIW1
  sol = solve(heatengine, solver(),dt=dt, maxiters=10^9+1);
  @show ttotal = sol.t[end]

  # --- write to file
  Arrow.write(fp, sol)
  @info "Wrote to $(fp)"
else
  print("Loading solution from $(fp)...")
  sol_df = DataFrame(Arrow.Table(fp))
  colnames = ["t","xH", "xM", "xW", "vH", "vM", "vW"]
  rename!(sol_df, Symbol.(colnames))
  print("Loaded solution from $(fp) as DataFrame and set column names")
end
# plot Cantilever displacements vecsus time
figpath = "../figures/heatengine_displacement_vs_time.png"
t0 = 0

println(stderr, "Creating figure at $(figpath)...")
tf_s = 1000 * (milli/sec)
@show tf_idx = findfirst(x -> x >tf_s, sol_df.t)
# tf_idx = floor(Int64,tf / dt)
t_ms = sol_df.t[end - tf_idx:end]
xW_mim = sol_df.xW[end - tf_idx:end].*(meter)#/micro)
xM_mim = sol_df.xM[end - tf_idx:end].*(meter/milli)
plot(t_ms, xW_mim, label="Cantilever displacement", legend=:topleft, color=:blue,)  # double wavelength of expected, double the frequency
# make left blue and right red
plot!(twinx(), t_ms, xM_mim, label="xM", color=:red, legend=:topleft)
xlabel!("time (s)")
ylabel!("displacement (m)")
title!("Cantilever Displacement vs Time")


if ! isdir(dirname(figpath))
  mkdir(dirname(figpath))
savefig("../figures/heatengine_displacement_vs_time.png")
println(stderr, "Done")