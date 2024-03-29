---
title       : "Day 2. Species distribution modelling using presence-absence data"
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

# Introduction
## What makes a species occur in a particular location?

<div style='text-align:center;'>
<img src="assets/img/intro/Brownbear_crop.jpg" height="400px"></img>
</div>


---

# Introduction
## What makes a species occur in a particular location?

<div style='text-align:center;'>
<img src="assets/img/intro/Taiga_Landscape_in_Canada.png" height="400px"></img>
</div>


---

# Introduction
## What makes a species occur in a particular location?
<div style='text-align:center;'>
<img src="assets/img/intro/Brownbearwithsalmoneggs.png" height="400px"></img>
</div>


---

# Introduction
## What makes a species occur in a particular location?
<div style='text-align:center;'>
<img src="assets/img/intro/Grizzlymumcubs-c01.png" height="400px"></img>
</div>

---

# Introduction
## What do we want to do when modelling species distribution?
The goal of an SDM is to find out where and/or when a species occur.

<div style='text-align:center;'>
<img src="assets/img/intro/GB_Historic_Distribution_NA_wordlBase.jpg" height="380px"></img>
</div>

Often maps are the only output of SDMs but they should not be!

---

# Small quiz (what is missing ?)

## Historical and current grizzly bear range in North America (USGS)

<style type="text/css">
#wrap {
   width:1200px;
   margin:0 0;
}
#left_col {
   float:left;
   width:600px;
}
#right_col {
   float:right;
   width:600px;
}
</style>

<div id="wrap">
    <div id="left_col">
      <img src="assets/img/intro/GB_Historic_Distribution_NA_wordlBase.jpg" height="380px"></img>
    </div>
    <div id="right_col">
    </div>
</div>

## Detailed Description:

- Map showing historical and current grizzly bear range in North America.

## Details

- Image Dimensions: 3085 x 3231
- Date Taken: Thursday, November 30, 2000

---

# Solution to the quiz

- Information on how the map was built 
  - Data used
  - Type of model used to construct the map
  - etc. 

- Statistics describing the quality of the model used to build the map
  - Measure of variance explained
  - Confidence interval of the model
  - etc.
- Details about how the map shown was obtained
- (Un)certainties about the constructed map

---

# Question to ask yourself when modelling a species

## 1. Why do you want to model the distribution of the species?

- To know where the species can be found now?
- To know where the species was found in the past?
- To know where the species will be found?
- To better understand the factor influencing the species distribution?
- To protect the species?
- To eradicate the species?
- etc.

---

# Question to ask yourself when modelling a species

## 2. What species data do you have to construct your model?

- Presence-only data for the species of interest?
- Presence-absence data for the species of interest?
- Presence-absence data for the multiple species?

---

# Question to ask yourself when modelling a species

## 3. What other information do you have to construct your model?

- Explanatory variables (climate, soil, ...)
- Expert maps
- Sampling intensity
- Sampling bias
- etc. 

---


# Question to ask yourself when modelling a species

## 4. How do you want to model the distribution of the species?

- I am an expert, I will just draw a map freehand!

---

# Question to ask yourself when modelling a species

## 4. How do you want to model the distribution of the species?

- I am an expert, I will just draw a map freehand!

<div style='text-align:center;'>
<img src="assets/img/intro/Snowy_owl_map.png" height="380px"></img>
</div>

---

# Question to ask yourself when modelling a species

## 4. How do you want to model the distribution of the species?

- I am an expert, I will just draw a map freehand!
- Which model will be used? (This depends on the type of species data)

---

# Question to ask yourself when modelling a species

## 5. What are the assumptions of the model used?

- Linearity
- Spatial explicitness
- Independence of observations
- etc.


--- .transition

# Species distribution models on presence-absence data for a single species

---

# Important considerations

<div style='text-align:center;'>
<img src="assets/img/presence_absence/PA_red_maple.png" height="450px"></img>
</div>


