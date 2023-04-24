"""
This module contains functions for calculating physical properties of a coupled 
ribbon-cantilever system, such as dimensionless damping coefficients and 
stiffness coefficients.

Including this module imports `params` into the current namespace.

The system consists of:
- A cantilever (W) with displacement xW
- A main ribbon (M) with displacement xM, attached to the cantilever
- A secondary ribbon (H) with displacement xH, weakly coupled to the main ribbon,
  submerged in heat bath with temperature TH
"""

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

