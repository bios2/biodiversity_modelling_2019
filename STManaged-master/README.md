# STManaged: State and transition model for the eastern North American forest

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active) [![Travis build status](https://travis-ci.org/willvieira/STManaged.svg?branch=master)](https://travis-ci.org/willvieira/STManaged) [![AppVeyor build status](https://ci.appveyor.com/api/projects/status/mypax31p5fr0uf44/branch/master?svg=true)](https://ci.appveyor.com/project/WillianVieira/stmanaged/branch/master) [![codecov](https://codecov.io/gh/willvieira/STManaged/branch/master/graph/badge.svg)](https://codecov.io/gh/willvieira/STManaged)

The `{STManaged}` R package runs the State and transition model for the eastern North American forest, with integrated forest management practices. This package allows you to model the spatially explicit dynamics of four forest states (Boreal, Temperate, Mixed and Regeneration) over space and time. You will be able to set the intensity of four management practices (plantation, harvest, thinning and enrichment) that aim to increase the northward range shift of forest.

## Installation

Install the `STManaged` package with the `devtools` (or `remotes`) package:

```r
devtools::install_github("willvieira/STManaged")
```

On Linux you need to install the ImageMagick++ library (see [here](https://ropensci.org/blog/2016/08/23/z-magick-release/)), or you can install a [version](https://github.com/willvieira/STManaged/tree/noAnimation) of this package without the `animation()` function.

## Quick start

```r
library(STManaged)

# Create the initial landscape defining the range of annual mean temperature and the cell size:
initLand <- create_virtual_landscape(climRange = c(-2.61, 5.07), cellSize = 2)

# Print the initial landscape
plot_landscape(initLand, Title = 'initial_landscape')

# Run the model for 100 years with temperature increase of 1.8 degrees
lands <- run_model(steps = 20,
                   initLand,
                   managInt = c(0, 0, 0, 0),
                   RCP = 4.5)

# Some functions are already built in to check the model output
## Forest state occupancy for first and last year
par(mfrow = c(2, 1))
plot_occupancy(lands, step = 0, spar = 0.4)
plot_occupancy(lands, step = 20, spar = 0.4)

## Range limit shift of Boreal and Temperate states over time
plot_rangeShift(lands, rangeLimitOccup = 0.7)

## animated gif of the dynamics
animate(lands, fps = 5, gifName = 'RCP4.5', rangeLimitOccup = 0.7)
```
