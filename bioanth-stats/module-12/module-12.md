Module 12
================

Introduction to Linear Regression
=================================

Preliminaries
-------------

-   Install these packages in ***R***: {curl}, {ggplot2}, {gridExtra}, {manipulate}, {lmodel2}

Objectives
----------

> The objective of this module is to discuss the use of simple linear regression to explore the relationship among two continuous variables: a single predictor variable and a single response variable.

Covariance and Correlation
--------------------------

So far, we have looked principally at single variables, but one of the main things we are often interested in is the relationships among two or more variables. Regression modeling is one of the most powerful and important set of tools for looking at relationships among more than one variable. With our zombies dataset, we started to do this using simple bivariate scatterplots... let's look at those data again and do a simple bivariate plot of height by weight.

``` r
library(curl)
library(ggplot2)
f <- curl("https://raw.githubusercontent.com/difiore/ADA2016/master/zombies.csv")
d <- read.csv(f, header = TRUE, sep = ",", stringsAsFactors = FALSE)
head(d)
```

    ##   id first_name last_name gender   height   weight zombies_killed
    ## 1  1      Sarah    Little Female 62.88951 132.0872              2
    ## 2  2       Mark    Duncan   Male 67.80277 146.3753              5
    ## 3  3    Brandon     Perez   Male 72.12908 152.9370              1
    ## 4  4      Roger   Coleman   Male 66.78484 129.7418              5
    ## 5  5      Tammy    Powell Female 64.71832 132.4265              4
    ## 6  6    Anthony     Green   Male 71.24326 152.5246              1
    ##   years_of_education                           major      age
    ## 1                  1                medicine/nursing 17.64275
    ## 2                  3 criminal justice administration 22.58951
    ## 3                  1                       education 21.91276
    ## 4                  6                  energy studies 18.19058
    ## 5                  3                       logistics 21.10399
    ## 6                  4                  energy studies 21.48355

``` r
plot(data = d, height ~ weight)
```

![](img/unnamed-chunk-1-1.png)

These variables clearly seem to be related to one another, in that as weight increases, height increases. There are a couple of different ways we can quantify the relationship between these variables. One is the **covariance**, which expresses how much two numeric variables “change together” and whether that change is positive or negative.

Recall that the variance in a variable is simply the sum of the squared deviatiations of each observation from the mean divided by sample size (**n** for population variance or **n-1** for sample variance). Thus, sample variance is:

<img src="img/samplevar.svg" width="225px">

Similarly, the **covariance** is simply the product of the deviations of each of two variables from their respective means divided by sample size. So, for two vectors, *x* and *y*, each of length *n* representing two variables describing a sample...

<img src="img/samplecov.svg" width="300px"/>

#### CHALLENGE:

What is the covariance between zombie weight and zombie height? What does it mean if the covariance is positive versus negative? Does it matter if you switch the order of the two variables?

``` r
w <- d$weight
h <- d$height
n <- length(w)  # or length(h)
cov_wh <- sum((w - mean(w)) * (h - mean(h)))/(n - 1)
cov_wh
```

    ## [1] 66.03314

The built-in ***R*** function `cov()` yields the same.

``` r
cov(w, h)
```

    ## [1] 66.03314

We often describe the relationship between two variables using the **correlation** coefficient, which is a standardized form of the covariance, which summarizes on a standard scale, -1 to +1, both the strength and direction of a relationship. The correlation is simply the covariance divided by the product of the standard deviation of both variables.

<img src="img/samplecor.svg" width="225px"/>

#### CHALLENGE:

Calculate the correlation between zombie height and weight.

``` r
sd_w <- sd(w)
sd_h <- sd(h)
cor_wh <- cov_wh/(sd_w * sd_h)
cor_wh
```

    ## [1] 0.8325862

Again, there is a built-in ***R*** function `cor()` which yields the same.

``` r
cor(w, h)
```

    ## [1] 0.8325862

``` r
cor(w, h, method = "pearson")
```

    ## [1] 0.8325862

This formulation of the correlation coefficient is referred to as **Pearson’s product-moment correlation coefficient** and is often abbreviated as ***ρ***.

