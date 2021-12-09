library(ctmm)
library(curl)

data(buffalo)

# fit models for first two buffalo
B.GUESS <- lapply(buffalo[1:2], function(b) ctmm.guess(b,interactive=FALSE))
# using ctmm.fit here for speed, but you should almost always use ctmm.select
B.FITS <- lapply(1:2, function(i) ctmm.select(buffalo[[i]],B.GUESS[[i]]) ) #takes ~9mins to run this
names(B.FITS) <- names(buffalo[1:2])

# Gaussian overlap between these two buffalo
overlap(B.FITS)
# AKDE overlap between these two buffalo
# create aligned UDs
B.UDS <- akde(buffalo[1:2],B.FITS)
# evaluate overlap
overlap(B.UDS)

summary(B.UDS$Cilla)
summary(B.UDS$Gabs)

par(mfrow=c(1,2))
#95% Home Range (95% is the default)
#The middle contour represent the maximum likelihood area where the animal spends 95% of its time.
plot(buffalo[1:2], UD = B.UDS, col=rainbow(length(buffalo[1:2]))) 

#50% Home Range
#The middle contour represent the maximum likelihood area where the animal spends 50% of its time.
plot(buffalo[1:2], UD = B.UDS, level.UD = 0.5, col=rainbow(length(buffalo[1:2]))) 


```{r fit resid}
# calculate residuals
OU.RES <- residuals(coy1,M.OU)
OUF.RES <- residuals(coy1,M.OUF)

# scatter plot of residuals with 50%, 95%, and 99.9% quantiles
par(mfrow = c(1, 2))
plot(OU.RES,col.DF=NA,level.UD=c(.50,.95,0.999))
plot(OUF.RES,col.DF=NA,level.UD=c(.50,.95,0.999))
```


```{r correlogram}
# calculate correlogram of residuals
# increase the res argument to account for sampling variability
OU.ACF <- correlogram(OU.RES,res=15)
OUF.ACF <- correlogram(OUF.RES,res=15)

# plot 4 day's worth of lags
plot(OU.ACF[OU.ACF$lag<=5 %#% 'day',],fraction=1)
title('OU lags')
plot(OUF.ACF[OUF.ACF$lag<=5 %#% 'day',],fraction=1)
title('OUF lags')

zoom(OU.ACF[OU.ACF$lag<=5 %#% 'day',])
zoom(OUF.ACF[OUF.ACF$lag<=5 %#% 'day',])
```


