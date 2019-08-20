---
title       : "Day2. Species distribution modelling on presence-only data"
subtitle    : "https://github.com/bios2/biodiversity_modelling_2019.git"
author      : "F. Guillaume Blanchet"
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

# Important considerations

Presence-only data are likely the most challenging data to use and model because they carry very little information.

The species data we have access to when dealing with presence-only data are coordinate of points, That's it !

<div style='text-align:center;'>
<img src="assets/img/presence_only/GBIF_bird.png" height="350px"></img>
</div>

---

# Technique to model presence-only data

#### Envelope model
- BIOCLIM (Busby 1991)

#### Distance model
- DOMAIN (Carpenter et al. 1993)
- LIVES (Elith et al. 2006)

These three approaches have been shown to perform overall poorly by Elith et al. (2006)

We will not discuss more about these approach in the course.

---

# Technique to model presence-only data

#### Point process models (Illian et al. 2008)
- MAXENT (Phillips et al. 2006)
- Resource selection functions (McDonald et al. 2013 for a review)
- Poisson regression model
- Point process models

MAXENT, Resource selection functions and poisson regression models have been shown to be the proportionally equivalent (Renner and Warton 2013, Warton and Aarts 2013) and thus related to Point process model.

In this section part we will focus on point process model. Specifically, we will go over the work of Renner et al. (2015).

---

# Point process models

Point process models are designed to estimate <font color="blue">where</font> the points (i.e. indiviual of a species) are to be observed. 

They are based on:
- The spatial locations of the points 
- The number of points (i.e. species observation) occurring 
- A set of explanatory variables found in the study region

---

# Point process models

## The intensity is the key

The main goal of a point process model is to measure the <font color="blue" size = 6>intensity</font>, not the probability of occurrence of a species.

The intensity a point process is a function of:
- The distribution of sampled individuals in space 
- The spatial units of measurements

## <font color="red">Warning</font>

The estimated intensity resulting from a point process model almost always reflect the intensity of the <font color="blue">sampled</font> individuals. 

---

# Inhomogeneous Poisson point process models

A Poisson model (or Poisson regression) aims at modelling the intensity of a process by accounting different factors that are assumed to influence this process. 

It is based on counts of individuals.

## Asumptions of the inhomogeneous Poisson point process models

### Individuals are independent of each other 
This implies that all individuals considered in a region follow a Poisson random variable

### The estimated intensity varies spatially
This implies that the intensity varies according to environmental conditions.

---

# Inhomogeneous Poisson point process models

## Checking for independence - Ripley's K-function

Measure the average number of individual found within a distance $r$ from a typical point $s$ resulting from a particular point process. 

<div style='text-align:center;'>
<img src="assets/img/presence_only/Ripley_k_illustration.png" height="320px"></img>
</div>


In R it can be calculated using the `Kest` function in `spatstat` package.

---

# Inhomogeneous Poisson point process models

## Checking for independence - Ripley's K-function

It is calculated as 

$$K(r) = 2\pi r^{-2}\int_0^r\lambda(s) dr$$
$r$ - the radius of a circle

$\int_0^r\lambda(s) dr$ - sum of all individuals $s$ in a circle of radius $r$ given the point process $\lambda(s)$

- $K(r) > \pi r^{-2}$ : The point pattern is assumed to be aggregated

- $K(r) = \pi r^{-2}$ : The point pattern is assumed to be random

- $K(r) < \pi r^{-2}$ : The point pattern is assumed to be regular

---

# Inhomogeneous Poisson point process models

## Accounting for variation in spatial intensity

In the context of point process model, a Poisson regression can be defined as follow
$$\ln \lambda(s) = \mathbf{x}(s)^T\beta$$
$\lambda(s)$ - A point process for location $s$

$\mathbf{x}(s)$ - Explanatory variables measured at location $s$

$\beta$ - Parameters associated to the explanatory variables

$T$ - Transpose of a matrix

This model assumes a log-linear relationship between the point process and the explanatory variables. 

---

# Inhomogeneous Poisson point process models

## Applying an inhomogeneous Poisson point process models

1. Break the data into grid cells
2. Fit a Poisson log-linear model to the count of the number of individuals in each cell. The fitted Poisson model could be a:
  - A linear regression
  - A polynomial regression
  - An additive model
  - etc.

That's it ! <img src="assets/img/presence_only/face-with-party-horn-and-party-hat_1f973.png" align="middle" height="100px">

---

# Inhomogeneous Poisson point process models

## Applying an inhomogeneous Poisson point process models

1. Break the data into grid cells
2. Fit a Poisson log-linear model to the count of the number of individuals in each cell. The fitted Poisson model could be a:
  - A linear regression
  - A polynomial regression
  - An additive model
  - etc.

