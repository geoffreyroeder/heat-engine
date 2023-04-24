using Plots
using Arrow  # implements Apache Arrow memory specification in pure Julia
using DataFrames

# Run headless GKS so no display is needed
# https://discourse.julialang.org/t/generation-of-documentation-fails-qt-qpa-xcb-could-not-connect-to-display/60988
# https://gr-framework.org/workstations.html#no-output
ENV["GKSwstype"] = "100"

include("units.jl")

# get name of precomputed solution file from command line arguments
fp = ARGS[1]
println(stderr, "Loading data from $(fp)...")

sol = Arrow.Table(fp)

# --- convert to DataFrame
sol_df = DataFrame(sol)
colnames = ["t","xH", "xM", "xW", "vH", "vM", "vW"] 
rename!(sol_df, Symbol.(colnames))

# --- plot Cantilever displacements vs time 
figpath = "fig2f.png"
t0 = 0

println(stderr, "Creating figure...")
tf_s = 1000 * (milli/sec)
tf_idx = findfirst(x -> x >tf_s, sol_df.t)
t_ms = sol_df.t[end - tf_idx:end]
xW_mim = sol_df.xW[end - tf_idx:end].*(meter)#/micro)
xM_mim = sol_df.xM[end - tf_idx:end].*(meter/milli)
  p = plot!(t_ms, xW_mim, label="Cantilever displacement (m)",legend=:topleft, color=:red)
  pp = plot!(twinx(p), t_ms, xM_mim, label="Main ribbon displacement (m)", color=:blue, legend=:topleft)
  title!("Cantilever & Main Ribbon Disp. vs Time (s)")

println(stderr, "Saving figure to $(figpath)")

savefig(pp, figpath)
println(stderr, "Done!")