There are other, nonparametric forms of the correlation coefficient we might also calculate:

``` r
cor(w, h, method = "kendall")
```

    ## [1] 0.6331932

``` r
cor(w, h, method = "spearman")
```

    ## [1] 0.82668

Regression
----------

Regression is the set of tools that lets us explore the relationships between variables further. In regression analysis, we are typically identifying and exploring linear models, or functions, that describe the relationship between variables. There are a couple of main purposes for undertaking regression analyses:

-   To use one or more variables to **predict** the value of another
-   To develo and choose among different **models** of the relationship between variables
-   To do **analyses of covariation** among sets of variables to identify their relative explanatory power

The general purpose of linear regression is to come up with a model or function that estimates the mean value of one variable, i.e., the **response** or **outcome** variable, given the particular value(s) of another variable or set of variables, i.e., the **predictor** variable(s).

We're going to start off with simple bivariate regression, where we have a single predictor and a single response variable. In our case, we may be interested in coming up with a linear model that estimates the mean value for zombie height (as the response variable) given zombie weight (as the predictor variable). That is, we want to explore functions that link these two variables and choose the best one.

In general, the model for linear regression represents a dependent (or response) variable, *Y* as a linear function of the independent (or predictor) variable, *X*.

*Y* = *β*<sub>0</sub> + *β*<sub>1</sub>*X*<sub>*i*</sub> + *ϵ*<sub>*i*</sub>

The function has two coefficients. The first *β*<sub>0</sub> is the intercept, the value of *Y* when *X* = 0. The second *β*<sub>1</sub> is the slope of the line. The error term, *ϵ*<sub>*i*</sub> is a normal random variable, *ϵ*<sub>*i*</sub> ∼ *N*(0, *σ*<sup>2</sup>) with the standard deviation assumed to be constant across all values of *X*.

A regression analysis calls for estimating the values of all three parameters (*β*<sub>0</sub>, *β*<sub>1</sub>, and the residuals or error term). How this is accomplished will depend on what assumption are employed in the analysis. The regression model posits that *X* is the cause of *Y*.

Looking at our scatterplot above, it seems pretty clear that there is indeed some linear relationship among these variables, and so a reasonable function to connect height to weight should simply be some kind of line of best fit. Recall that the general formula for a line is:

<img src="img/line.svg" width="300px"/>

where <img src="img/yhat.svg" width="12px"/> = our predicted y given a value of x

In regression parlance...

<img src="img/reg.svg" width="150px"/>

\[see equation 20.2 in ***The Book of R***\]

Here, *β*<sub>1</sub> and *β*<sub>0</sub> are referred to as the **regression coefficients**, and it is those that our regression analysis is trying to estimate, while minimizing, according to some criterion, the error term. This process of estimation is called "fitting the model."

A tyrpical linear regression analysis further assumes that *X*, our "independent" variable, is controlled and thus measured with much greater precision than *Y*, our "dependent" variable. Thus the error, *ϵ*<sub>*i*</sub> is assumed to be restricted to the *Y* dimension, with little or no error in measuring *X*, and we employ "ordinary least squares" as our criterion for best fit.

What does this mean? Well, we can imagine a family of lines of different *β*<sub>1</sub> and *β*<sub>0</sub> going through this cloud of points, and the best fit criterion we use is to find the line whose coefficients minimize the sum of the squared deviations of each observation in the *Y* direction from that predicted by the line. This is the basis of **ordinary least squares** or **OLS** regression. We want to wind up with an equation that tells us how *Y* varies in response to changes in *X*.

So, we want to find *β*<sub>1</sub> and *β*<sub>0</sub> that minimizes...

<img src="img/leastsq1.svg" width="125px"/>

or, equivalently,

<img src="img/leastsq2.svg" width="225px"/>

In our variables, this is...

<img src="img/zombiesreg.svg" width="310px"/>

Let's fit the model by hand... The first thing to do is estimate the slope, which we can do if we first "center" each of our variables by subtracting the mean from each value (this shifts the distribution to eliminate the intercept term).