That's it ! <img src="assets/img/presence_only/face-with-party-horn-and-party-hat_1f973.png" align="middle" height="100px">
Wrong. There are a number of problem with this procedure.


---

# Inhomogeneous Poisson point process models

## 1. Not a good break

Important information can be lost when breaking the data into grid cells
 

<div style='text-align:center;'>
  <img src="assets/img/presence_only/disappointed-but-relieved-face_1f625.png" align="middle" height="80px">
</div>


---

# Inhomogeneous Poisson point process models

## 1. Not a good break

Important information can be lost when breaking the data into grid cells
 

<div style='text-align:center;'>
  <img src="assets/img/presence_only/disappointed-but-relieved-face_1f625.png" align="middle" height="80px">
</div>

## 2. A problem of independence

- The intensity in nearby regions are <font color = "blue">completely</font> explained by the explanatory variables This is almost never the case.

- Spatial aggregation resulting from dispersal or social behaviour is not accounted for

<div style='text-align:center;'>
  <img src="assets/img/presence_only/crying-face_1f622.png" align="middle" height="80px">
</div>

---

# Inhomogeneous Poisson point process models

## 3. A problem of absences

Recall that the data used only informs us about where individuals of a species are, but we know <font color="red">nothing</font> about where they are not found.

<div style='text-align:center;'>
  <img src="assets/img/presence_only/loudly-crying-face_1f62d.png" align="middle" height="100px">
</div>

---

# Inhomogeneous Poisson point process models


## 3. A problem of absences

Recall that the data used only informs us about where individuals of a species are, but we know <font color="red">nothing</font> about where they are not found.

<div style='text-align:center;'>
  <img src="assets/img/presence_only/loudly-crying-face_1f62d.png" align="middle" height="100px">
</div>

How can we solve the problems with inhomogeneous Poisson point process models ?

<div style='text-align:center;'>
  <img src="assets/img/presence_only/thinking-face_1f914.png" align="middle" height="100px">
</div>

---

# Inhomogeneous Poisson point process models


## 3. A problem of absences

Recall that the data used only informs us about where individuals of a species are, but we know <font color="red">nothing</font> about where they are not found.

<div style='text-align:center;'>
  <img src="assets/img/presence_only/loudly-crying-face_1f62d.png" align="middle" height="100px">
</div>

How can we solve the problems with inhomogeneous Poisson point process models?

<div style='text-align:center;'>
  <img src="assets/img/presence_only/thinking-face_1f914.png" align="middle" height="100px">
</div>


Let's delve a little deeper into the point process literature.

---

# Gibbs point process

The Gibbs point process model is an inhomogeneous Poisson point process model that relaxes the assumption of independence.

## Assumption

- There are interactions between sets of points within a certain distance of each other.

---

# Gibbs point process

## The Gibbs point process model

$$\ln \lambda(s) = \mathbf{x}(s)^T\beta + t_s(\mathbf{s}_P)\theta$$

$t_s(\mathbf{s}_P)$ - The area of a disc of radius $r$ centred at location $s$ that does not intersect with similar discs centred around each of the presence points $\mathbf{s}_P$ .

$\theta$ - Interaction parameter (if positive, the points are clustered)

$\lambda(s)$ - A point process for location $s$

$\mathbf{x}(s)$ - Explanatory variables measured at location $s$

$\beta$ - Parameters associated to the explanatory variables

$T$ - Transpose of a matrix

---

# Gibbs point process

## The Gibbs point process model

$$\ln \lambda(s) = \mathbf{x}(s)^T\beta + t_s(\mathbf{s}_P)\theta$$
$t_s(\mathbf{s}_P)$ - The area of a disc of radius $r$ centred at location $s$ that does not intersect with similar discs centred around each of the presence points $\mathbf{s}_P$ .

$\theta$ - Interaction parameter (if positive, the points are clustered)

---

# Gibbs point process

## The area-interaction processes models

- Assume interaction among all points within a distance of $2r$.
- Can model clustering
- Can model inhibition (regular patterns)
- Biological interpretable (e. g. dispersal limitation)

## Other Gibbs point process 
- Strauss process
- Pairwise soft core interaction
- Diggle-Gratton potential
- Geyer's saturation process

---

# Spatial log-Gaussian Cox process

This is in essence a generalized linear mixed model point process with a normally distributed random intercept. It is another variant of an inhomogeneous Poisson point process models.

## Assumption

- The intensity among the points is a function of the explanatory variables and of a stochastic Gaussian process
- The stochastic Gaussian process captures all the spatial dependence of the species not captured the other explanatory variables


---

# Spatial log-Gaussian Cox process
## Spatial log-Gaussian Cox process model

$$\ln \lambda(s) = \mathbf{x}(s)^T\beta + \xi(s)$$

$\xi(s)$ -  a spatial Gaussian process

$\lambda(s)$ - A point process for location $s$

