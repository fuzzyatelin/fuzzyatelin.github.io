Module 11
================
Anthony Di Fiore and Christopher A. Schmitt

Type I and II Errors and Statistical Power
==========================================

Preliminaries
-------------

-   Install these packages in ***R***: {curl}, {ggplot2}, {manipulate}

Objectives
----------

> The objective of this module is to discuss the concepts of Type I and Type II error, the multiple testing problem, statistical power, and effect size and outline how we can use ***R*** to investigate these via simulation and built-in functions.

Overview
--------

Let's return to the concepts of **error** and **power**. Recall that Type I error occurs when you **incorrectly reject a true *H*<sub>0</sub>**. In any given hypothesis test, the probability of a Type I error is equivalent to the significance level, *α*, and it is this type of error we are often trying to minimize when we are doing classical statistical inference. Type II error occurs when you **incorrectly fail to reject a false *H*<sub>0</sub>** (in other words, fail to find evidence in support of a true *H*<sub>*A*</sub>). Since we do not know what the true *H*<sub>*A*</sub> actually is, the probability of committing such an error, labeled *β*, is not usually known in practice.

| What is True      | What We Decide    | Result                                    |
|-------------------|-------------------|-------------------------------------------|
| *H*<sub>0</sub>   | *H*<sub>0</sub>   | Correctly 'accept' the null               |
| *H*<sub>0</sub>   | *H*<sub>*A*</sub> | Falsely reject the null (Type I error)    |
| *H*<sub>*A*</sub> | *H*<sub>0</sub>   | Falsely 'accept' the null (Type II error) |
| *H*<sub>*A*</sub> | *H*<sub>*A*</sub> | Correctly reject the null                 |

Type I Error and the Multiple Testing Problem
---------------------------------------------

Because of how we define *α*, the chance probabilty of falsely rejecting *H*<sub>0</sub> when *H*<sub>0</sub> is actually true, we would expect to find some "significant" results if we run enough independent hypothesis tests. For example, if we set *α* at 0.05, we would expect to find one "significant" result in roughly every 20 tests we run, just by chance. The relation of *α* to the distribution of a variable under a null hypothesis (*μ* = *μ*<sub>0</sub>) versus an alternative hypothesis (e.g., *μ* &gt; *μ*<sub>0</sub>) is shown in the figure below (this example is for an upper one-tailed test). It should be clear that we can reduce the chance of Type I error by decreasing *α* (shifting the critical value to the right in the *H*<sub>0</sub> distribution). Type I error will also be reduced as the means get further apart or as the standard deviation of the distributions shrinks.

<img src="img/typeI.png" width="600px"/>

Let's explore this via simulation.

We will write some code to simulate a bunch of random datasets from a normal distribution where we set the expected population mean (*μ*<sub>0</sub>) and standard deviation (*σ*) and then calculate a Z (or T) statistic and p value for each one. We will then look at the "Type I" error rate... the proportion of times that, based on our sample, we would conclude that it was not drawn from the distribution we know to be true.

First, let's set up a skeleton function we will call `typeI()` to evaluate the Type I error rate. It should take, as arguments, the parameters of the normal distribution for the null hypothesis we want to simulate from (*μ*<sub>0</sub> and *σ*), our sample size, our $ level, what "alternative" type of Z (or T) test we want to do ("greater", "less", or "two.tailed") and the number of simulated datasets we want to generate. Type in the code below (and note that we set default values for *α* and the number of simulations). Note that we can use the "t" family of functions instead of the "norm" family.

``` r
typeI <- function(mu0, sigma, n, alternative = "two.tailed", alpha = 0.05, k = 10000) {
}
```

Now, we will add the body of the function.