Knowing where a species is <font color="red">not</font> found is <font color="blue" size = 6>extremely</font> informative.

---

# Techniques to model single species presence-absence data

Historically, a tremendous amount of work that has been done using presence-absence data.

As such, a huge number of approaches exist to model species presence-absence.

---

# A general overview of models properties

The main goal of these models is to define the <font color ="blue">probability of occurrence</font> of a species at a particular location.

They rely on a set of explanatory variables measured in the study region. These could represent
- Environmental characteristics
- Spatial coordinates of the sampled locations
- Other species (to account for biotic interactions)

---

# Overview of model for presence-absence data

## Three types of model will be considered today

- Generalized linear models
- Generalized additive models
- Classication and regression tree

These three types of models are the ones used by Franklin (1998)

## Many other approaches exist...
- Boosted regression tree
- Generalized dissimilarity models
- Genetic algorithms
- etc.

---

# Overview of model for presence-absence data

## Many other appraoches exist...

### Account for space explicitly and more precisely
- Geostatistical generalized linear models
- Autoregressive models
- Decomposition of geographical coordinates

These approach are all theoretically sound but they are not well adapted to deal with large expenses of data.

---

# Overview of model for presence-absence data

## Many other appraoches exist...

### Account for sampling biais and sampling error
- Hierarchical models

### Account for many other different aspects...
- Joint species distribution model (but we will get to that tomorrow)

--- .transition

# Generalized linear models

---

# Generalized linear models

When dealing with presence-absence data, binomial regression models are often used

- Logistic model
- Probit model
- Complementary log-log model
- etc.

These different variant of models differ by the link function used.

We will focus on the logistic regression.

---

# Logistic regression

The logistic regression is likely the most commonly used approach to model presence-absence data. In its simplest form, it can be presented as follow

$$\text{logit}(P(y = 1)) = \mathbf{x}^T\beta$$
$P(y=1)$ - The probability that species $y$ is present (1) or not

$\mathbf{x}$ - Matrix of explanatory variables

$\beta$ - Parameters associated to the explanatory variables

$T$ - Transpose of a matrix

---

# Logistic regression

In a logistic regression, the logit link is the key to fit presence-absence data

$$\text{logit}(p) = \log\left(\frac{p}{1 - p}\right)$$

![plot of chunk unnamed-chunk-1](assets/fig/unnamed-chunk-1-1.png)

---

# Checking for model quality
## $R^2$

The coefficient of determination ($R^2$) is <font color = "red" size = 6>not</font> designed to be used for logistic regression, but it is a good starting point.

It is calculated as follow

$$R^2 = 1 - \frac{\sum^n_{i=1}(y_i-\hat{y}_i)}{\sum^n_{i=1}(y_i-\overline{y})}$$

$n$ - Number of samples

$y_i$ - Response variable value for sample $i$

$\hat{y}_i$ - Model prediction for sample $i$

$\overline{y}$ - Average of the response variable $y$

---

# Checking for model quality
## $R^2$

Conceptually, there are three ways to understand an $R^2$:

1. A measure of variance explained
2. An improvement of the fitted model over a null model
3. The square of correlation

## Pseudo-$R^2$

Because there are no $R^2$, statisticians have developped pseudo-$R^2$ that have features similar to the $R^2$ but that may differ in the interpretation we make of them.

As a similarity, the different variant of pseudo-$R^2$ generally range between 0 and 1 (although it is not always the case); higher meanning a better fit.

---

# Logistic regression - Checking for model quality
## Pseudo-$R^2$

A number of pseudo-$R^2$ have been proposed. Here are a few,

### Efron pseudo-$R^2$

$$R^2 = 1 - \frac{\sum^n_{i=1}(y_i-\hat{\pi}_i)}{\sum^n_{i=1}(y_i-\overline{y})}$$

$\hat{\pi}_i$ - Model predicted probability for sample $i$