$\mathbf{x}(s)$ - Explanatory variables measured at location $s$

$\beta$ - Parameters associated to the explanatory variables

$T$ - Transpose of a matrix

---

# Spatial log-Gaussian Cox process
## Spatial log-Gaussian Cox process model

$$\ln \lambda(s) = \mathbf{x}(s)^T\beta + \xi(s)$$

$\xi(s)$ -  a spatial Gaussian process

This spatial Gaussian process has
  - A mean of 0
  - A covariance function that depends on the distance between observations
  
A such, closer observations are assumed to be more positively correlated.

Another way to see $\xi(s)$, is as a latent variable associated to the distribution of the species.


---

# Using presence-only data to map a species

This was a lot of theory...

<div style='text-align:center;'>
  <img src="assets/img/presence_only/face-with-uneven-eyes-and-wavy-mouth_1f974.png" align="middle" height="100px">
</div>

---

# Using presence-only data to map a species

This was a lot of theory...
<div style='text-align:center;'>
  <img src="assets/img/presence_only/face-with-uneven-eyes-and-wavy-mouth_1f974.png" align="middle" height="100px">
</div>

#### Using Gibbs and log-Gaussian Cox process models we now know how to:
- Use presence-only data without having break the data into grid cells
<div style='text-align:center;'>
  <img src="assets/img/presence_only/smiling-face-with-open-mouth_1f603.png" align="middle" height="100px">
</div>

---

# Using presence-only data to map a species

This was a lot of theory...
<div style='text-align:center;'>
  <img src="assets/img/presence_only/face-with-uneven-eyes-and-wavy-mouth_1f974.png" align="middle" height="100px">
</div>

#### Using Gibbs and log-Gaussian Cox process models we now know how to:
- Use presence-only data without having to break the data into grid cells
<div style='text-align:center;'>
  <img src="assets/img/presence_only/smiling-face-with-open-mouth_1f603.png" align="middle" height="100px">
</div>
- Better deal with the non-independence between points.
<div style='text-align:center;'>
  <img src="assets/img/presence_only/smiling-face-with-open-mouth-and-smiling-eyes_1f604.png" align="middle" height="100px">
</div>

---

# Using presence-only data to map a species

This was a lot of theory...
<div style='text-align:center;'>
  <img src="assets/img/presence_only/face-with-uneven-eyes-and-wavy-mouth_1f974.png" align="middle" height="100px">
</div>
#### However, the Gibbs and log-Gaussian Cox process models do not solve the problem of absences
<div style='text-align:center;'>
  <img src="assets/img/presence_only/face-with-pleading-eyes_1f97a.png" align="middle" height="100px">
</div>

---

# Using presence-only data to map a species

This was a lot of theory...
<div style='text-align:center;'>
  <img src="assets/img/presence_only/face-with-uneven-eyes-and-wavy-mouth_1f974.png" align="middle" height="100px">
</div>
#### However, the Gibbs and log-Gaussian Cox process models do not solve the problem of absences
<div style='text-align:center;'>
  <img src="assets/img/presence_only/face-with-pleading-eyes_1f97a.png" align="middle" height="100px">
</div>
We have to continue with the theory 
<div style='text-align:center;'>
  <img src="assets/img/presence_only/face-screaming-in-fear_1f631.png" align="middle" height="100px">
</div>

---

# Dealing with absences

To understand how to deal with absences, we have to first learn about how point process model are estsimated

#### Log-likelihood function of a Poisson point process model

$$l(\beta; \mathbf{s}_P) = \sum_{i=1}^m\ln\lambda(s_i)-\int_A\lambda(s) ds$$

$\beta$ - Parameters associated to the explanatory variables

$\mathbf{s}_P$ - The presence points

$\lambda(s)$ - A point process for location $s$

$A$ - Study region

---

# Dealing with absences

To understand how to deal with absences, we have to first learn about how point process model are estsimated

#### Log-likelihood function of a Poisson point process model

$$l(\beta; \mathbf{s}_P) = \sum_{i=1}^m\ln\lambda(s_i)-\int_A\lambda(s) ds$$

### <font color = "red">Problem</font>

This likelihood function cannot be solve because the integral does not have closed form

It has to be approximated numerically. In mathematical terms this is known as <font color = "blue">quadrature</font>.


---

# Dealing with absences

Using quadrature, the log-likelihood function of a Poisson point process model can be approximated as

$$l(\beta; \mathbf{s}_P) \approx \sum_{j=1}^{m+n}w_j\left(y_j\ln\lambda(s_j)-\lambda(s_j)\right)$$

$\beta$ - Parameters associated to the explanatory variables

$\mathbf{s}_P = \{s_{1},\dots,s_{m}\}$ - Presence points

$\mathbf{s}_0 = \{s_{m+1},\dots,s_{m+n}\}$ - Quadrature points