``` r
y <- h - mean(h)
x <- w - mean(w)
z <- data.frame(cbind(x, y))
g <- ggplot(data = z, aes(x = x, y = y)) + geom_point()
g
```

![](img/unnamed-chunk-7-1.png)

Now, we just need to minimize...

<img src="img/centeredreg.svg" width="310px"/>

We can explore finding the best slope (*β*<sub>1</sub>) for this line using an interactive approach...

``` r
slope.test <- function(beta1) {
    g <- ggplot(data = z, aes(x = x, y = y))
    g <- g + geom_point()
    g <- g + geom_abline(intercept = 0, slope = beta1, size = 1, colour = "blue", 
        alpha = 1/2)
    ols <- sum((y - beta1 * x)^2)
    g <- g + ggtitle(paste("Slope = ", beta1, "\nSum of Squared Deviations = ", 
        round(ols, 3)))
    g
}
```

``` r
manipulate(slope.test(beta1), beta1 = slider(-1, 1, initial = 0, step = 0.005))
```

Similarly, analytically...

<img src="img/beta1.svg" width="475px"/>

\[see equation 20.3 in ***The Book of R***\]

``` r
beta1 <- cor(w, h) * (sd(h)/sd(w))
beta1
```

    ## [1] 0.1950187

``` r
beta1 <- cov(w, h)/var(w)
beta1
```

    ## [1] 0.1950187

``` r
beta1 <- sum((h - mean(h)) * (w - mean(w)))/sum((w - mean(w))^2)
beta1
```

    ## [1] 0.1950187

To find *β*<sub>0</sub>, we can simply plug back into our original regression model. The line of best fit has to run through the centroid of our data points, which is the point determined by the mean of the x values and the mean of the y values, so we can use the following:

<img src="img/ybar.svg" width="175px"/>

which, rearranged to solve for *β*<sub>0</sub> gives...

<img src="img/beta0.svg" width="175px"/>

``` r
beta0 <- mean(h) - beta1 * mean(w)
beta0
```

    ## [1] 39.56545

Note that in the example above, we have taken our least squares criterion to mean minimizing the deviation of each of our *Y* variables from a line of best fit in a dimension perpendicular to the *Y* axis. In general, this kind of regression, where deviation is measured perpendicular to one of the axes, is known as **Model I** regression, and is used when the levels of the predictor variable are either measured without error (or, practically speaking, are measured with much less uncertainty than those of the response variable) or are set by the researcher (e.g., for defined treatment variables in an ecological experiment).

### The `lm()` Function

The function `lm()` in ***R*** makes all of the calculations we did above for **Model I** regression very easy! Below, we pass the zombies dataframe and variables directly to `lm()` and assign the result to an ***R*** object called **m**. We can then look at the various elements that ***R*** calculates about this model.

``` r
m <- lm(height ~ weight, data = d)
m
```

    ## 
    ## Call:
    ## lm(formula = height ~ weight, data = d)
    ## 
    ## Coefficients:
    ## (Intercept)       weight  
    ##      39.565        0.195

``` r
names(m)
```

    ##  [1] "coefficients"  "residuals"     "effects"       "rank"         
    ##  [5] "fitted.values" "assign"        "qr"            "df.residual"  
    ##  [9] "xlevels"       "call"          "terms"         "model"

``` r
m$coefficients
```

    ## (Intercept)      weight 
    ##  39.5654460   0.1950187

``` r
head(m$model)
```

    ##     height   weight
    ## 1 62.88951 132.0872
    ## 2 67.80277 146.3753
    ## 3 72.12908 152.9370
    ## 4 66.78484 129.7418
    ## 5 64.71832 132.4265
    ## 6 71.24326 152.5246

In {ggplot}, we can easily create a plot that adds the linear model along with confidence intervals around the estimated value of **y**, or <img src="img/yhat.svg" width="12px"/> at each **x**. Those intervals are important for when we move on to talking about inference in the regression context.

``` r
g <- ggplot(data = d, aes(x = weight, y = height))
g <- g + geom_point()
g <- g + geom_smooth(method = "lm", formula = y ~ x)
g
```

![](img/unnamed-chunk-13-1.png)

