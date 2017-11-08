Module 16
================

Model Selection in General Linear Regression
============================================

Overview
--------

The purpose of a model selection process in a regression analysis is to sort through our explanatory variables in a systematic fashion in order to establish which are best able to describe the response. There are different possible algorithms to use for model selection, e.g., forward and backward selection, which may result in different parameters being included in the final model.

#### Nested Comparisons

One way we can compare different models is to use F ratios and what are called partial F tests. This approach looks at two or more *nested* models: a larger model that contains explanatory variables that we are interested in and smaller, less complex models that exclude one or more of those variables. Basically, we aim to compare the variance in the response variable explained by the more complex model to that explained by a "reduced" model. If the more complex model explains a significantly greater proportion of the variation, then we conclude that predictor terms absent from the less complex model are important.

For example, if including an additional term with its associated *β* coefficient results in significantly better fit to the observed data than we find for a model that lacks that particular terms, then this is evidence against the null hypothesis that the *β* coefficient (slope) for that term equals zero.

#### EXAMPLE:

Let's go back to our zombie data and compare a few models. We need to calculate the following partial F statistic for the full versus reduced model.

<img src="img/ftest.svg" width="400px"/>

where:

-   The *R*<sup>2</sup> values are the coefficients of determination of the full model and the nested "reduced"" model

-   *n* is the number of observations in the data set

-   *p* is the number of predictor terms in the nested (reduced) model

-   *q* is the number of predictor terms in the full model

After we calculate this F statistic, we compare it to an F distribution with df1 = q-p and df2 = n-q to derive a p value. The `lm()` function will do this for us automatically, but we can also do it by hand.

``` r
library(curl)
f <- curl("https://raw.githubusercontent.com/difiore/ADA2016/master/zombies.csv")
z <- read.csv(f, header = TRUE, sep = ",", stringsAsFactors = TRUE)
m1 <- lm(data = z, height ~ age * gender)  # full model
m2 <- lm(data = z, height ~ age + gender)  # model without interactions
m3 <- lm(data = z, height ~ age)  # model with one predictor
m4 <- lm(data = z, height ~ 1)  # intercept only model
```

Once we have fitted these nested models, we can carry out partial F tests to compare particular models using the `anova()` function, with the nested (reduced) and full model as arguments. The reduced model is included as the 1st argument and the full model is included as the second argument.

``` r
anova(m2, m1, test = "F")  # compares the reduced model without interactions (m2) to the full model with interactions (m1)
```

    ## Analysis of Variance Table
    ## 
    ## Model 1: height ~ age + gender
    ## Model 2: height ~ age * gender
    ##   Res.Df    RSS Df Sum of Sq     F  Pr(>F)  
    ## 1    997 6752.7                             
    ## 2    996 6708.6  1    44.138 6.553 0.01062 *
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

We can also calculate the F statistic by hand and compare it to the F distribution.

``` r
f <- ((summary(m1)$r.squared - summary(m2)$r.squared) * (nrow(z) - 3 - 1))/((1 - 
    summary(m1)$r.squared) * (3 - 2))
f
```

    ## [1] 6.552973

``` r
p <- 1 - pf(f, df1 = 3 - 2, df2 = nrow(z) - 3, lower.tail = TRUE)  # df1 = q-p, df2 = n-q
p
```

    ## [1] 0.01061738

``` r
anova(m3, m2, test = "F")  # compares the age only model (m3) to the age + gender model (m2)
```

    ## Analysis of Variance Table
    ## 
    ## Model 1: height ~ age
    ## Model 2: height ~ age + gender
    ##   Res.Df     RSS Df Sum of Sq      F    Pr(>F)    
    ## 1    998 10756.6                                  
    ## 2    997  6752.7  1    4003.9 591.15 < 2.2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

``` r
f <- ((summary(m2)$r.squared - summary(m3)$r.squared) * (nrow(z) - 2 - 1))/((1 - 
    summary(m2)$r.squared) * (2 - 1))
f
```

    ## [1] 591.147

``` r
p <- 1 - pf(f, df1 = 2 - 1, df2 = nrow(z) - 2, lower.tail = TRUE)  # df1 = q-p, df2 = n-q
p
```

    ## [1] 0

In these cases, each comparison shows that the more complex model indeed results in signficantly more explantory power than the reduced model.

#### Forward Selection

Forward selection starts with an intercept-only model and then tests which of the predictor variables best improves the goodness-of-fit. Then the model is updated by adding that term and tests which of the remaining predictors would further and best improve the fit. The process continues until there are not any other terms that could be added to improve the fit more. The R functions `add1()` and `update()`, respectively, perform the series of tests and update your fitted regression model. Setting the `test=` argument to "F" includes the partial F statistic value and its significance. The ".~." part of the `scope=` argument means, basically, "what is already there", while the remainder of the scope argument is the list of additional variables you might add for the fullest possible model.