It can be interpreted as:
- A measure of variance explained
- The square of correlation

---

# Logistic regression - Checking for model quality
###  McFadden pseudo-$R^2$

$$R^2 = 1 - \frac{\ln \hat{L}(M_\text{Full})}{\ln \hat{L}(M_\text{Intercept})}$$

$\hat{L}$ - Model estimated liklihood

$M_\text{Full}$ - Model that includes all explanatory variables

$M_\text{Intercept}$ - Model that includes none of the explanatory variables

It can be interpreted as:
- A measure of variance explained
- An improvement of the fitted model over a null model

---

# Logistic regression - Checking for model quality
###  Tjur pseudo-$R^2$

$$R^2 = \overline{\hat{\pi}}_1 - \overline{\hat{\pi}}_0$$

$\overline{\hat{\pi}}_1$ - Average of the model prediction for all the presences

$\overline{\hat{\pi}}_0$ - Average of the model prediction for all the absences

It can be interpreted as:
- A measure of variance explained
- An improvement of the fitted model over a null model

---

# Logistic regression - Checking for model quality
###  Tjur pseudo-$R^2$


```r
tjurR2 <- function(y, pred){
  pseudoR2 <- mean(pred[y == 1]) - mean(pred[y == 0])
  return(pseudoR2)
}
```

###  Pseudo-$R^2$ in R

All the previously mentionned pseudo-$R^2$ can be computed in R using the `pseudoR2` function from the package `DescTools`.


---

# Logistic regression - Checking for model quality
## Receiver operating characteristic (ROC) curve

The receiver operating characteristic (ROC) curve is a diagnostic plot that help defines the quality of a model

It is calculated using the following table

<div style='text-align:center;'>
<img src="assets/img/presence_absence/ROC.png" height="300px"></img>
</div>

---

# Logistic regression - Checking for model quality
## Receiver operating characteristic (ROC) curve

Steps to calculate a ROC curve:

1. Define a sequence of value between 0 and 1
2. For the first value of the sequence calculate the <font color = "blue">true positive rate</font>
3. For the first value of the sequence calculate the <font color = "orange">false positive rate</font>
4. Continue for all the remaining values
5. Plot the  <font color = "blue">true positive rate</font> against the <font color = "orange">false positive rate</font>

#### Let's code this in R!

---

# Logistic regression - Checking for model quality
## Receiver operating characteristic (ROC) curve
### Data and model to use


```r
set.seed(12)

# Model
beta <- c(0.3, -3, 1)
x <- cbind(1, scale(1:200), scale(1:200)^2)
model <- binomial()$linkinv(x%*%beta)

# Response variable
y<-rbinom(200, 1, model)
```

---

# Logistic regression - Checking for model quality
## Receiver operating characteristic (ROC) curve - Solution

<img src="assets/fig/unnamed-chunk-4-1.png" title="plot of chunk unnamed-chunk-4" alt="plot of chunk unnamed-chunk-4" style="display: block; margin: auto;" />

---

# Logistic regression - Checking for model quality
## Receiver operating characteristic (ROC) curve - Solution


```r
# Result object
TPR <- numeric()
FPR <- numeric()

# Sequence
sequ <- seq(0,1, length = 200)

# Calculate TPR and FPR
for(i in 1:length(sequ)){
  pos <- ifelse(model > sequ[i],1,0)
  TPR[i] <- sum(pos == 1 & y == 1)/sum(y == 1)
  FPR[i] <- sum(pos == 1 & y == 0)/sum(y == 0)
}

# Plot
plot(FPR, TPR, type = "n", xlab = "False positive rate", ylab = "True positive rate", las = 1)
lines(FPR, TPR)
```

---

# Logistic regression - Checking for model quality
## Receiver operating characteristic (ROC) curve - Solution

There are a few packages in R that implemented the ROC curve

- `pROC`
- `ROCR`