``` r
typeI <- function(mu0, sigma, n, alternative = "two.tailed", alpha = 0.05, k = 1000) {
    p <- rep(NA, k)  # sets up a vector of empty p values
    for (i in 1:k) {
        # sets up a loop to run k simulations
        x <- rnorm(n = n, mean = mu0, sd = sigma)  # draws a sample from our distribution
        m <- mean(x)  # calculates the mean
        s <- sd(x)  # calculates the standard deviation
        z <- (m - mu0)/(s/sqrt(n))  # calculates the T statistic for the sample drawn from the null distribution relative to the null distribution
        # alternatively use t <- (m-mu0)/(s/sqrt(n))
        if (alternative == "less") {
            p[i] <- pnorm(z, lower.tail = TRUE)  # calculates the associated p value
            # alternatively, use p[i] <- pt(t,df=n-1,lower.tail=TRUE)
        }
        if (alternative == "greater") {
            p[i] <- pnorm(z, lower.tail = FALSE)  # calculates the associated p value
            # alternatively, use p[i] <- pt(t,df=n-1,lower.tail=FALSE)
        }
        if (alternative == "two.tailed") {
            if (z > 0) 
                {
                  p[i] <- 2 * pnorm(z, lower.tail = FALSE)
                }  # alternatively, use if (t > 0) {p[i] <- pt(t,df=n-1,lower.tail=FALSE)}
            if (z < 0) 
                {
                  p[i] <- 2 * pnorm(z, lower.tail = TRUE)
                }  # alternatively, use if (t < 0) {p[i] <- pt(t,df=n-1,lower.tail=TRUE)}
        }
    }
    
    curve(dnorm(x, mu0, sigma/sqrt(n)), mu0 - 4 * sigma/sqrt(n), mu0 + 4 * sigma/sqrt(n), 
        main = paste("Sampling Distribution Under the Null Hypothesis\nType I error rate from simulation = ", 
            length(p[p < alpha])/k, sep = ""), xlab = "x", ylab = "Pr(x)", col = "red", 
        xlim = c(mu0 - 4 * sigma/sqrt(n), mu0 + 4 * sigma/sqrt(n)), ylim = c(0, 
            dnorm(mu0, mu0, sigma/sqrt(n))))
    abline(h = 0)
    
    if (alternative == "less") {
        polygon(cbind(c(mu0 - 4 * sigma/sqrt(n), seq(from = mu0 - 4 * sigma/sqrt(n), 
            to = mu0 - qnorm(1 - alpha) * sigma/sqrt(n), length.out = 100), 
            mu0 - qnorm(1 - alpha) * sigma/sqrt(n))), c(0, dnorm(seq(from = mu0 - 
            4 * sigma/sqrt(n), to = mu0 - qnorm(1 - alpha) * sigma/sqrt(n), 
            length.out = 100), mean = mu0, sd = sigma/sqrt(n)), 0), border = "black", 
            col = "grey")
        q <- pnorm(mu0 - qnorm(1 - alpha) * sigma/sqrt(n), mean = mu0, sd = sigma/sqrt(n)) - 
            pnorm(mu0 - 4 * sigma/sqrt(n), mean = mu0, sd = sigma/sqrt(n))
    }
    if (alternative == "greater") {
        polygon(cbind(c(mu0 + qnorm(1 - alpha) * sigma/sqrt(n), seq(from = mu0 + 
            qnorm(1 - alpha) * sigma/sqrt(n), to = mu0 + 4 * sigma/sqrt(n), 
            length.out = 100), mu0 + 4 * sigma/sqrt(n))), c(0, dnorm(seq(from = mu0 + 
            qnorm(1 - alpha) * sigma/sqrt(n), to = mu0 + 4 * sigma/sqrt(n), 
            length.out = 100), mean = mu0, sd = sigma/sqrt(n)), 0), border = "black", 
            col = "grey")
        q <- pnorm(mu0 + 4 * sigma/sqrt(n), mean = mu0, sd = sigma/sqrt(n)) - 
            pnorm(mu0 + qnorm(1 - alpha) * sigma/sqrt(n), mean = mu0, sd = sigma/sqrt(n))
    }
    if (alternative == "two.tailed") {
        polygon(cbind(c(mu0 - 4 * sigma/sqrt(n), seq(from = mu0 - 4 * sigma/sqrt(n), 
            to = mu0 - qnorm(1 - alpha/2) * sigma/sqrt(n), length.out = 100), 
            mu0 - qnorm(1 - alpha/2) * sigma/sqrt(n))), c(0, dnorm(seq(from = mu0 - 
            4 * sigma/sqrt(n), to = mu0 - qnorm(1 - alpha/2) * sigma/sqrt(n), 
            length.out = 100), mean = mu0, sd = sigma/sqrt(n)), 0), border = "black", 
            col = "grey")
        polygon(cbind(c(mu0 + qnorm(1 - alpha/2) * sigma/sqrt(n), seq(from = mu0 + 
            qnorm(1 - alpha/2) * sigma/sqrt(n), to = mu0 + 4 * sigma/sqrt(n), 
            length.out = 100), mu0 + 4 * sigma/sqrt(n))), c(0, dnorm(seq(from = mu0 + 
            qnorm(1 - alpha/2) * sigma/sqrt(n), to = mu0 + 4 * sigma/sqrt(n), 
            length.out = 100), mean = mu0, sd = sigma/sqrt(n)), 0), border = "black", 
            col = "grey")
        q <- pnorm(mu0 - qnorm(1 - alpha/2) * sigma/sqrt(n), mean = mu0, sd = sigma/sqrt(n)) - 
            pnorm(mu0 - 4 * sigma/sqrt(n), mean = mu0, sd = sigma/sqrt(n)) + 
            pnorm(mu0 + 4 * sigma/sqrt(n), mean = mu0, sd = sigma/sqrt(n)) - 
            pnorm(mu0 + qnorm(1 - alpha/2) * sigma/sqrt(n), mean = mu0, sd = sigma/sqrt(n))
    }
    # print(round(q,digits=3)) # this prints area in the shaded portion(s) of
    # the curve
    return(length(p[p < alpha])/k)  # returns the proportion of simulations where p < alpha
}
```

