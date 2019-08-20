---
title       : "Day 1. Models overview"
author      : "Dominique Gravel"
job         : "Laboratoire d'écologie intégrative"
logo        : "logo.png"
framework   : io2012       # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      #
mode        : selfcontained
knit        : slidify::knit2slides
widgets     : [mathjax]
url:
  lib   : ./libraries
license     : by-nc-sa
assets      :
  css: "https://maxcdn.bootstrapcdn.com/font-awesome/4.6.0/css/font-awesome.min.css"
---
--- .transition

# Overview of biodiversity modeling techniques

---

# Objective

Give an overview of the diversity of techniques and approaches

--- &twocol

# Phenomenological models

*** =left

- Reproduce empirical relationships using different statistical models
- Good at interpolation, bad at extrapolation

*** =right

<img src="assets/img/worm.png" width="450px"></img>
Worm et al. 2006. Science.

--- &twocol 

# Differential equations

*** =left

- Continuous time
- Continuous variable
- Easy to analyze, with multiple tools
- Deterministic
- Often derived from theory
- May be hard to parameterize
- May be subject to numerical errors

*** =right

<img src="assets/img/IBT.png" width="450px"></img>
MacArthur and Wilson. 1963. Evolution.

--- &twocol 

# Partial differential equations

*** =left

- Same as ODEs but with several dimensions
- Much harder to solve analytically and numerically

*** =right

<img src="assets/img/ppa.png" width="450px"></img>
Strigul et al. 2008. Eco. Monogr.

--- &twocol 

# Difference equations

*** =left

- Similar to ODEs but discrete time
- Easier to fit to empirical data
- Easier to solve numerically

*** =right

<img src="assets/img/ricker.png" width="450px"></img>

$N_{t+1}= aN_t e^{-N_t/K}$



--- &twocol 

# Markov chain

*** =left

- Stochastic process
- Transition matrix
- Discrete time, discrete states
- No time lag
- Easy to fit to empirical data
- Several tools to analyze
- Traditional in forest ecology

*** =right

<img src="assets/img/brisson.png" width="500px"></img>
Brisson et al. 1994. Ecoscience

--- &twocol 

# Diffusion models

*** =left

- Partial differential equations
- Deterministic
- Random movement of particules (Brownian motion)
- Challenging analytically (but doable for some models)

*** =right

<img src="assets/img/skellam.png" width="450px"></img>
Kellam. 1951. Ecology

--- &twocol 

# Metapopulation

*** =left

- Spatial dynamics in discrete patches
- Continuous/discrete time
- Can be conditional on the environment
- Well suited for empirical analysis
- Used for conservation of endangered populations and for conservation area planning

*** =right

<img src="assets/img/owl.jpg" width="450px"></img>

--- &twocol 

# Epidemiology

*** =left

- Similar structure to metapop
- SIR, SIRS etc...
- Counts infected individuals instead of virus particules
- Seasonal dynamics
- Parameterized from field data
- Applied to forest ecosystems

*** =right

<img src="assets/img/keeling.png" width="350px"></img>
Keeling et al. 2001. Science. 

--- &twocol 

# Leslie matrices

*** =left

- Structured populations
- Transition among discrete states
- Deal with rates and probabilities 
- Density dependence
- Used to evaluate intrinsic growth rate and run PVA

*** =right

<img src="assets/img/leslie.png" width="450px"></img>


--- &twocol 

# Integro projection models

*** =left

- Continuous version of the Leslie matrix
- Explicitly consider variability among transitions with a kernel
- Developed for data analysis
- May be technically challenging
- Hard to introduce feedbacks
- May include evolutionary dynamics

*** =right

<img src="assets/img/IPM.jpg" width="450px"></img>


--- &twocol 

# Cellular automaton

*** =left

- Simplest spatial model
- Simulation based only
- Self-organization
- Could be deterministic or stochastic
- Easy to couple with other types of models
- Mean-field behaviour can be approximated with differential equations
- Turing complete (can perform any calculation that any other programmable computer can)!

*** =right

<img src="assets/img/CA.png" width="450px"></img>

---  

# Cellular automaton

<div style='text-align:center;'>
<img src="assets/img/CA2.png" width="950px"></img>
Jonathan McCabe
</div>


--- &twocol 

# Ecosystem fluxes 

*** =left

- Tradition in ecosystem ecology
- Ecopath developed for fisheries
- Usually static, can be transformed into ODEs
- Heavy to parameterize
- Often approximated with allometries
- Problem of balancing fluxes

*** =right

<img src="assets/img/legagneux.jpg" width="450px"></img>
Legagneux et al. 2012. Ecology

--- &twocol 

# Individual based models

*** =left

- Infinite possibilities
- Realistic but hardly tractable
- Heavy parameterization
- Error propagation

*** =right

<img src="assets/img/range_shifter.jpg" width="450px"></img>
Bocedi et al. 2014. Meth. Ecol. Evol.

--- &twocol 

# Forest gap models

*** =left

- Realistic for uneven age forests
- Rich evolutionary history
- Based on succession or individual tree performance
- Heavy parameterization, often obscur 
- Some are spatially explicit

*** =right

<img src="assets/img/sortie.png" width="450px"></img>
Beaudet et al. 2002. For. Ecol. Manag. 

--- &twocol 

# Food web models