These two are probably the most known ones.

An interesting aspect of ROC curves is that they can be used broadly, they are not constrained to the logistic model.

--- .transition

# Generalized additive model

---

# Generalized additive model
## A bit of history

Additive model were first proposed by

<div style='text-align:center;'>
<img src="assets/img/presence_absence/Friedman_Stuetzle.png" height="200px"></img>
</div>

In the paper
<div style='text-align:center;'>
<img src="assets/img/presence_absence/Additive_model_paper.png" height="100px"></img>
</div>
published in 1981 in the Journal of the American Statistical Association


---

# Generalized additive model
## A bit of history

As for generalized additive models, it was developped by

<div style='text-align:center;'>
<img src="assets/img/presence_absence/Hastie_Tibshirani.png" height="200px"></img>
</div>

In the book published in 1990

<div style='text-align:center;'>
<img src="assets/img/presence_absence/GAM_book_TH.jpeg"
height="150px"></img>
</div>

---

# Generalized additive model

Additive models are a form of linear models.

A logistic additive model with a single explanatory variable can be defined as:

$$\text{logit}(P(y_i = 1)) = f(x_i)$$
where
$$f(x) = \sum_{j = 1}^k b_j(x)\beta_j$$

$b_j(x)$ - $j^\text{th}$ basis function of the explanatory variable $x$

$\beta_j(x)$ - $j^\text{th}$ parameters associated to the basis function of the explanatory variable $x$

---

# Generalized additive model

This is some pretty dense theory...

<div style='text-align:center;'>
<img src="assets/img/presence_absence/grinning-face-with-one-large-and-one-small-eye_1f92a.png" height="100px"></img>
</div>

---

# Generalized additive model

This is some pretty dense theory...

<div style='text-align:center;'>
<img src="assets/img/presence_absence/grinning-face-with-one-large-and-one-small-eye_1f92a.png" height="100px"></img>
</div>

Let's clarify what $f(x)$ is about.

The $f(x)$ function is a general way to representation many different formulations of an additive model.

---

# Generalized additive model

An example of $f(x)$ is a polynomial regression of degree 5, that is

$$\text{logit}(P(y_i = 1)) = f(x_i)$$
where
$$f(x) = \sum_{j = 0}^5 b_j(x)\beta_j$$
and
$$b_j(x) = x^j$$
which can be rewritten as

$$\text{logit}(P(y_i = 1)) = \beta_0 + x\beta_1 + x^2\beta_2 + x^3\beta_3 + x^4\beta_4 + x^5\beta_5$$

---

# Generalized additive model

Visually this can be represented as

<img src="assets/fig/unnamed-chunk-6-1.png" title="plot of chunk unnamed-chunk-6" alt="plot of chunk unnamed-chunk-6" style="display: block; margin: auto;" />

---

# Generalized additive model

As mentionned before, the polynomial base function is one a many base function used in generalized additive models, sadly it is actually not very good.

Ones more commonly used is the cubic regression splines

<div style='text-align:center;'>
  <img src="assets/img/presence_absence/cubic_spline.png" height="350px"></img>
</div>

---

# Generalized additive model
## Cubic regression spline
### Advantage
- More flexible than a polynomial regression

### Disadvantage
- Deciding how many knots to place is subjective
- Deciding where to place the knots is subjective
- It can only be applied to a single variable

---

# Generalized additive model

On our data a cubic regression spline results in

<img src="assets/fig/unnamed-chunk-7-1.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" style="display: block; margin: auto;" />

---

# Generalized additive model
## Thin plate regression spline

The thin plate regression spline can be understood by thinking of an elastic mosquito mesh...

What can we do with an elastic mosquito mesh to fit to an object?

---

# Generalized additive model
## Thin plate regression spline

The thin plate regression spline can be understood by thinking of an elastic mosquito mesh...