The assumption of greater uncertainty in our response variable than in our predictor variable may be reasonable in controlled experiments, but for natural observations, measurement of the *X* variable also typically involves some error and, in fact, in many cases we may not be concered about PREDICTING *Y* from *X* but rather want to treat both *X* and *Y* as independent variables and explore the relationship between them or consider that both are dependent on some additional parameter, which may be unknown. That is, both are measured rather than "controlled" and both include uncertainty. We thus are not seeking an equation of how *Y* varies with changes in *X*, but rather we are look for how they both co-vary in response to some other variable or process. Under these conditions **Model II** regression analysis may be more appropriate. In **Model II** approaches, a line of best fit is chosen that minimizes in some way the direct distance of each point to the best fit line. There are several different types of **Model II** regression, and which to use depends upon the specifics of the case. Common approaches are know as *major axis*, *ranged major axis*, and *reduced major axis* (a.k.a. *standard major axis*) regression.

The {lmodel2} package allows us to do **Model II** regression easily (as well as **Model I**). In this package, the signficance of the regression coefficients is determined based on permutation.

``` r
library(lmodel2)  # load the lmodel2 package
# Run the regression
mII <- lmodel2(height ~ weight, data = d, range.y = "relative", range.x = "relative", 
    nperm = 1000)
mII
```

    ## 
    ## Model II regression
    ## 
    ## Call: lmodel2(formula = height ~ weight, data = d, range.y =
    ## "relative", range.x = "relative", nperm = 1000)
    ## 
    ## n = 1000   r = 0.8325862   r-square = 0.6931998 
    ## Parametric P-values:   2-tailed = 2.646279e-258    1-tailed = 1.32314e-258 
    ## Angle between the two OLS regression lines = 4.677707 degrees
    ## 
    ## Permutation tests of OLS, MA, RMA slopes: 1-tailed, tail corresponding to sign
    ## A permutation test of r is equivalent to a permutation test of the OLS slope
    ## P-perm for SMA = NA because the SMA slope cannot be tested
    ## 
    ## Regression results
    ##   Method Intercept     Slope Angle (degrees) P-perm (1-tailed)
    ## 1    OLS  39.56545 0.1950187        11.03524       0.000999001
    ## 2     MA  39.10314 0.1982313        11.21246       0.000999001
    ## 3    SMA  33.92229 0.2342325        13.18287                NA
    ## 4    RMA  36.80125 0.2142269        12.09153       0.000999001
    ## 
    ## Confidence intervals
    ##   Method 2.5%-Intercept 97.5%-Intercept 2.5%-Slope 97.5%-Slope
    ## 1    OLS       38.39625        40.73464  0.1869597   0.2030778
    ## 2     MA       37.92239        40.28020  0.1900520   0.2064362
    ## 3    SMA       32.74259        35.06211  0.2263120   0.2424301
    ## 4    RMA       35.51434        38.06296  0.2054593   0.2231695
    ## 
    ## Eigenvalues: 351.6888 5.48735 
    ## 
    ## H statistic used for computing C.I. of MA: 6.212738e-05

``` r
plot(mII, "OLS")
```

![](img/unnamed-chunk-14-1.png)

``` r
plot(mII, "RMA")
```

![](img/unnamed-chunk-14-2.png)

``` r
plot(mII, "SMA")
```

![](img/unnamed-chunk-14-3.png)

``` r
plot(mII, "MA")
```

![](img/unnamed-chunk-14-4.png)

Note that, here, running `lmodel2()` and using OLS to detemine the best coefficients yields equivalent results to our Model I regression done above using `lm()`.

``` r
mI <- lm(height ~ weight, data = d)
summary(mI)
```

    ## 
    ## Call:
    ## lm(formula = height ~ weight, data = d)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -7.1519 -1.5206 -0.0535  1.5167  9.4439 
    ## 
    ## Coefficients:
    ##              Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept) 39.565446   0.595815   66.41   <2e-16 ***
    ## weight       0.195019   0.004107   47.49   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 2.389 on 998 degrees of freedom
    ## Multiple R-squared:  0.6932, Adjusted R-squared:  0.6929 
    ## F-statistic:  2255 on 1 and 998 DF,  p-value: < 2.2e-16