``` r
m0 <- lm(data = z, height ~ 1)
summary(m0)
```

    ## 
    ## Call:
    ## lm(formula = height ~ 1, data = z)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -13.4806  -2.9511  -0.1279   2.7530  12.8997 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  67.6301     0.1363   496.2   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 4.31 on 999 degrees of freedom

``` r
add1(m0, scope = . ~ . + age + weight + zombies_killed + years_of_education, 
    test = "F")
```

    ## Single term additions
    ## 
    ## Model:
    ## height ~ 1
    ##                    Df Sum of Sq     RSS    AIC   F value  Pr(>F)    
    ## <none>                          18558.6 2922.9                      
    ## age                 1    7802.0 10756.6 2379.5  723.8676 < 2e-16 ***
    ## weight              1   12864.8  5693.8 1743.4 2254.9310 < 2e-16 ***
    ## zombies_killed      1       5.7 18552.9 2924.6    0.3048 0.58100    
    ## years_of_education  1      81.6 18477.0 2920.5    4.4057 0.03607 *  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

``` r
m1 <- update(m0, formula = . ~ . + weight)
summary(m1)
```

    ## 
    ## Call:
    ## lm(formula = height ~ weight, data = z)
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
add1(m1, scope = . ~ . + age + weight + zombies_killed + years_of_education, 
    test = "F")
```

    ## Single term additions
    ## 
    ## Model:
    ## height ~ weight
    ##                    Df Sum of Sq    RSS     AIC   F value  Pr(>F)    
    ## <none>                          5693.8 1743.38                      
    ## age                 1   3012.83 2681.0  992.17 1120.4147 < 2e-16 ***
    ## zombies_killed      1      5.16 5688.6 1744.47    0.9052 0.34163    
    ## years_of_education  1     16.93 5676.9 1742.40    2.9728 0.08498 .  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

``` r
m2 <- update(m1, formula = . ~ . + age)
summary(m2)
```

    ## 
    ## Call:
    ## lm(formula = height ~ weight + age, data = z)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -5.2278 -1.1782 -0.0574  1.1566  5.4117 
    ## 
    ## Coefficients:
    ##              Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept) 31.763388   0.470797   67.47   <2e-16 ***
    ## weight       0.163107   0.002976   54.80   <2e-16 ***
    ## age          0.618270   0.018471   33.47   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1.64 on 997 degrees of freedom
    ## Multiple R-squared:  0.8555, Adjusted R-squared:  0.8553 
    ## F-statistic:  2952 on 2 and 997 DF,  p-value: < 2.2e-16

``` r
add1(m2, scope = . ~ . + age + weight + zombies_killed + years_of_education, 
    test = "F")