What can we do with an elastic mosquito mesh to fit to an object?
- Translate
- Rotate
- Stretch (scale, compression, dilation)
- Shear

---

# Generalized additive model
## Thin plate regression spline

The thin plate regression spline can be understood by thinking of an elastic mosquito mesh...

What can we do with an elastic mosquito mesh to fit to an object?
- Translate
- Rotate
- Stretch (scale, compression, dilation)
- Shear

---

# Generalized additive model
## Thin plate regression spline

### Advantage
- More flexible than a polynomial regression
- No knots are needed
- Can be applied to multiple variables at once
- Computationally efficient... ish

### Disadvantage
- Interpreting the meaning of each thin plate spline is challenging

---

# Generalized additive model

On our data a thin plate regression spline results in

<img src="assets/fig/unnamed-chunk-8-1.png" title="plot of chunk unnamed-chunk-8" alt="plot of chunk unnamed-chunk-8" style="display: block; margin: auto;" />

---

# Model comparison

Out of these models, which one is the best?

<div style='text-align:center;'>
  <img src="assets/img/presence_absence/thinking-face_1f914.png" height="100px"></img>
</div>

---

# Model comparison

Out of these model, which one is the best?

We can use a pseudo-$R^2$ to do this... Let's use Tjur's pseudo-$R^2$


```r
# Models
logit <- glm(y ~ x[,2] + x[,3], family = binomial())
poly <- glm(y ~ x[,2] + I(x[,2]^2) + I(x[,2]^3) +
                I(x[,2]^4) + I(x[,2]^5), family = binomial())
cr5 <- gam(y ~ s(x[,2], fx = TRUE, bs = "cr", k = 5),
           family = binomial())
cr10 <- gam(y ~ s(x[,2], fx = TRUE, bs = "cr", k = 10),
            family = binomial())
tp5 <- gam(y ~ s(x[,2], fx = TRUE, bs = "tp", k = 5),
           family = binomial())
tp10 <- gam(y ~ s(x[,2], fx = TRUE, bs = "tp", k = 10),
            family = binomial())
```

---
# Model comparison


```r
# Prediction
logitPred <- predict(logit, type = "response")
polyPred <- predict(poly, type = "response")
cr5Pred <- predict(cr5, type = "response")
cr10Pred <- predict(cr10, type = "response")
tp5Pred <- predict(tp5, type = "response")
tp10Pred <- predict(tp10, type = "response")

# Calculate Tjur's pseudo-R2
R2 <- c(tjurR2(y, logitPred),tjurR2(y, polyPred),
        tjurR2(y, cr5Pred), tjurR2(y, cr10Pred),
        tjurR2(y, tp5Pred), tjurR2(y, tp10Pred))
R2
```

```
## [1] 0.5648442 0.5661367 0.5626427 0.5901714 0.5628846 0.5863466
```
And the winner is, the cubic regression spline with 10 knots...

---
# Model comparison


```r
# Prediction
logitPred <- predict(logit, type = "response")
polyPred <- predict(poly, type = "response")
cr5Pred <- predict(cr5, type = "response")
cr10Pred <- predict(cr10, type = "response")
tp5Pred <- predict(tp5, type = "response")
tp10Pred <- predict(tp10, type = "response")

# Calculate Tjur's pseudo-R2
R2 <- c(tjurR2(y, logitPred),tjurR2(y, polyPred),
        tjurR2(y, cr5Pred), tjurR2(y, cr10Pred),
        tjurR2(y, tp5Pred), tjurR2(y, tp10Pred))
R2
```

```
## [1] 0.5648442 0.5661367 0.5626427 0.5901714 0.5628846 0.5863466
```
And the winner is, the cubic regression spline with 10 knots...

Wrong
<img src="assets/img/presence_absence/shocked-face-with-exploding-head_1f92f.png" height="70px"></img>

---

# Model comparison

We need to account for the number of parameter estimated to make a good comparison