$\lambda(s)$ - A point process for location $s$

$\mathbf{w} = \{w_{1},\dots,w_{m+n}\}$ - Quadrature weights. A weight given to all points.

For presence $y_j = 1/w_j$ and for quadrature points $y_j = 0$ 

---

# Dealing with absences

## Quadrature weights

Using quadrature weights $w_j$ are the key to estimate a Poisson point process model log-likelihood. 

Quadrature weights are:
- A spatial scaling so that the intensity of the point process ($\lambda$) has spatial unit as opposed to observational units
- Conceptually, they quantify the neighbourhood area around the point $s_j$ after partitionning the study area into neighbourhood around each point

Using quadrature weights allows points process models to be estimate using standard generalized linear models.

---

# Dealing with absences

## Choosing quadrature points

### A solution?

Treat the "background" as a set of absences (0s). 

Background points are:
- Usually sampled randomly in the area considered
- Usually 10 000 points are sampled (default settings in various softwares)

---

# Dealing with absences

## Choosing quadrature points

### A <font color="red">bad</font> solution!

- Choosing background points location and number is mostly done arbitrarly 
- When the number of background points changes the results changes
- When the location of background point changes the results changes

In other words, the result are scale dependent. 
<div style='text-align:center;'>
  <img src="assets/img/presence_only/serious-face-with-symbols-covering-mouth_1f92c.png" align="middle" height="100px">
</div>

---

# Dealing with absences

## Choosing quadrature points

If we rethink the problem in the context of quadrature, quadrature points need to be chosen to estimate the integral of the log-likelihood function.

What becomes important is to answer the following questions:
- How many quadrature points need to be selected?
- Where should we place them?

### Particularities of quadrature points

The location and number of presence points are <font color = "red" size = 6>irrelevant</font> !

---

# Dealing with absences

## Where to place quadrature points?

- On a regularly spaced grid
- Randomly
- By increasing the density of points where the environmental variability is high

---

# Dealing with absences

## How many quadrature points?

This will depend on the data. So there are no single answers.

## An example from Renner et al. (2015)
Procedure used:
- Locate quadrature points on a grid of 16 $\text{km}^2$ 
- Estimate ikelihood
- Locate quadrature points on a grid with half the mesh size (8 $\text{km}^2$)
- Estimate likelihood

If the likelihood converged (stops increasing), stop, otherwise continue.

---

# Dealing with absences

## How many quadrature points?

This will depend on the data. So there are no single answers.

## An example from Renner et al. (2015)

<div style='text-align:center;'>
  <img src="assets/img/presence_only/Renner_et_al_2a.png" align="middle" height="320px">
</div>

---

# Dealing with absences

## How many quadrature points?

This will depend on the data. So there are no single answers.

## Another example from Renner et al. (2015)
Procedure used:
- Randomly sample quadrature points 30 times 
- Estimate the log-likelihood for each random sample
- Perform this procedure for an increasing number of quadrature points

--- 

# Dealing with absences

## How many quadrature points?

This will depend on the data. So there are no single answers.

## Another example from Renner et al. (2015)

<div style='text-align:center;'>
  <img src="assets/img/presence_only/Renner_et_al_2b.png" align="middle" height="320px">
</div>

--- 

# Dealing with absences

## A quick way to find if enough quadrature points were used

The model standard error can be very useful to assess whether enough quadrature point were used. It can calculated as follow:

1. Run a model with $n$ quadrature points (say 10 000)
2. Calculate the estimated intensity for each quadrature point
3. Calculate the standard deviation ($s$) of the previously calculated estimated intensity
4. Find the area $A$ of the study region
5. Calculate the standard error of the model

$$\sigma = \frac{As}{\sqrt{n}}$$

---

# Dealing with absences

## A quick way to find the number quadrature points to use

Using the previous equation, we can make a calculated guess of the number of quadrature points required assuming a specific model. This can be done as follow

1. Define the desired standard error within which the true log-likelihood is located.
2. Run a model point process model
3. Calculate the estimated intensity for each quadrature point
4. Calculate the standard deviation ($s$) of the previously calculated estimated intensity
5. Find the area $A$ of the study region
6. Calculate the number of quadrature points that would be required

$$n = \frac{A^2s^2}{\sigma^2}$$

---

# General guidelines about point process models

- The number of quadrature points depends on the original data
- Often more quadrature points are need when the environment is measured at high resolution
- Often more quadrature points are need when the survey area is broad
- After having chosen the number of quadrature points, we should <font color ="red" size = 6>not</font> play with it
- Bias should be corrected by specifying covariates in the model. For example, by adding
  - Distance from main road
  - Distance from urban centers
  - Landscape features
- Attaching weights to quadrature points is essential to have a scale-invariant estimate of the log-likelihood


