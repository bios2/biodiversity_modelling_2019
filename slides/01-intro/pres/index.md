---
title       : "Day 1. Introduction to biodiversity modeling"
subtitle    : "https://github.com/bios2/biodiversity_modelling_2019.git"
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

# Who are you and who is your neighbour ?

--- 

# Why are you here ?

- Forced by your supervisor ?
- You need those skills for your research ?
- You want to diversify your expertise ?
- It may be useful for the job market ?
- You are finishing your transformation into a geek
- All of the above

---

# Biodiversity assessments for policy makers

<div style='text-align:center;'>
<img src="assets/img/mea.png" height="500px"></img>
</div>

---

# Biodiversity assessments for policy makers

<div style='text-align:center;'>
<img src="assets/img/ipcc_report.png" height="500px"></img>
</div>

---

# Biodiversity assessments for policy makers

<div style='text-align:center;'>
<img src="assets/img/LPI.jpg" height="500px"></img>
</div>

---

# Biodiversity assessments for policy makers

<div style='text-align:center;'>
<img src="assets/img/ipbes.jpg" height="500px"></img>
</div>

---

# Dashboard for biodiversity

<div style='text-align:center;'>
<img src="assets/img/ohi.png" height="500px"></img>
</div>

---

# Biodiversity scenarios


**DEFINITION**: 

*Quantitative estimates of the future trajectories of biodiversity* [Pereira et al. 2010]

---

# Biodiversity scenarios

<div style='text-align:center;'>
<img src="assets/img/pereira1.png" height="500px"></img>
</div>

---

# Metrics of biodiversity changes

- Species extinctions
- Species abundance and community structure
- Habitat loss and degratation
- Shifts in the distribution of species and biomes

---

# Suite of modeling techniques

<div style='text-align:center;'>
<img src="assets/img/pereira2.png" height="500px"></img>
</div>

---

# Species extinction

<div style='text-align:center;'>
<img src="assets/img/pereira3.png" height="500px"></img>
</div>

---

# Species extinction
## Differences among scenarios

- Land use and climate change scenarios
- Lack of understanding species ecology (e.g. migration)
- Differences between modeling approaches

---

# Conclusion

Scenarios must move beyond illustrating the potential impacts of global change on biodiversity toward more integrated approaches that account for the feedbacks that link environmental drivers, biodiversity, ecosystem services, and socioeconomic dynamics.

---

# Essential biodiversity outputs ?

<div style='text-align:center;'>
<img src="assets/img/ebv.png" height="500px"></img>
</div>

---

# Assessing biodiversity changes

<div style='text-align:center;'>
<img src="assets/img/vellend2013.png" height="500px"></img>
</div>

---

# Conclusion

This requires training !!!

--- .transition

# The program for the week

--- 

# General objective

We are aware that the background, expertise and interest of everyone is very different. The diversity of techniques and approaches is almost as diverse as natural systems. So, our general goal this week is that everyone learns and make some progress in their understanding of biodiversity modeling.

--- 

# Specific objectives

1. Learn about and use different modeling techniques (statistical, differential equations, stochastic simulations)

2. Use climate change scenarios as input to biodiversity models

3. Use empirical data to perform biodiversity scenarios

4. Understand the limits and the uncertainty in biodiversity projections

5. Modeling is not only techniques, it's a state of mind and an approach to learn about a system

--- 

# Content 

1. Biodiversity and climate modeling
2. Species distribution
3. Communities
4. Spatial dynamics
5. Model integration and optimization

--- 

# Typical day

09h00 - 12h00	Lecture & exercises

12h00 - 13h00	Lunch

13h00 -	16h00	Lecture & exercises

16h00 - 18h00	Work on integrative project

19h00 - 20h00	Diner

20h00  >		Finish the day's project

--- 

# Integrative project

<div style='text-align:center;'>
<img src="assets/img/bioclim.png" height="500px"></img>
</div>

--- 

# Integrative project

<div style='text-align:center;'>
<img src="assets/img/birds.jpg" height="450px"></img>
</div>

--- 

# Integrative project

<div style='text-align:center;'>
<img src="assets/img/bicknell.png" height="450px"></img>
</div>

