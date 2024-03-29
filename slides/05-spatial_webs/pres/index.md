---
title       : "Spatial food webs"
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

--- &twocol

# The challenge of spatial food webs

*** =left

<div style='text-align:center;'>
<img src="assets/img/cod.png" width="450px"></img>
</div>

*** =right

<div style='text-align:center;'>
<img src="assets/img/network2.png" width="450px"></img>
</div>

---

# At the crossroad of network and metacommunity theory

<div style='text-align:center;'>
<img src="assets/img/spatial_networks.png" width="800px"></img>
</div>

---

# Indirect spatial interactions

<div style='text-align:center;'>
<img src="assets/img/knight.png" width="600px"></img>
</div>

<div style='text-align:center;'>
Knight et al. 2004. Nature
</div>

---

# Spatial cascades

<div style='text-align:center;'>
<img src="assets/img/garcia.png" width="600px"></img>
</div>

<div style='text-align:center;'>
Garcia et al. 2019. Ecology
</div>

---

# Spatial variability of ecological networks

<div style='text-align:center;'>
<img src="assets/img/gravel2018.png" width="500px"></img>
</div>

<div style='text-align:center;'>
Gravel et al. 2018. Ecography
</div>

---

# Spatial variability of ecological networks

<div style='text-align:center;'>
<img src="assets/img/albouy2019.png" width="600px"></img>
</div>

<div style='text-align:center;'>
Albouy et al. 2019. Nature Ecology Evolution
</div>

---

# Food webs and biodiversity changes

<div style='text-align:center;'>
<img src="assets/img/albouy2014.png" width="500px"></img>
</div>

<div style='text-align:center;'>
Albouy et al. 2014. Global Change Biology
</div>

--- .transition

# Could we find simple (and general) rules to understand spatial structure and dynamics of ecological networks?

--- &twocol

# Basic ingredients

*** =left

- Metapopulation dynamics
- A predator requires a prey to colonize a patch
- A predator requires a prey to persist in a patch

*** =right

<img src="assets/img/archipelago.png" width="350px"></img>

---

# The concept of spatial inefficiency

<div style='text-align:center;'>
<img src="assets/img/spatial_inefficiency.png" width="750px"></img>
</div>

<div style='text-align:center;'>
Holt, R.D. (1996). Food webs in space: an island biogeographic perspective. In:
Food Webs: Contemporary Perspectives, Polis & Winemiller.
</div>

---

# The concept of spatial inefficiency

## First trophic level : 

<div style='text-align:center;'>
$\frac{dp_1}{dt} = c_1p_1(1-p_1) - e_1p_1$
</div>

Which yields : 

<div style='text-align:center;'>
$p_1^* = 1 - e_1/c_1$
</div>

---

# The concept of spatial inefficiency

## Second trophic level : 

<div style='text-align:center;'>
$\frac{dp_2}{dt} = c_2p_2(p_1-p_2) - e_2p_2$
</div>

Which yields : 

<div style='text-align:center;'>
$p_2^* = p_1 - e_2/c_2$
</div>

--- .transition

# Keep this conclusion in mind for birds requiring a particular forest type. The bird may disappear, even if there is still some favourable habitat. 

---

# Fundamental constraint: prey diversity

<div style='text-align:center;'>
<img src="assets/img/prey_diversity.png" width="750px"></img>
</div>

<div style='text-align:center;'>
Gravel et al. 2011. Eco Lett
</div>

--- .transition

# Highly specialized species are more vulnerable than generalists

---

# Fundamental constraint: prey co-distribution

<div style='text-align:center;'>
<img src="assets/img/prey_codistribution.png" width="650px"></img>
</div>

<div style='text-align:center;'>
Gravel et al. 2011. Eco PLOS One
</div>

--- .transition

# Understanding co-occurrence is key for higher trophic levels

--- .transition

# What are the properties emerging from these simple rules?

--- &twocol

# Island Biogeography Theory

*** =left

<div style='text-align:center;'>
<img src="assets/img/tib.png" width="450px"></img>
</div>

*** =right

<div style='text-align:center;'>
<img src="assets/img/islands.png" width="350px"></img>
</div>

---

# Island Biogeography Theory

## Assumptions : 

- A species can only invade an island if it as at least one prey present on the island
- A species that loses its last prey on the island goes extinct

<div style='text-align:center;'>
	$\frac{dp_g}{dt} =	 c(1-p_g)q_g - (e + \epsilon_g)p_g$
</div>

Where : 
- $q_g$ : probability that a species has a prey present on the island
- $\epsilon_g$: rate a predator loses its last prey on the island

---

# Equilibrium species richness

<div style='text-align:center;'>
<img src="assets/img/ttib.png" width="500px"></img>
</div>

<div style='text-align:center;'>
Gravel et al. 2011. Eco Lett
</div>

---

# Network assembly dynamics

<div style='text-align:center;'>
<img src="assets/img/ttib_dynamics.png" width="500px"></img>
</div>

<div style='text-align:center;'>
Gravel et al. 2011. Eco Lett
</div>

--- &twocol

# Local-regional feedback

*** =left

<div style='text-align:center;'>
<img src="assets/img/trophicSAR.png" width="450px"></img>
</div>

*** =right

<div style='text-align:center;'>
<img src="assets/img/connectance_area.png" width="450px"></img>
</div>

---

# Empirical support

<div style='text-align:center;'>
<img src="assets/img/occupancy.png" width="500px"></img>
</div>

<div style='text-align:center;'>
Gravel et al. 2011. Eco Lett
</div>

---

# Further developments

- Finer aspects of network structure : Massol et al. 2017. Advances in Ecological Research
- Addition of allometric constraints : Jacquet et al. 2017. Ecology Letters
- Other types of interactions : Cazelles et al. 2015. Ecography
- Co-occurrence and network structure : Cazelles et al. 2016. Theoretical Ecology
- Metacommunity dimensions : Gravel & Massol. 2019 in Theoretical Ecology. 

---

# And now .... 

## We want to couple bicknell's thrush (and others) to forest dynamics

<div style='text-align:center;'>
<img src="assets/img/bicknell.png" width="500px"></img>
</div>

---

# And now .... 

## We want to couple bicknell's thrush with forest dynamics

- The best would be to have a colonization/extinction model for birds
- Make colonization conditional on forest type
- Run the two models simultaneously
- We would obtain something like :

<div style='text-align:center;'>
$p_{bicknell}^* = p_{conifers} - e_{bicknell}c_{bicknell}$
</div>


---

# And now .... 

## Without dynamical data for birds

- We will derive $p_{bicknell}^*$ directly from the data with a SDM
- Couple models sequentially :
	1. Evaluate the SDM
	2. Run the forest simulation model
	3. Predict with the SDM the expected bird distribution using future climate & future forest composition as predictors
- Repeat the whole procedure for all bird species