``` r
par(mfrow = c(1, 2))
plot(mII, main = "lmodel2() OLS")
plot(data = d, height ~ weight, main = "lm()")
abline(mI)
```

![](img/unnamed-chunk-15-1.png)

#### CHALLENGE:

Using the zombies dataset, work with a partner to...

-   Plot zombie height as a function of age
-   Derive by hand the ordinary least squares regression coefficients *β*<sub>1</sub> and *β*<sub>0</sub> for these data.
-   Confirm that you get the same results using the `lm()` function
-   Repeat the analysis above for males and females separately. Do your regression coefficients differ? How might you determine this?

``` r
plot(data = d, height ~ age)
```

![](img/unnamed-chunk-16-1.png)

``` r
head(d)
```

    ##   id first_name last_name gender   height   weight zombies_killed
    ## 1  1      Sarah    Little Female 62.88951 132.0872              2
    ## 2  2       Mark    Duncan   Male 67.80277 146.3753              5
    ## 3  3    Brandon     Perez   Male 72.12908 152.9370              1
    ## 4  4      Roger   Coleman   Male 66.78484 129.7418              5
    ## 5  5      Tammy    Powell Female 64.71832 132.4265              4
    ## 6  6    Anthony     Green   Male 71.24326 152.5246              1
    ##   years_of_education                           major      age
    ## 1                  1                medicine/nursing 17.64275
    ## 2                  3 criminal justice administration 22.58951
    ## 3                  1                       education 21.91276
    ## 4                  6                  energy studies 18.19058
    ## 5                  3                       logistics 21.10399
    ## 6                  4                  energy studies 21.48355

``` r
beta1 <- cor(d$height, d$age) * sd(d$height)/sd(d$age)
beta1
```

    ## [1] 0.9425086

``` r
beta0 <- mean(d$height) - beta1 * mean(d$age)
beta0
```

    ## [1] 48.73566

``` r
m <- lm(height ~ age, data = d)
m
```

    ## 
    ## Call:
    ## lm(formula = height ~ age, data = d)
    ## 
    ## Coefficients:
    ## (Intercept)          age  
    ##     48.7357       0.9425

### Statistical Inference in Regression

Once we have our linear model and associated regression coefficients, we want to know a bit more about it. First, we want to be able to evaluate whether there is **statistical evidence** that there is indeed a relationship between these variables. If so, then our regression coefficients can indeed allow us to estimate or predict the value of one variable given another. Additionally, we also would like to be able to extend our estimates from our sample out to the population they are drawn from. These next steps involve the process of statistical inference.

The output of the `lm()` function provides a lot of information useful for inference. Run the command `summary()` on the output of `lm(data=d,height~weight)`

``` r
m <- lm(data = d, height ~ weight)
summary(m)
```

    ## 
    ## Call:
    ## lm(formula = height ~ weight, data = d)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -7.1519 -1.5206 -0.0535  1.5167  9.4439 
    ## 
    ## Coefficients:
    ##              Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept) 39.565446   0.595815   66.41   <2e-16 ***
    ## weight       0.195019   0.004107   47.49   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 2.389 on 998 degrees of freedom
    ## Multiple R-squared:  0.6932, Adjusted R-squared:  0.6929 
    ## F-statistic:  2255 on 1 and 998 DF,  p-value: < 2.2e-16

One of the outputs for the model, seen in the 2nd to last line in the output above, is the "R-squared" value, or the **coefficient of determination**, which is a summary of the total amount of variation in the **y** variable that is explained by the **x** variable. In our regression, ~69% of the variation in zombie height is explained by zombie weight.

Another output is the **standard error** of the estimate of each regression coefficient, along with a corresponding **t value** and **p value**. Recall that t statistics are calculated as the difference between an observed and expected value divided by a standard error. The p value comes from evaluating the magnitude of the t statistic against a t distribution with **n-2** degrees of freedom. We can confirm this by hand calculating t and p based on the estimate and the standard error of the estimate.