Can you explain what each step of this code is doing?

Now, run our Type I error test function with a couple of different values of *μ*<sub>0</sub>, *σ*, and *α*. What error rates are returned? They should be always be close to *α*!

``` r
eI <- typeI(mu0 = -3, sigma = 2, n = 5000, alternative = "greater", alpha = 0.05)
```

![](img/unnamed-chunk-3-1.png)

``` r
eI <- typeI(mu0 = 5, sigma = 2, n = 1000, alternative = "less", alpha = 0.01)
```

![](img/unnamed-chunk-3-2.png)

#### CHALLENGE:

How does the Type I error rate change with *n*? With *σ*? With *α*? HINT: It shouldn't change much... the Type I error rate is defined by *α*!

Multiple Comparison Corrections
-------------------------------

One way we can address the multiple testing problem discussed above by using what is called the **Bonferroni** correction, which suggests that when doing a total of *k* independent hypothesis tests, each with a significance level of *α*, we should adjust the *α* level we use to interpret statistical significance as follow: *α*<sub>*B*</sub> = *α*/*k*. For example, if we run 10 independent hypothesis tests, then we should set our adjusted *α* level for each test as 0.05/10 = 0.005. With the Bonferroni correction, we are essentially saying that we want to control the rate at which we have even one incorrect rejection of *H*<sub>0</sub> given the entire family of tests we do. This is also referred to as limiting the "family-wise error rate" to level *α*.

Note that many statisticians consider the Bonferroni correction to be a VERY conservative one, and there are other corrections we might use to account for multiple testing.

``` r
alpha <- 0.05
pvals <- c(1e-04, 0.003, 0.005, 0.01, 0.02, 0.04, 0.045, 0.11, 0.18, 0.23)
sig <- pvals <= alpha/length(pvals)
sig  # first 3 values are less than the adjusted alpha
```

    ##  [1]  TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE

One common alternative to the **Bonferroni** correction is the **Benjamini & Hochberg** correction, which is less conservative. It attempts to control for the "false discovery rate", which is different than the "family-wise error rate". Here, we aim to limit the number of false "discoveries" (i.e., incorrect rejections of the null hypothesis) out of a set of discoveries (i.e., out of the set of results where we would reject the null hypothesis) to *α*.

-   Calculate *p* values for all tests
-   Order *p* values from smallest to largest (from *p*<sub>1</sub> to *p*<sub>*m*</sub>)
-   Call any *p*<sub>*i*</sub> ≤ *α* x i/m significant

``` r
library(ggplot2)
alpha <- 0.05
psig <- NULL
pvals <- c(1e-04, 0.003, 0.005, 0.01, 0.02, 0.04, 0.045, 0.11, 0.18, 0.27)
for (i in 1:length(pvals)) {
    psig[i] <- alpha * i/length(pvals)
}
d <- data.frame(cbind(rank = c(1:10), pvals, psig))
p <- ggplot(data = d, aes(x = rank, y = pvals)) + geom_point() + geom_line(aes(x = rank, 
    y = psig))
p
```

![](img/unnamed-chunk-5-1.png)

``` r
sig <- pvals <= psig  # vector of significant pvalues
sig  # first 5 values are less than the adjusted alpha
```

    ##  [1]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE

An alternative way of thinking about this is to adjust the **p values** themselves rather than the *α* levels. We can do this with a built-in ***R*** function, which makes the calculation easy.

``` r
sig <- p.adjust(pvals, method = "bonferroni") <= 0.05
sig  # first 3 adjusted p values are less alpha
```

    ##  [1]  TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE

``` r
sig <- p.adjust(pvals, method = "BH") <= 0.05
sig  # first 4 adjusted p values are less alpha
```

    ##  [1]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE

Type II Error
-------------

By reducing the *α* level we use as our criterion for statistical significance, we can reduce the chance of committing a Type I error (incorrectly rejecting the null), but doing so directly increases our chance of committing a Type II error (incorrectly ***failing*** to reject the null). The shaded area in this figure below, *β*, is the probability of incorrectly failing to reject the null...

<img src="img/typeII.png" width="600px"/>

It should be clear from this figure that if the critical value (which, again, is defined by *α*) is shifted to the left, or if *μ* under the alternative hypothesis shifts left, then *β*, the area under the null hypothesis distribution curve to the left of the critical value, increases! Intuitively, this makes sense: the lower the difference between the true *μ*<sub>*A*</sub> value and *μ*<sub>0</sub> and/or the higher the *α* level, the harder it will be to reject the null hypothesis that *μ* = *μ*<sub>0</sub>.

In practice, we cannot usually calculate *β* because of the need to know where the true distribution is really centered (i.e., we need to know the value of *μ*<sub>*A*</sub>, which is often unknown). However, we can explore via simulation what *β* is expected to look like under different alternative hypotheses (e.g., under different *μ*<sub>*A*</sub>) and under different sample sizes and *α* levels.

Let's do this using the simulation approach we developed above. Again, we will write some code to simulate a bunch of random datasets, this time drawn from a normal distribution associated with a particular alternative hypothesis, *H*<sub>*A*</sub>, that we define... i.e., where we specify *μ*<sub>*A*</sub>. We then calculate a Z (or T) statistic based on each sample dataset relative to *μ*<sub>0</sub>, the expected mean under *H*<sub>0</sub>, and determine the associated p value for each one. Based on this, we can calculate the Type II error rate... the proportion of times that, based on our samples, we would conclude that it was drawn from the *H*<sub>0</sub> distribution rather than the *H*<sub>*A*</sub> distribution that we set to be true. Note that, as above, we can use the "t" family of functions in lieu of the "norm" family.

``` r
typeII <- function(mu0, muA, sigma, n, alternative = "two.tailed", alpha = 0.05, 
    k = 1000) {
    p <- rep(NA, k)  # sets up a vector of empty p values
    for (i in 1:k) {
        x <- rnorm(n = n, mean = muA, sd = sigma)  # draw from Ha
        m <- mean(x)
        s <- sd(x)
        z <- (m - mu0)/(s/sqrt(n))  # calculates the Z statistic for the sample drawn from Ha relative to the null distribution
        if (alternative == "less") {
            p[i] <- pnorm(z, lower.tail = TRUE)  # calculates the associated p value
            hyp <- "muA < mu0"
        }
        if (alternative == "greater") {
            p[i] <- pnorm(z, lower.tail = FALSE)
            hyp <- "muA > mu0"
        }
        if (alternative == "two.tailed") {
            if (z > 0) {
                p[i] <- 2 * pnorm(z, lower.tail = FALSE)
            }
            if (z < 0) {
                p[i] <- 2 * pnorm(z, lower.tail = TRUE)
            }
            hyp <- "muA ≠ mu0"
        }
    }
    
    curve(dnorm(x, mu0, sigma/sqrt(n)), mu0 - 4 * sigma/sqrt(n), mu0 + 4 * sigma/sqrt(n), 
        main = paste("Sampling Distributions Under the Null (red)\nand Alternative Hypotheses (blue)\nType II error rate from simulation = ", 
            length(p[p >= alpha])/k, sep = ""), xlab = "x", ylab = "Pr(x)", 
        col = "red", xlim = c(min(c(mu0 - 4 * sigma/sqrt(n), muA - 4 * sigma/sqrt(n))), 
            max(c(mu0 + 4 * sigma/sqrt(n), muA + 4 * sigma/sqrt(n)))), ylim = c(0, 
            max(c(dnorm(mu0, mu0, sigma/sqrt(n))), dnorm(muA, muA, sigma/sqrt(n)))))
    
    curve(dnorm(x, muA, sigma/sqrt(n)), muA - 4 * sigma/sqrt(n), muA + 4 * sigma/sqrt(n), 
        col = "blue", add = TRUE)
    abline(h = 0)
    
    if (alternative == "less") {
        polygon(cbind(c(mu0 - qnorm(1 - alpha) * sigma/sqrt(n), seq(from = mu0 - 
            qnorm(1 - alpha) * sigma/sqrt(n), to = muA + 4 * sigma/sqrt(n), 
            length.out = 100), muA + 4 * sigma/sqrt(n))), c(0, dnorm(seq(mu0 - 
            qnorm(1 - alpha) * sigma/sqrt(n), to = muA + 4 * sigma/sqrt(n), 
            length.out = 100), mean = muA, sd = sigma/sqrt(n)), 0), border = "black", 
            col = "grey")
        abline(v = mu0 - qnorm(1 - alpha) * sigma/sqrt(n), col = "black", lty = 3, 
            lwd = 2)
    }
    
    if (alternative == "greater") {
        polygon(cbind(c(muA - 4 * sigma/sqrt(n), seq(from = muA - 4 * sigma/sqrt(n), 
            to = mu0 + qnorm(1 - alpha) * sigma/sqrt(n), length.out = 100), 
            mu0 + qnorm(1 - alpha) * sigma/sqrt(n))), c(0, dnorm(seq(from = muA - 
            4 * sigma/sqrt(n), to = mu0 + qnorm(1 - alpha) * sigma/sqrt(n), 
            length.out = 100), mean = muA, sd = sigma/sqrt(n)), 0), border = "black", 
            col = "grey")
        abline(v = mu0 + qnorm(1 - alpha) * sigma/sqrt(n), col = "black", lty = 3, 
            lwd = 2)
    }
    
    if (alternative == "two.tailed") {
        abline(v = mu0 - qnorm(1 - alpha/2) * sigma/sqrt(n), col = "black", 
            lty = 3, lwd = 2)
        abline(v = mu0 + qnorm(1 - alpha/2) * sigma/sqrt(n), col = "black", 
            lty = 3, lwd = 2)
        
        if (z > 0) {
            # greater
            polygon(cbind(c(muA - 4 * sigma/sqrt(n), seq(from = muA - 4 * sigma/sqrt(n), 
                to = mu0 + qnorm(1 - alpha/2) * sigma/sqrt(n), length.out = 100), 
                mu0 + qnorm(1 - alpha/2) * sigma/sqrt(n))), c(0, dnorm(seq(from = muA - 
                4 * sigma/sqrt(n), to = mu0 + qnorm(1 - alpha/2) * sigma/sqrt(n), 
                length.out = 100), mean = muA, sd = sigma/sqrt(n)), 0), border = "black", 
                col = "grey")
        }
        
        # less
        if (z < 0) {
            polygon(cbind(c(mu0 - qnorm(1 - alpha/2) * sigma/sqrt(n), seq(from = mu0 - 
                qnorm(1 - alpha/2) * sigma/sqrt(n), to = muA + 4 * sigma/sqrt(n), 
                length.out = 100), muA + 4 * sigma/sqrt(n))), c(0, dnorm(seq(mu0 - 
                qnorm(1 - alpha/2) * sigma/sqrt(n), to = muA + 4 * sigma/sqrt(n), 
                length.out = 100), mean = muA, sd = sigma/sqrt(n)), 0), border = "black", 
                col = "grey")
        }
    }
    
    return(length(p[p >= alpha])/k)
}
```

#### CHALLENGE:

Explore this function using different values of *μ*<sub>0</sub>, *σ*, *n*, and different types of one- and two-tailed tests.

``` r
eII <- typeII(mu0 = 2, muA = 4, sigma = 3, n = 6, alternative = "greater")  # Ha > H0
```

![](img/unnamed-chunk-8-1.png)

``` r
eII <- typeII(mu0 = 5, muA = 2, sigma = 4, n = 18, alternative = "less")  # Ha < H0
```

![](img/unnamed-chunk-8-2.png)

``` r
eII <- typeII(mu0 = 5, muA = 7, sigma = 2, n = 15, alternative = "two.tailed")  # Ha ≠ H0
```

![](img/unnamed-chunk-8-3.png)

Power
-----

Power is the **probability of correctly rejecting a null hypothesis that is untrue**. For a test that has a Type II error rate of *β*, the statistical power is defined, simply, as 1 − *β*. Power values of 0.8 or greater are conventionally considered to be high. Power for any given test depends on the difference between *μ* between groups/treatments, *α*, *n*, and *σ*.

Effect Size
-----------

Generally speaking, an effect size is a quantitative measure of the strength of a phenomenon. Here, we are interested in comparing two sample means, and the most common way to describe the effect size is as a **standardized difference** between the means of the groups being compared. In this case, we divide the difference between the means by the standard deviation: |(*μ*<sub>0</sub> - *μ*<sub>*A*</sub>)|/*σ*. This results in a scaleless measure. Conventionally, effect sizes of 0.2 or less are considered to be low and of 0.8 or greater are considered to be high.

Graphical Depiction of Power and Effect Size
--------------------------------------------

The code below lets you explore power and effect size interactively. You can use the sliders to set *μ*<sub>0</sub> and *μ*<sub>*A*</sub> for a one-sample test (or, alternatively, think about these as *μ*<sub>1</sub> and *μ*<sub>2</sub> for a two-sample test), *σ*, *α*, *n*, and you can choose whether you are testing a one-sided hypothesis of *μ*<sub>*A*</sub> being "greater" or "less" than *μ*<sub>*A*</sub> or are testing the two-sided hypothesis that *μ*<sub>*A*</sub> ≠ *μ*<sub>0</sub> ("two.tailed"). The graph will output **Power** and **Effect Size**.

``` r
library(ggplot2)
library(manipulate)
power.plot <- function(sigma, muA, mu0, n, alpha, alternative = "two.tailed") {
    pow <- 0
    z <- (muA - mu0)/(sigma/sqrt(n))
    g <- ggplot(data.frame(mu = c(min(mu0 - 4 * sigma/sqrt(n), muA - 4 * sigma/sqrt(n)), 
        max(mu0 + 4 * sigma/sqrt(n), muA + 4 * sigma/sqrt(n)))), aes(x = mu)) + 
        ggtitle("Explore Power for Z Test")
    g <- g + ylim(c(0, max(dnorm(mu0, mu0, sigma/sqrt(n)) + 0.1, dnorm(muA, 
        muA, sigma/sqrt(n)) + 0.1)))
    g <- g + stat_function(fun = dnorm, geom = "line", args = list(mean = mu0, 
        sd = sigma/sqrt(n)), size = 1, col = "red", show.legend = TRUE)
    g <- g + stat_function(fun = dnorm, geom = "line", args = list(mean = muA, 
        sd = sigma/sqrt(n)), size = 1, col = "blue", show.legend = TRUE)
    
    if (alternative == "greater") {
        if (z > 0) {
            xcrit = mu0 + qnorm(1 - alpha) * sigma/sqrt(n)
            g <- g + geom_segment(x = xcrit, y = 0, xend = xcrit, yend = max(dnorm(mu0, 
                mu0, sigma/sqrt(n)) + 0.025, dnorm(muA, muA, sigma/sqrt(n)) + 
                0.025), size = 0.5, linetype = 3)
            g <- g + geom_polygon(data = data.frame(cbind(x = c(xcrit, seq(from = xcrit, 
                to = muA + 4 * sigma/sqrt(n), length.out = 100), muA + 4 * sigma/sqrt(n)), 
                y = c(0, dnorm(seq(from = xcrit, to = muA + 4 * sigma/sqrt(n), 
                  length.out = 100), mean = muA, sd = sigma/sqrt(n)), 0))), 
                aes(x = x, y = y), fill = "blue", alpha = 0.5)
            pow <- pnorm(muA + 4 * sigma/sqrt(n), muA, sigma/sqrt(n)) - pnorm(xcrit, 
                muA, sigma/sqrt(n))
        }
    }
    if (alternative == "less") {
        if (z < 0) {
            xcrit = mu0 - qnorm(1 - alpha) * sigma/sqrt(n)
            g <- g + geom_segment(x = xcrit, y = 0, xend = xcrit, yend = max(dnorm(mu0, 
                mu0, sigma/sqrt(n)) + 0.025, dnorm(muA, muA, sigma/sqrt(n)) + 
                0.025), size = 0.5, linetype = 3)
            g <- g + geom_polygon(data = data.frame(cbind(x = c(muA - 4 * sigma/sqrt(n), 
                seq(from = muA - 4 * sigma/sqrt(n), to = xcrit, length.out = 100), 
                xcrit), y = c(0, dnorm(seq(from = muA - 4 * sigma/sqrt(n), to = xcrit, 
                length.out = 100), mean = muA, sd = sigma/sqrt(n)), 0))), aes(x = x, 
                y = y), fill = "blue", alpha = 0.5)
            pow <- pnorm(xcrit, muA, sigma/sqrt(n)) - pnorm(muA - 4 * sigma/sqrt(n), 
                muA, sigma/sqrt(n))
        }
    }
    if (alternative == "two.tailed") {
        if (z > 0) {
            xcrit = mu0 + qnorm(1 - alpha/2) * sigma/sqrt(n)
            g <- g + geom_segment(x = xcrit, y = 0, xend = xcrit, yend = max(dnorm(mu0, 
                mu0, sigma/sqrt(n)) + 0.025, dnorm(muA, muA, sigma/sqrt(n)) + 
                0.025), size = 0.5, linetype = 3)
            g <- g + geom_polygon(data = data.frame(cbind(x = c(xcrit, seq(from = xcrit, 
                to = muA + 4 * sigma/sqrt(n), length.out = 100), muA + 4 * sigma/sqrt(n)), 
                y = c(0, dnorm(seq(from = xcrit, to = muA + 4 * sigma/sqrt(n), 
                  length.out = 100), mean = muA, sd = sigma/sqrt(n)), 0))), 
                aes(x = x, y = y), fill = "blue", alpha = 0.5)
            pow <- pnorm(muA + 4 * sigma/sqrt(n), muA, sigma/sqrt(n)) - pnorm(xcrit, 
                muA, sigma/sqrt(n))
        }
        if (z < 0) {
            xcrit = mu0 - qnorm(1 - alpha/2) * sigma/sqrt(n)
            g <- g + geom_segment(x = xcrit, y = 0, xend = xcrit, yend = max(dnorm(mu0, 
                mu0, sigma/sqrt(n)) + 0.025, dnorm(muA, muA, sigma/sqrt(n)) + 
                0.025), size = 0.5, linetype = 3)
            g <- g + geom_polygon(data = data.frame(cbind(x = c(muA - 4 * sigma/sqrt(n), 
                seq(from = muA - 4 * sigma/sqrt(n), to = xcrit, length.out = 100), 
                xcrit), y = c(0, dnorm(seq(from = muA - 4 * sigma/sqrt(n), to = xcrit, 
                length.out = 100), mean = muA, sd = sigma/sqrt(n)), 0))), aes(x = x, 
                y = y), fill = "blue", alpha = 0.5)
            pow <- pnorm(xcrit, muA, sigma/sqrt(n)) - pnorm(muA - 4 * sigma/sqrt(n), 
                muA, sigma/sqrt(n))
        }
    }
    g <- g + annotate("text", x = max(mu0, muA) + 2 * sigma/sqrt(n), y = max(dnorm(mu0, 
        mu0, sigma/sqrt(n)) + 0.075, dnorm(muA, muA, sigma/sqrt(n)) + 0.075), 
        label = paste("Effect Size = ", round((muA - mu0)/sigma, digits = 3), 
            "\nPower = ", round(pow, digits = 3), sep = ""))
    g <- g + annotate("text", x = min(mu0, muA) - 2 * sigma/sqrt(n), y = max(dnorm(mu0, 
        mu0, sigma/sqrt(n)) + 0.075, dnorm(muA, muA, sigma/sqrt(n)) + 0.075), 
        label = "Red = mu0\nBlue = muA")
    g
}
```

``` r
manipulate(power.plot(sigma, muA, mu0, n, alpha, alternative), sigma = slider(1, 
    10, step = 1, initial = 4), muA = slider(-10, 10, step = 1, initial = 2), 
    mu0 = slider(-10, 10, step = 1, initial = 0), n = slider(1, 50, step = 1, 
        initial = 16), alpha = slider(0.01, 0.1, step = 0.01, initial = 0.05), 
    alternative = picker("two.tailed", "greater", "less"))
```

In most cases, since we are dealing with limited samples from a population, we will want to use the t rather than the normal distibution as the basis for making our power evaluations. The `power.t.test()` function lets us easily implement power calculations based on the t distribution, and the results of using it should be very similar to those we found above by simulation. The `power.t.test()` function takes as possible arguments the sample size (*n*), the difference (delta, *δ*) between group means, the standard deviation of the data = sigma (*σ*), the sig.level = alpha (*α*), the test type ("two.sample", "one.sample", or "paired"), the alternative test to run ("two.sided", "one sidedd") and the power. Power, *n*, or the difference between means is left as null and the other arguments are specified. The function then calculate the missing argument.

#### CHALLENGE:

Using the code below, which graphs the Type II error rate (*β*) and Power (1 − *β*) for T tests (using the `power.t.test()` function), explore the effects of changing *α*, within sample variability (*σ*), and the difference between sample means (i.e., *μ*<sub>0</sub> and *μ*<sub>*A*</sub> for a one sample test (or, equivalently, *μ*<sub>1</sub> and *μ*<sub>2</sub> for a two sample test). The plot shows the effect size, given the difference between the means, (i.e., |(*μ*<sub>0</sub> − *μ*<sub>*A*</sub>)|/*σ*) and marks the sample size (*n*) needed to achieve a power of 0.8.

``` r
library(ggplot2)
library(manipulate)
power.test <- function(mu0, muA, sigma, alpha = 0.05, type, alternative) {
    p <- 0
    for (i in 2:200) {
        x <- power.t.test(n = i, delta = abs(muA - mu0), sd = sigma, sig.level = alpha, 
            power = NULL, type = type, alternative = alternative)
        p <- c(p, x$power)
    }
    d <- data.frame(cbind(1:200, p, 1 - p))
    critn <- 0
    for (i in 1:199) {
        if (p[i] < 0.8 && p[i + 1] >= 0.8) {
            critn <- i + 1
        } else {
            critn <- critn
        }
    }
    names(d) <- c("n", "power", "beta")
    g <- ggplot(data = d) + xlab("sample size n") + ylab("Type II Error Rate, Beta  (Red)\nand\nPower, 1-Beta (Blue)") + 
        ggtitle("Power for T Tests\n(assuming equal n and variance across the two groups)") + 
        ylim(0, 1) + geom_point(aes(x = n, y = power), colour = "blue", alpha = 1/2) + 
        geom_line(aes(x = n, y = power), colour = "blue", alpha = 1/2) + geom_line(aes(x = n, 
        y = 0.8), colour = "red", lty = 3) + geom_point(aes(x = n, y = beta), 
        colour = "red", alpha = 1/2) + geom_line(aes(x = n, y = beta), colour = "red", 
        alpha = 1/2) + geom_linerange(aes(x = critn, ymin = 0, ymax = 0.8), 
        colour = "blue", alpha = 1/4) + annotate("text", x = 150, y = 0.5, label = paste("Effect Size = ", 
        round(abs(mu0 - muA)/sigma, digits = 3), "\nCritical n = ", critn, sep = ""))
    print(g)
}
```

``` r
manipulate(power.test(mu0, muA, sigma, alpha, type, alternative), mu0 = slider(-10, 
    10, initial = 3, step = 1), muA = slider(-10, 10, initial = 0, step = 1), 
    sigma = slider(1, 10, initial = 3, step = 1), alpha = slider(0.01, 0.1, 
        initial = 0.05, step = 0.01), alternative = picker("two.sided", "one.sided"), 
    type = picker("two.sample", "one.sample", "paired"))
```
