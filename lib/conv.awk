# ------------------------------------------------------------------------------
# conversion by gaussian 2010 constants
# https://gaussian.com/constants/
# ------------------------------------------------------------------------------

function au2kcalmol(energy) 
{
    # Hartree           4.35974434 × 10^-18
    # calorie           4.184 J (Thermochemical calorie, exact)
    # Avogardo constant 6.02214129 × 10^23 mol^-1
    fact = 4.35974434*6.02214129/4.184*10^2;
    return(energy*fact);
}

# ------------------------------------------------------------------------------

function au2ang(len) 
{
    # Bohr a0          0.52917721092
    fact = 0.52917721092;
    return(len*fact);
}