``` r
t <- coef(summary(m))
t <- data.frame(unlist(t))
colnames(t) <- c("Est", "SE", "t", "p")
t
```

    ##                    Est          SE        t             p
    ## (Intercept) 39.5654460 0.595814678 66.40562  0.000000e+00
    ## weight       0.1950187 0.004106858 47.48611 2.646279e-258

``` r
t$calct <- (t$Est - 0)/t$SE
t$calcp <- 2 * pt(t$calct, df = 998, lower.tail = FALSE)  # x2 because is 2-tailed test
t
```

    ##                    Est          SE        t             p    calct
    ## (Intercept) 39.5654460 0.595814678 66.40562  0.000000e+00 66.40562
    ## weight       0.1950187 0.004106858 47.48611 2.646279e-258 47.48611
    ##                     calcp
    ## (Intercept)  0.000000e+00
    ## weight      2.646279e-258

We can get confidence intervals for our estimates easily, too, using either the approach we've used before by hand or by using a built in function.

``` r
t$lower <- t$Est - qt(0.975, df = 998) * t$SE
t$upper <- t$Est + qt(0.975, df = 998) * t$SE
ci <- c(t$lower, t$upper)  # by hand
ci
```

    ## [1] 38.3962527  0.1869597 40.7346393  0.2030778

``` r
ci <- confint(m, level = 0.95)  # using the results of lm()
ci
```

    ##                  2.5 %     97.5 %
    ## (Intercept) 38.3962527 40.7346393
    ## weight       0.1869597  0.2030778

### Interpreting Regression Coefficients and Prediction

Estimating our regression coefficients is pretty straightforward... but what do they mean?

-   The intercept, *β*<sub>0</sub>, is the PREDICTED value of **y** when the value of **x** is zero.
-   The slope, *β*<sub>1</sub> is EXPECTED CHANGE in units of **y** for every 1 unit of change in **x**.
-   The overall equation allows us to calculate PREDICTED values of **y** for new observations of **x**. We can also calculate CONFIDENCE INTERVALS (CIs) around the predicted mean value of **y** for each value of **x** (which addresses our uncertainly in the estimate of the mean), and we can also get PREDICTION INTERVALS (PIs) around our prediction (which gives the range of actual values of **y** we might expect to see at a given value of **x**).

#### CHALLENGE:

-   If zombie weight is measured in *pounds* and zombie height is measured in *inches*, what is the expected height of a zombie weighing 150 pounds?
-   What is the predicted difference in height between a zombie weighing 180 and 220 pounds?

``` r
beta0 <- t$Est[1]
beta1 <- t$Est[2]
h_hat <- beta1 * 150 + beta0
h_hat
```

    ## [1] 68.81825

``` r
h_hat_difference <- (beta1 * 220 + beta0) - (beta1 * 180 + beta0)
h_hat_difference
```

    ## [1] 7.800749

The `predict()` function allows us to generate predicted (i.e., <img src="img/yhat.svg" width="12px"/>) values for a vector of values of x. Note the structure of the 2nd argument in the function... it includes the x variable name, and we pass it a vector of values. Here, I pass it a vector of actual x values.

``` r
m <- lm(data = d, height ~ weight)
h_hat <- predict(m, newdata = data.frame(weight = d$weight))
df <- data.frame(cbind(d$weight, d$height, h_hat))
names(df) <- c("x", "y", "yhat")
head(df)
```

    ##          x        y     yhat
    ## 1 132.0872 62.88951 65.32492
    ## 2 146.3753 67.80277 68.11137
    ## 3 152.9370 72.12908 69.39103
    ## 4 129.7418 66.78484 64.86753
    ## 5 132.4265 64.71832 65.39109
    ## 6 152.5246 71.24326 69.31059

``` r
g <- ggplot(data = df, aes(x = x, y = yhat))
g <- g + geom_point()
g <- g + geom_point(aes(x = x, y = y), colour = "red")
g <- g + geom_segment(aes(x = x, y = yhat, xend = x, yend = y))
g
```

![](img/unnamed-chunk-21-1.png)

Each vertical line in the figure above represents a **residual**, the difference between the observed and the fitted or predicted value of y at the given x values.