## Adjust-$R^2$

$$R^2_a = 1- \frac{n-1}{n - p - 1} (1 - R^2)$$
$R^2$ - (pseudo-)coefficient of determination

$n$ - Number of samples

$p$ - Number of estimated parameters (<font size = 6 color ="red">not</font> counting the intercept)

### <font color ="red">Important</font>

Adjusting a pseudo-$R^2$ make sense only for a pseudo-$R^2$ that quantify a measure of variance explained.

---

# Model comparison

By adjusted Tjur's pseudo-$R^2$ we obtain


```r
# Basic information
n <- length(y)
p <- c(2, 5, 5, 10, 5, 10)
names(p) <- c("logit", "poly", "cr5", "cr10", "tp5", "tp10")

# adjusted Tjur's pseudo-R2
1 - (n - 1)/(n - p - 1) * R2
```

```
##     logit      poly       cr5      cr10       tp5      tp10 
## 0.4294214 0.4192722 0.4228562 0.3786025 0.4226080 0.3826298
```

<div style='text-align:center;'>
  <img src="assets/img/presence_absence/face-with-party-horn-and-party-hat_1f973.png" height="100px"></img>
</div>

---

# Using generalized additive models to map species

Generalized additive models are very appealing because they are designed to account for non-linearity.

However, their great flexibility makes them challenging to use properly.


#### A few guidelines to using generalized additive models

- Because thin plate regression spline can be applied to multiple explanatory variables, it can account for non-linear among multiple variable (e.g. space)
- Choosing the right basis function can be challenging
  - Always think of the ecological problem you have when making this choice
- Choosing the right <font color = "blue">number</font> of basis functions can be challenging, here are two options
  - Using ecological knowledge to make the decision (preferred)
  - Using automatically selection procedure such as penalized regression spline

---

# A few more general guidelines to models species

- Always keep in mind your ecological question when building a model
- Every argument is important... go beyond the default options
- Be careful about statistical solutions to ecological problems
  - e.g. Penalized regression spline can be useful but should not be applied blindly

--- .transition

# Classification and regression trees

---

# Classification and regression trees

## A bit of history

Classification and regression trees have first been proposed by

<div style='text-align:center;'>
<img src="assets/img/presence_absence/CART_authors.png" height="200px"></img>
</div>

In a book published in 1984
<div style='text-align:center;'>
<img src="assets/img/presence_absence/CART_book.jpeg"
height="150px"></img>
</div>

---

# Classification and regression trees

While linear and additive models pass lines through the data to fit it, classification and regression tree's main goal is to split the data into similar groups. Specifically, the goal of tree modelling is to maximize the homogeneity within the groups

## Classification trees

A tree modelling approach where the response data to split into groups is a class variable

## Regression trees

A tree modelling approach where the response data to split into groups is a continuous variable

---

# Classification and regression trees

To show visually how it works, let's focus on the distribution of the American black duck (*Anas rubripes*)



<img src="assets/fig/unnamed-chunk-14-1.png" title="plot of chunk unnamed-chunk-14" alt="plot of chunk unnamed-chunk-14" style="display: block; margin: auto;" />

and let's model its distribution using the pixel's coordinates

---

# Classification and regression trees
## Steps to building a tree model
### 1. Decide on how to evaluate model group homogeneity

Within the framework of the `rpart` R package, this amount to deciding the type of response variable we are dealing with.

#### Continuous variable
The sums of squares is used as a measure of homogeneity

$$\sum_{k=1}^\text{group}\sum_{i=1}^{n_k}\left(y_i-\overline{y}_k\right)^2$$

$n_k$ - Number of samples in group $k$

---

# Classification and regression trees
## Steps to building a tree model
### 1. Decide on how to evaluate model group homogeneity

#### Class variable

The altered prior loss information criterion is used as a measure of homogeneity

