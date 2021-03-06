# Load the PVA library
library(PVA, lib.loc="R:/Fall2004/ESM 211")

# Construct a simple matrix for the semipamated sandpiper
A <- rbind(c(0.02115, 0.074, 0.0846),
           c(0.563, 0, 0),
           c(0, 0.563, 0.563))
N0 <- c(23.5, 14.2, 7.3)

# Iterate the model
dmm.iter(A,N0,20)

# show the plot on a log scale
dmm.iter(A,N0,20,log='y',col='black')

# Do some matrix magic!
dmm.asymp(A)


## Do the same thing for the sea lion model
data(sealion)
sealion.dmm <- dmm(sealion, type="age", census="pre", terminal=F)
dmm.iter(sealion.dmm, rep(100,13),40)
dmm.asymp(sealion.dmm)

## and for the cereus model
data(Cereus.Grow)
data(Cereus.Fruit)
cereus.dmm <- dmm(Cereus.Grow, fec=Cereus.Fruit, p0=0.03448, type="size",
    census="pre", data.type="aggregated",
    classes=c("<1","1-4","4-8","8-16","16-32",">32"))
dmm.iter(cereus.dmm, c(10,11,19,16,25,15),40)
dmm.asymp(cereus.dmm)

# Look at vital rate sensitivity for the two models
sens.vr(sealion.dmm)

sens.vr(cereus.dmm)

# Vital rate uncertainty in the cereus model
cereus.dmm$se

# ... and its effect on uncertainty in lambda
se.lambda(cereus.dmm)

## Extract annual demography from the cereus data
cereus2.dmm <- dmm(Cereus.Grow, fec=Cereus.Fruit, p0=0.03448, type="size",
    census="pre", data.type="aggregated",
    classes=c("<1","1-4","4-8","8-16","16-32",">32"),annual=T,years=1988:1992)

cereus2.dmm$mat.ann

# Estimated extinction risk, resampling matrices to simulate Environmental
#   stochasticity
cereus1.ext <- dmm.PVA(cereus2.dmm, Nc=c(10,11,19,16,25,15), Nx=50, 
    year.max=100, nsim=1000, ES="MatrixDraw", DS=FALSE)
cereus1.ext


# Note that this does not yet work!!!
cereus1.ext <- dmm.PVA(cereus2.dmm, Nc=c(10,11,19,16,25,15), Nx=50, year.max=3, nsim=2, ES="ParDraw", DS=T)