*** =left

- Often using ODEs
- Size-based parameterization
- None is validated at the food web level
- Recent addition of temperature dependence
- Used mostly for theory

*** =right

<img src="assets/img/foodweb.png" width="450px"></img>
Cohen et al. 2003. PNAS

--- &twocol 

# Dynamic Global Vegetation Model 

*** =left

- First principles in plant physiology, biochemistry and hydrology
- For very large areas (regions to continents)
- Incorporated into dynamic climate-vegetation modeling
- Plant functional groups
- No range dynamics

*** =right

<img src="assets/img/dgvm.png" width="450px"></img>
Moorcroft et al. 2001. Eco. Monogr.

--- &twocol 

# Global Ecosystem Model

*** =left

- Madingley
- First principles for autotrophs and heterotrophs
- Marine & terrestrial
- Trophic interactions
- Temperature
- Spatial movement
- Monthly time resolution

*** =right

<img src="assets/img/harfoot2.png" width="450px"></img>
Harfoot et al. 2014. PLOS Biol. 

--- &twocol 

# Species Distribution Models

*** =left

- Easy to apply & very popular
- Various statistical methods
- Handle different types of data
- Can account for spatial autocorrelation
- Several limitations

*** =right

<img src="assets/img/mckenney.png" width="450px"></img>
McKenney et al. 2007. Bioscience.

--- &twocol 

# Phenological models

*** =left

- Hypothesis that phenology constrains ranges
- Developed for trees
- Successful and better at extrapolation than SDMs

*** =right

<img src="assets/img/phenofit.png" width="350px"></img>
Chuine & Beaubien. 2001. Ecol. Lett. 

--- &twocol 

# Species extinction

*** =left

- Based on point pattern process
- Inferrence of extinction date
- Use observation data
- Account for various data quality

*** =right

<img src="assets/img/woodpecker.png" width="400px"></img>
Gotelli et al. 2012. Cons. Biol.

--- 

# Other types

- Species Area Relationship (SAR)
- Species Abundance Distribution (SAD)
- Animal movement
- Dose-response
- [...]

---.transition 

# How to pick the appropriate approach ?

---

# Ten-steps guide to ecological modeling

---

# Example

<div style='text-align:center;'>
<img src="assets/img/talluto1.png" width="750px"></img>
</div>

---

# 1. Precisely define the objectives & needs

- Solve some of the limitations of SDMs (dispersal limitations, demography,  distribution in equilibrium with current climate)
- Evaluate the model with data
- Test some intuition about the drivers of species ranges

---

# 2. Use theory to justify assumptions and manage complexity

<div style='text-align:center;'>
<img src="assets/img/talluto2.png" width="750px"></img>
</div>

---

# 3. Make sure of mathematical rigor

Standard metapopluation theory : 

$\frac{dp(E)}{dt}=c(E)p(E)(1-p(e)) - e(E)p(E)$

But tree demography in temperate forests is seasonal. 

Tranformed the model into two states markov chain. 

Often, the problem is lack of or inappropriate units.

---

# 4. Proper interpretation of the model, limits and uncertainty 

- Bayesian analysis to fully document uncertainty in parameter estimates
- Posterior distribution of range maps to investigate error propagation
- Use theoretical tools to support the interpretation

---

# 5. Debug the code AND the model

- Simplicity of the theoretical model made it easy to solve
- Challenges with the bayesian implementation (JAGS, Stan, custom sampler in C++)
- Often the codes work, but it does not yields appropriate results

--- &twocol 

# 6. Code properly and for others

*** =left

- Group of 4 working on parameterization
- All were trained with system version control
- Hundreds of parameter files exchanged
- At the end, not sure if model was parameterized with 1 or 5 yr time steps ...

*** =right

<img src="assets/img/github.png" width="550px"></img>

---

# 7. Keep a journal of model development and tests

- Standard practice in biology labs to have a log book
- Tools to do it with code
- Comment, comment and comment ....

---

# 8. Run virtual experiments

<div style='text-align:center;'>
<img src="assets/img/vissault.png" width="450px"></img>
</div>

---

# 9. Model validation & updating

*In Global Change Biology, we generally like to see modelling studies to be supported by strong tests against observed data. Otherwise, we are left with the concern that model results may be just modelling artifacts that may not correspond to reality. In particular, your claim is hard to accept that species movements will be restricted to a few hundred meters over 100 years through dispersal limitations. While the other extreme of unlimited dispersal is clearly also not correct, the true movement of species will probably lie between these extremes as studies of changes in species distributions over recent times have confirmed.*  

---

# 10. Have in mind illustration of the results

<div style='text-align:center;'>
<img src="assets/img/drawing.jpg" width="650px"></img>
</div>

--- 

# Uncertainty

## Parameters

<div style='text-align:center;'>
<img src="assets/img/clark.png" width="325px"></img>
</div>

--- 

# Uncertainty

## Error propagation

<div style='text-align:center;'>
<img src="assets/img/lyapunov.png" width="550px"></img>
</div>

--- 

# Uncertainty

## Structural

<div style='text-align:center;'>
<img src="assets/img/ipcc.jpg" width="650px"></img>
</div>

--- 

# How to control for uncertainty

## The modeling loop

<div style='text-align:center;'>
<img src="assets/img/dietze.png" width="850px"></img>
</div>