$$\frac{\pi_iL_i}{\sum_j\pi_jL_j}$$
$\pi_i$ - Prior probability of class $i$ to be in a specific class

$L(i,j)$ - Loss matrix defining how much information is lost by incorrectly classifying class $i$ as class $j$.

In our example we will assume that the presence-absence of the American black duck is a class variable

---

# Classification and regression trees
## Steps to building a tree model
### 2. Split the data

Recall that this split is done to minimize the amount of information loss

<img src="assets/fig/unnamed-chunk-15-1.png" title="plot of chunk unnamed-chunk-15" alt="plot of chunk unnamed-chunk-15" style="display: block; margin: auto;" />

---

# Classification and regression trees
## Steps to building a tree model
### 2. Split the data

Continue...

<img src="assets/fig/unnamed-chunk-16-1.png" title="plot of chunk unnamed-chunk-16" alt="plot of chunk unnamed-chunk-16" style="display: block; margin: auto;" />


---

# Classification and regression trees
## Steps to building a tree model
### 2. Split the data

Continue...

<img src="assets/fig/unnamed-chunk-17-1.png" title="plot of chunk unnamed-chunk-17" alt="plot of chunk unnamed-chunk-17" style="display: block; margin: auto;" />

---

# Classification and regression trees
## Steps to building a tree model
### 2. Split the data

Continue...

<img src="assets/fig/unnamed-chunk-18-1.png" title="plot of chunk unnamed-chunk-18" alt="plot of chunk unnamed-chunk-18" style="display: block; margin: auto;" />

---

# Classification and regression trees
## Steps to building a tree model
### 2. Split the data

When do we stop!!!

<div style='text-align:center;'>
<img src="assets/img/presence_absence/face-with-open-mouth-and-cold-sweat_1f630.png"
height="100px"></img>
</div>

---

# Classification and regression trees
## Steps to building a tree model
### 2. Split the data

When do we stop!!!

<div style='text-align:center;'>
<img src="assets/img/presence_absence/face-with-open-mouth-and-cold-sweat_1f630.png"
height="100px"></img>
</div>

The short answer is... it depends

<div style='text-align:center;'>
<img src="assets/img/presence_absence/face-with-look-of-triumph_1f624.png"
height="100px"></img>
</div>

---

# Classification and regression trees
## Steps to building a tree model
### 2. Split the data
#### Deciding when to stop splitting the data
- We go until each sample is its own group

<div style='text-align:center;'>
<img src="assets/img/presence_absence/tree_many.pdf"
height="300px"></img>
</div>

---

# Classification and regression trees
## Steps to building a tree model
### 2. Split the data
#### Deciding when to stop splitting the data
- We go until each sample is its own group
- We construct a random forest
  - We construct many of trees, each one with "too many" groups and average over all the trees
- We tweak the parameters to select a tree model

---

# Classification and regression trees
## Steps to building a tree model
### 2. Split the data
#### Random forest

Advantages
- Good prediction ability

Disadventages
- Some biais in the result
- Hard to interpret

---

# Classification and regression trees
## Steps to building a tree model
### 2. Split the data
#### Parameter tweaking

Advantages
- More interpretable

Disadventages
- Generally the prediction are not as good as a random forest
- More subjectivity

---

# Classification and regression trees
## Steps to building a tree model
### 2. Split the data
#### Parameter tweaking

- Minimum number of samples that need to be in a node for it to be split
- Minimum number of sample in any terminal node (leaf)
- Complexity threshold to stop splitting the data
- etc.

---

# Classification and regression trees
## Steps to building a tree model
### 3. A tree!

<img src="assets/fig/unnamed-chunk-19-1.png" title="plot of chunk unnamed-chunk-19" alt="plot of chunk unnamed-chunk-19" style="display: block; margin: auto;" />

---

# Classification and regression trees
## Steps to building a tree model

But is it a good tree?

### 4. Check tree

Use pseudo-$R^2$ and/or ROC curves