```

    ## Single term additions
    ## 
    ## Model:
    ## height ~ weight + age
    ##                    Df Sum of Sq    RSS    AIC F value Pr(>F)
    ## <none>                          2681.0 992.17               
    ## zombies_killed      1   2.62551 2678.3 993.20  0.9764 0.3233
    ## years_of_education  1   0.77683 2680.2 993.89  0.2887 0.5912

After we add weight and age, no other variable improves the fit of the model significantly, so the final, best model in this case is **m2**.

``` r
summary(m2)
```

    ## 
    ## Call:
    ## lm(formula = height ~ weight + age, data = z)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -5.2278 -1.1782 -0.0574  1.1566  5.4117 
    ## 
    ## Coefficients:
    ##              Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept) 31.763388   0.470797   67.47   <2e-16 ***
    ## weight       0.163107   0.002976   54.80   <2e-16 ***
    ## age          0.618270   0.018471   33.47   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1.64 on 997 degrees of freedom
    ## Multiple R-squared:  0.8555, Adjusted R-squared:  0.8553 
    ## F-statistic:  2952 on 2 and 997 DF,  p-value: < 2.2e-16

#### Backward Selection

Opposite to forward selection, backward selection starts with the fullest model you want to consider and systematically drops terms that do not contribute to the explanatory value of the model. The ***R*** functions for this process are `drop1()` to inspect the partial F test results and `update()` to update the model.

``` r
m0 <- lm(data = z, height ~ age + weight + zombies_killed + years_of_education)
summary(m0)
```

    ## 
    ## Call:
    ## lm(formula = height ~ age + weight + zombies_killed + years_of_education, 
    ##     data = z)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -5.1716 -1.1751 -0.0645  1.1263  5.4526 
    ## 
    ## Coefficients:
    ##                     Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)        31.625711   0.486310  65.032   <2e-16 ***
    ## age                 0.617436   0.018511  33.355   <2e-16 ***
    ## weight              0.163197   0.002981  54.750   <2e-16 ***
    ## zombies_killed      0.029777   0.029721   1.002    0.317    
    ## years_of_education  0.017476   0.031050   0.563    0.574    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1.64 on 995 degrees of freedom
    ## Multiple R-squared:  0.8557, Adjusted R-squared:  0.8551 
    ## F-statistic:  1475 on 4 and 995 DF,  p-value: < 2.2e-16

``` r
drop1(m0, test = "F")
```

    ## Single term deletions
    ## 
    ## Model:
    ## height ~ age + weight + zombies_killed + years_of_education
    ##                    Df Sum of Sq     RSS     AIC   F value Pr(>F)    
    ## <none>                           2677.5  994.88                     
    ## age                 1    2993.7  5671.2 1743.40 1112.5240 <2e-16 ***
    ## weight              1    8066.3 10743.7 2382.32 2997.5633 <2e-16 ***
    ## zombies_killed      1       2.7  2680.2  993.89    1.0038 0.3166    
    ## years_of_education  1       0.9  2678.3  993.20    0.3168 0.5737    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

``` r
m1 <- update(m0, . ~ . - years_of_education)
summary(m1)
```

    ## 
    ## Call:
    ## lm(formula = height ~ age + weight + zombies_killed, data = z)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -5.1715 -1.1928 -0.0615  1.1435  5.4700 
    ## 
    ## Coefficients:
    ##                 Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)    31.661862   0.481884  65.704   <2e-16 ***
    ## age             0.618053   0.018472  33.458   <2e-16 ***
    ## weight          0.163232   0.002979  54.793   <2e-16 ***
    ## zombies_killed  0.029348   0.029701   0.988    0.323    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1.64 on 996 degrees of freedom
    ## Multiple R-squared:  0.8557, Adjusted R-squared:  0.8552 
    ## F-statistic:  1968 on 3 and 996 DF,  p-value: < 2.2e-16

``` r
drop1(m1, test = "F")
```

    ## Single term deletions
    ## 
    ## Model:
    ## height ~ age + weight + zombies_killed
    ##                Df Sum of Sq     RSS     AIC   F value Pr(>F)    
    ## <none>                       2678.3  993.20                     
    ## age             1    3010.3  5688.6 1744.47 1119.4439 <2e-16 ***
    ## weight          1    8073.4 10751.7 2381.07 3002.2762 <2e-16 ***
    ## zombies_killed  1       2.6  2681.0  992.17    0.9764 0.3233    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

``` r
m2 <- update(m1, . ~ . - zombies_killed)
summary(m2)
```

    ## 
    ## Call:
    ## lm(formula = height ~ age + weight, data = z)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -5.2278 -1.1782 -0.0574  1.1566  5.4117 
    ## 
    ## Coefficients:
    ##              Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept) 31.763388   0.470797   67.47   <2e-16 ***
    ## age          0.618270   0.018471   33.47   <2e-16 ***
    ## weight       0.163107   0.002976   54.80   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1.64 on 997 degrees of freedom
    ## Multiple R-squared:  0.8555, Adjusted R-squared:  0.8553 
    ## F-statistic:  2952 on 2 and 997 DF,  p-value: < 2.2e-16

``` r
drop1(m2, test = "F")
```

    ## Single term deletions
    ## 
    ## Model:
    ## height ~ age + weight
    ##        Df Sum of Sq     RSS     AIC F value    Pr(>F)    
    ## <none>               2681.0  992.17                      
    ## age     1    3012.8  5693.8 1743.38  1120.4 < 2.2e-16 ***
    ## weight  1    8075.7 10756.6 2379.52  3003.2 < 2.2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

At this point, all of the explanatory variables are still significant, so the final, best model in this case is also **m2**.

``` r
summary(m2)
```

    ## 
    ## Call:
    ## lm(formula = height ~ age + weight, data = z)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -5.2278 -1.1782 -0.0574  1.1566  5.4117 
    ## 
    ## Coefficients:
    ##              Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept) 31.763388   0.470797   67.47   <2e-16 ***
    ## age          0.618270   0.018471   33.47   <2e-16 ***
    ## weight       0.163107   0.002976   54.80   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1.64 on 997 degrees of freedom
    ## Multiple R-squared:  0.8555, Adjusted R-squared:  0.8553 
    ## F-statistic:  2952 on 2 and 997 DF,  p-value: < 2.2e-16
