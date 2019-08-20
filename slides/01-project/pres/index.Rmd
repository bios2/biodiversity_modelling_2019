---
title       : "Integrative project"
subtitle    : "https://econumuds.github.io/BIO109/cours1/"
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
# Integrative project

## Objective : evaluate the structural uncertainty in predictions of biodiversity under climate change in Québec. 

1. Macroecological model of bird species richness distribution
2. Collection of species distribution models
3. Joint species distribution models
4. State & transition model for forest habitats
5. Species distribution models constrained by habitat availability

--- 

# Input data

- Bird occurrence data from GBIF on a 10km raster
- Bioclimatic variables
- Spatial coordinates
- Current forest cover type
- Climate change projections for 2085-2100

--- 

# Day 1. Phenomenological model

## Objective : use a phenomenological model of bird species richness to predict future changes in biodiversity distribution across Québec.

Steps : 

1. Prepare the data
2. Decide which statistical model to use
3. Decide which explanatory variables to pick
4. Run the statistical analysis
5. Project species richness under future climatic conditions
6. Evaluate biodiversity changes and illustrate the results
7. Identify assumptions and limits to the modeling approach

---

# Day 2. Species distribution models

## Objective : use species distribution models of species richness to predict future changes in biodiversity distribution across Québec

Steps :

1. Decide conditions for running SDMs
2. Evaluate models for every species
3. Compute the expected species richness and compare it to observations
4. Run climate change scenario to evaluate future species distribution
5. Compute the expected species richness
6. Evaluate biodiversity changes and illustrate the results 
7. Identify assumptions and limits to the modeling approach

---

# Day 3. Joint Species Distribution models

## Objective : use joint species distribution models of species richness to predict future changes in biodiversity distribution across Québec

1. Decide conditions for running JSDM
2. Evaluate the model 
3. Compute the expected species richness and compare it to observations
4. Run climate change scenario to evaluate future species distribution
5. Compute the expected species richness
6. Evaluate biodiversity changes and illustrate the results 
7. Interprete the covariance matrix 
8. Identify assumptions and limits to the modeling approach

---

# Day 4. Spatial modeling

## Objective : use a state and transition model to project future distribution of temperate forests across Québec

1. Run the model under actual climatic conditions to get starting conditions
2. Run the model with simulated climate change
3. Evaluate biodiversity changes and illustrate the results
4. Identify assumptions and limits to the modeling approach

* if time allows, modify the source code to account for different dispersal scenarios and perform a sensitivity analysis

---

# Day 5. Model integration 

## Objective : develop a hybrid model combining the state and transition model and SDMs to project future bird distribution accounting for spatial mismatch of forest composition

1. Run SDMs for every species accounting for the forest type
2. Couple the state and transition model and SDMs to predict the expected bird distribution conditional on the state of the forest
3. Run the model under climate change scenario
4. Evaluate biodiversity changes and illustrate the results
5. Identify assumptions and limits to the modeling approach
6. Compare the expected biodiversity changes using models from days 1-5 and evaluate the structural uncertainty 