The `predict()` function also allows us to easily generate confidence intervals around our predicted mean value for **y** values easily.

``` r
ci <- predict(m, newdata = data.frame(weight = 150), interval = "confidence", 
    level = 0.95)  # for a single value
ci
```

    ##        fit      lwr     upr
    ## 1 68.81825 68.66211 68.9744

``` r
ci <- predict(m, newdata = data.frame(weight = d$weight), interval = "confidence", 
    level = 0.95)  # for a vector of values
head(ci)
```

    ##        fit      lwr      upr
    ## 1 65.32492 65.14872 65.50111
    ## 2 68.11137 67.96182 68.26092
    ## 3 69.39103 69.22591 69.55615
    ## 4 64.86753 64.68044 65.05462
    ## 5 65.39109 65.21636 65.56582
    ## 6 69.31059 69.14691 69.47428

``` r
df <- cbind(df, ci)
names(df) <- c("x", "y", "yhat", "CIfit", "CIlwr", "CIupr")
head(df)
```

    ##          x        y     yhat    CIfit    CIlwr    CIupr
    ## 1 132.0872 62.88951 65.32492 65.32492 65.14872 65.50111
    ## 2 146.3753 67.80277 68.11137 68.11137 67.96182 68.26092
    ## 3 152.9370 72.12908 69.39103 69.39103 69.22591 69.55615
    ## 4 129.7418 66.78484 64.86753 64.86753 64.68044 65.05462
    ## 5 132.4265 64.71832 65.39109 65.39109 65.21636 65.56582
    ## 6 152.5246 71.24326 69.31059 69.31059 69.14691 69.47428

``` r
g <- ggplot(data = df, aes(x = x, y = y))
g <- g + geom_point(alpha = 1/2)
g <- g + geom_line(aes(x = x, y = CIfit), colour = "black")
g <- g + geom_line(aes(x = x, y = CIlwr), colour = "blue")
g <- g + geom_line(aes(x = x, y = CIupr), colour = "blue")
g
```

![](img/unnamed-chunk-22-1.png)

The same `predict()` function also allows us to easily generate *prediction intervals* for values of **y** at each **x**.

``` r
pi <- predict(m, newdata = data.frame(weight = 150), interval = "prediction", 
    level = 0.95)  # for a single value
pi
```

    ##        fit      lwr      upr
    ## 1 68.81825 64.12849 73.50802

``` r
pi <- predict(m, newdata = data.frame(weight = d$weight), interval = "prediction", 
    level = 0.95)  # for a vector of values
head(pi)
```

    ##        fit      lwr      upr
    ## 1 65.32492 60.63444 70.01539
    ## 2 68.11137 63.42182 72.80092
    ## 3 69.39103 64.70095 74.08110
    ## 4 64.86753 60.17663 69.55843
    ## 5 65.39109 60.70067 70.08151
    ## 6 69.31059 64.62057 74.00062

``` r
df <- cbind(df, pi)
names(df) <- c("x", "y", "yhat", "CIfit", "CIlwr", "CIupr", "PIfit", "PIlwr", 
    "PIupr")
head(df)
```

    ##          x        y     yhat    CIfit    CIlwr    CIupr    PIfit    PIlwr
    ## 1 132.0872 62.88951 65.32492 65.32492 65.14872 65.50111 65.32492 60.63444
    ## 2 146.3753 67.80277 68.11137 68.11137 67.96182 68.26092 68.11137 63.42182
    ## 3 152.9370 72.12908 69.39103 69.39103 69.22591 69.55615 69.39103 64.70095
    ## 4 129.7418 66.78484 64.86753 64.86753 64.68044 65.05462 64.86753 60.17663
    ## 5 132.4265 64.71832 65.39109 65.39109 65.21636 65.56582 65.39109 60.70067
    ## 6 152.5246 71.24326 69.31059 69.31059 69.14691 69.47428 69.31059 64.62057
    ##      PIupr
    ## 1 70.01539
    ## 2 72.80092
    ## 3 74.08110
    ## 4 69.55843
    ## 5 70.08151
    ## 6 74.00062

