AN597: Homework 04
================

------------------------------------------------------------------------

### [Course Outline](https://fuzzyatelin.github.io/bioanth-stats/outline.html)

### [Course Overview](https://fuzzyatelin.github.io/bioanth-stats/overview.html)

### [Modules](https://fuzzyatelin.github.io/bioanth-stats/modules.html)

### [Resources](https://fuzzyatelin.github.io/bioanth-stats/resources.html)

### [Policies](https://fuzzyatelin.github.io/bioanth-stats/policies.html)

### [Coding Problems](https://fuzzyatelin.github.io/bioanth-stats/studentproblems.html)

------------------------------------------------------------------------

<center>
DUE 2017-10-23 at 2pm
---------------------

<br>
<center>
<p>
<img src="https://i.pinimg.com/originals/22/50/6e/22506e027fd83560ff8b18c502a2b3fc.gif" style="border:5px solid black">
</p>
</center>
<br>

Using a new `.Rmd` file and pushing both the markdown and knitted `.html` file to a new repository named "homework-week-6" on your *GitHub* page, answer the following questions:

### \[1\] Write a simple R function, `Z.prop.test()`, that can perform one- or two-sample Z-tests for proportion data, using the following guidelines.

-   Your function should take the following arguments: **p1** and **n1** (no default) representing the estimated proportion and sample size (i.e., based on your sample data); **p2** and **n2** (both defaulting to NULL) that contain a second sample's proportion and sample size data in the event of a two-sample test; **p0** (no default) as the expected value for the population proportion; and **alternative** (default "two.sided") and **conf.level** (default 0.95), to be used in the same way as in the function `t.test()`.
-   When conducting a two-sample test, it should be **p1** that is tested as being smaller or larger than **p2** when alternative="less" or alternative="greater", the same as in the use of x and y in the function `t.test()`.
-   The function should perform a one-sample Z-test using **p1**, **n1**, and **p0** if either **p2** or **n2** (or both) is NULL.
-   The function should contain a check for the rules of thumb we have talked about (*n* \* *p* &gt; 5 and *n* \* (1 − *p*)&gt;5) to ensure the validity of assuming the normal distribution in both the one- and two-sample settings. If this is violated, the function should still complete but it should also print an appropriate warning message.
-   The function should return a list containing the members **Z** (the test statistic), **P** (the appropriate p value), and **CI** (the two-sided CI with respect to "conf.level" around **p1** in the case of a one-sample test and around **p2-p1** in the case of a two-sample test). For all test alternatives ("two.sided", "greater", "less"), calculate symmetric CIs based on quantiles of the normal distribution rather than worrying about calculating single-limit confidence bounds.

### \[2\] The dataset from Kamilar and Cooper has in it a large number of variables related to life history and body size. For this exercise, the end aim is to fit a simple linear regression model to predict longevity (`MaxLongevity_m`) measured in months from species' brain size (`Brain_Size_Species_Mean`) measured in grams. Do the following for both `longevity~brain size` and `log(longevity)~log(brain size)`.

-   Fit the regression model and, using {ggplot2}, produce a scatterplot with the fitted line superimposed upon the data. Append the the fitted model equation to your plot (HINT: use the function `geom_text()`).
-   Identify and interpret the point estimate of the slope (*β*<sub>1</sub>), as well as the outcome of the test associated with the hypotheses H0: *β*<sub>1</sub> = 0; HA: *β*<sub>1</sub> ≠ 0. Also, find a 90 percent CI for the slope (*β*<sub>1</sub>) parameter.
-   Using your model, add lines for the 90 percent confidence and prediction interval bands on the plot and add a legend to differentiate between the lines.
-   Produce a point estimate and associated 90 percent PI for the longevity of a species whose brain weight is 800 gm. Do you trust the model to predict observations accurately for this value of the explanatory variable? Why or why not?
-   Looking at your two models, which do you think is better? Why?