--- 

# Integrative project

## Model comparison to evaluate structural uncertainty

1. Macroecological model of bird species richness distribution
2. Collection of species distribution models
3. Joint species distribution models
4. State & transition model for forest habitats
5. Species distribution models constrained by habitat availability

--- 

# Evaluation

- Summary report of the integrative project 
- Short format (Nature/Science style, max 2000 words + Methods)
- Team work (2-4)
- Due September 27th, 2019

--- 

# Evaluation
## Criteria

- Execution (40 %)
- Interpretation (30 %)
- Format (20 %)
- Originality (10 %)

--- .transition

# Case study

---

# Why Thomas et al. 2004 ?

<div style='text-align:center;'>
<img src="assets/img/thomas1.png" height="300px"></img>
</div>

---

# Research objective 

Provide a first pass estimate of extinction probabilities (species "commited to extinction") associated with climate change scenarios for 2050.

---

# Methods
## Data

- Queensland: mammals (11), birds (13), reptiles (18)
- Australia: butterflies (24)
- Mexico: mammals (96), birds (186) and butterflies (41)
- South Africa: mammals (5), birds (5), reptiles (26) and butterflies (4)
- Europe: birds (34)
- Brazil : plants (163)
- South Africa : protoaceae (243)
- Europe : plants (192)
- Amazon : plants (9)

---

# Methods
## Species distribution models

- BIOCLIM
- GARP
- PCA / climate matching
- Locally wieghted regression
- GAM 
- IMAGE 2
- Similarity model constrained by a rectilinear envelope

---

# Methods
## Estimating species extinction

Method 1 : $E_1 = 1 - (\sum A_{new}/\sum A_{original})^z$
(overal change in area) 

Method 2 : $E_2 = 1 - [(1/n)(\sum A_{new}/A_{original})^z]$
(average proportional change in area)

Method 3 : $E_3 = (1/n) \sum (1-A_{new}/\sum A_{original})^z$
(specific change in area)

---

# Results

<div style='text-align:center;'>
<img src="assets/img/thomas2.png" height="500px"></img>
</div>

---

# Conclusions

- Projections vary with methods, organisms and areas of the world
- Comparison with extinctions from habitat losses only reveals that some areas have larger climate change impacts, others are driven by land-use changes

--- .transition

# Reactions ?

---

# Commentary by Thuiller et al.
## Two additional sources of uncertainty

- Different SDMs
- Link between area reduction and extinction risk is questionable

<div style='text-align:center;'>
<img src="assets/img/thuiller.png" height="300px"></img>
</div>

--- .transition

# How far can we go with such scenarios ?

--- .transition

# What could we do, 15 years later ?

--- .transition

# What to put into biodiversity models ?

--- 

# Connolly et al. 2017
## Phenomenological models : statistical models to reproduce empirical relationships 

<div style='text-align:center;'>
<img src="assets/img/mckenney.png" height="400px"></img>
</div>

--- 

# Connolly et al. 2017
## Process-based models : models that characterize changes in a system’s state as explicit functions of the events that drive those state changes

<div style='text-align:center;'>
<img src="assets/img/talluto2.png" height="350px"></img>
</div>

--- 

# Connolly et al. 2017
## Mechanistic models : a characterization of the state of a system as explicit functions of component parts and their associated actions and interactions

<div style='text-align:center;'>
<img src="assets/img/sortie.png" height="350px"></img>
</div>

--- 

# Urban et al. 2016
## Elements to include

<div style='text-align:center;'>
<img src="assets/img/urban.png" height="450px"></img>
</div>

--- 

# Urban et al. 2016
## Failure to include processes

<div style='text-align:center;'>
<img src="assets/img/vissault.png" height="450px"></img>
</div>

--- 

# Urban et al. 2016
## Too many processes ?

--- 

# Global Ecosystem models

<div style='text-align:center;'>
<img src="assets/img/purves.png" height="500px"></img>
</div>

--- 

# Global Ecosystem models

<div style='text-align:center;'>
<img src="assets/img/harfoot1.png" height="450px"></img>
</div>