``` r
g <- g + geom_line(data = df, aes(x = x, y = PIlwr), colour = "red")
g <- g + geom_line(data = df, aes(x = x, y = PIupr), colour = "red")
g
```

![](img/unnamed-chunk-23-1.png)

#### CHALLENGE:

Construct a linear model for the regression of zombie height on age and predict the mean height, the 95% confidence interval (CI) around the predicted mean height, and the 95% prediction interval (PI) around that mean for a vector of zombie ages, `v <- seq(from=10, to=30, by=1)`. Then, plot your points, your regression line, and lines for the lower and upper limits of the CI and of the PI.

``` r
v <- seq(from = 10, to = 30, by = 1)
m <- lm(data = d, height ~ age)
ci <- predict(m, newdata = data.frame(age = v), interval = "confidence", level = 0.95)
pi <- predict(m, newdata = data.frame(age = v), interval = "prediction", level = 0.95)
plot(data = d, height ~ age)
lines(x = v, y = ci[, 1], col = "black")
lines(x = v, y = ci[, 2], col = "blue")
lines(x = v, y = ci[, 3], col = "blue")
lines(x = v, y = pi[, 2], col = "red")
lines(x = v, y = pi[, 3], col = "red")
```

![](img/unnamed-chunk-24-1.png)

``` r
# or
require(gridExtra)
```

    ## Loading required package: gridExtra

``` r
require(ggplot2)
df <- data.frame(cbind(v, ci, pi))
names(df) <- c("age", "CIfit", "CIlwr", "CIupr", "PIfit", "PIlwr", "PIupr")
head(df)
```

    ##   age    CIfit    CIlwr    CIupr    PIfit    PIlwr    PIupr
    ## 1  10 58.16075 57.44067 58.88083 58.16075 51.67823 64.64327
    ## 2  11 59.10326 58.44882 59.75770 59.10326 52.62770 65.57882
    ## 3  12 60.04577 59.45627 60.63527 60.04577 53.57645 66.51509
    ## 4  13 60.98828 60.46275 61.51380 60.98828 54.52447 67.45208
    ## 5  14 61.93079 61.46786 62.39371 61.93079 55.47177 68.38980
    ## 6  15 62.87329 62.47096 63.27563 62.87329 56.41834 69.32825

``` r
g1 <- ggplot(data = d, aes(x = age, y = height))
g1 <- g1 + geom_point(alpha = 1/2)
g1 <- g1 + geom_line(data = df, aes(x = v, y = CIfit), colour = "black", lwd = 1)
g1 <- g1 + geom_line(data = df, aes(x = v, y = CIlwr), colour = "blue")
g1 <- g1 + geom_line(data = df, aes(x = v, y = CIupr), colour = "blue")
g1 <- g1 + geom_line(data = df, aes(x = v, y = PIlwr), colour = "red")
g1 <- g1 + geom_line(data = df, aes(x = v, y = PIupr), colour = "red")
g2 <- ggplot(data = d, aes(x = age, y = height))
g2 <- g2 + geom_point(alpha = 1/2)
g2 <- g2 + geom_smooth(method = "lm", formula = y ~ x)
grid.arrange(g1, g2, ncol = 2)
```

![](img/unnamed-chunk-24-2.png)

Again, here the CI band shows where the mean height is expected to fall in 95% of samples and the PI band shows where the individual points are expected to fall 95% of the time.

### Residuals

From our various plots above, it's clear that our model is not explaining all of the variation we see in our dataset... our **y** points do not all fall on the **yhat** line but rather are distributed around it. The distance of each of these points from the predicted value for **y** at that value of **x** is known as the "residual". We can think about the residuals as "what is left over"" after accounting for the predicted relationship between **x** and **y**. Residuals are often thought of as estimates of the "error" term in a regression model, and most regression analyses assume that residuals are random normal variables with uniform variance across the range of **x** values (more on this below). In ordinary least squares regression, the line of best fit minimizes the sum of the squared residuals, and the expected value for a residual is 0.

Residuals are also used to create "covariate adjusted" variables, as they can be thought of as the response variable, **y**, with the linear effect of the predictor variable(s) removed. We'll return to this idea when we move on to multivariate regression.
