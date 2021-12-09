library(ctmm)

### DATA PREPARATION ###

# load the Mongolian gazelle (Procapra gutturosa) data from Movebank
# this dataset consists of observations of 36 individual animals
data("gazelle")
data.tm  <- gazelle
n.indivs <- length(data.tm)

### IDENTIFICATION OF RANGE-RESIDENT SUBPOPULATION ###

# visually inspect each trajectory for evidence of range-resident behavior
rr <- vector("character")
for(i.indiv in seq(1, n.indivs)) {
  indiv.id <- data.tm[[i.indiv]]@info$identity

  par(mfrow=c(1,2))
  # note: layering the movement over satellite imagery can be very helpful
  #       but is not done here

  # plot the raw movement data
  plot(data.tm[[i.indiv]], type='l',
       main=indiv.id)

  # plot the variogram
  # for additional information on how to interpret variograms see
  # vignette("variogram", package="ctmm")
  SVF = variogram(data.tm[[i.indiv]])
  plot(SVF, fraction=0.85, level=c(0.5, 0.95))

  # read a single character ('y' means accept as rr, else reject)
  decision <- readline(prompt = sprintf("Is %s rr? y/(n): ", indiv.id))
  if(decision == 'y')
    rr <- c(rr, indiv.id)
}

# in the experiments we present, we selected the following 23 animals as rr:
rr <- c("583657A", "601607A", "602190A", "618663B", "618665A", "618666A",
        "618667A", "618669B", "618672A", "618673A", "618674A", "618675A",
        "618677A", "618680A", "631724A", "631726A", "631728A", "631731A",
        "631733A", "631737A", "631741A", "631742A", "631747A")

# remove non-range resident individuals
data.tm  <- data.tm[sapply(data.tm, function(t) t@info$identity) %in% rr]
n.indivs <- length(data.tm)

### FIT A MOVEMENT MODEL TO EACH INDIVIDUAL ###

models <- list()
for(i.indiv in seq(1, n.indivs)) {
  indiv.id <- data.tm[[i.indiv]]@info$identity
  cat(sprintf("Fitting model for %s\n", indiv.id))
  
  # start with a reasonable initial guess
  guess <- ctmm.guess(data.tm[[i.indiv]], interactive=FALSE)
  
  FITS <- ctmm.select(data.tm[[i.indiv]], 
                      CTMM    = guess,
                      verbose = TRUE,
                      level   = 1,
                      method  = "pHREML",
                      control=list(method="pNewton",zero=TRUE))
  
  # store the model with the lowest AICc
  models[[indiv.id]] <- FITS[[1]]
}

### COMPUTE THE OVERLAP BETWEEN EACH PAIR OF ANIMALS ###

cat("Computing overlap of all pairs\n")
overlap.CIs <- overlap(data.tm, models, weights=TRUE, debias=TRUE)

### ANALYSIS ###

## example 1 ##
# list each pair of individuals and the three CI components
ut <- upper.tri(overlap.CIs[,,1], diag=FALSE)
overlap.df <- data.frame(i=rep(rownames(overlap.CIs), 
                               ncol(overlap.CIs))[as.vector(ut)],
                         j=rep(colnames(overlap.CIs), 
                               each=nrow(overlap.CIs))[as.vector(ut)],
                         lower=overlap.CIs[,,1][ut],
                         ml   =overlap.CIs[,,2][ut],
                         upper=overlap.CIs[,,3][ut])

# find a pair where the CI includes 0.01 and one that is above 0.01
example.weak   <- Position(function(x) x < 0.01, overlap.df$lower)
example.strong <- Position(function(x) x > 0.01, overlap.df$lower)

ids.weak   <- c(toString(overlap.df[example.weak,'i']),
                toString(overlap.df[example.weak,'j']))
ids.strong <- c(toString(overlap.df[example.strong,'i']), 
                toString(overlap.df[example.strong,'j']))

# compute the UDs for each pair
data.weak   <- data.tm[ids.weak]
data.strong <- data.tm[ids.strong]
models.weak   <- models[ids.weak]
models.strong <- models[ids.strong]
UDs.weak   <- akde(data.weak,   models.weak,   weights = TRUE)
UDs.strong <- akde(data.strong, models.strong, weights = TRUE)

# plot the UDs of each example
col <- c("red", "blue")
par(mfrow=c(1,2))
plot(data.weak, UD=UDs.weak,
     main=sprintf("{%s,%s}: BC = (%.3f, %.3f, %.3f)", 
                  ids.weak[1], ids.weak[2], 
                  overlap.df[example.weak, 'lower'], 
                  overlap.df[example.weak, 'ml'],
                  overlap.df[example.weak, 'upper']),
     col=col, col.DF=col, col.grid=NA, labels=NA)
plot(data.strong, UD=UDs.strong,
     main=sprintf("{%s,%s}: BC = (%.3f, %.3f, %.3f)", 
                  ids.strong[1], ids.strong[2],  
                  overlap.df[example.strong, 'lower'], 
                  overlap.df[example.strong, 'ml'],
                  overlap.df[example.strong, 'upper']),
     col=col, col.DF=col, col.grid=NA, labels=NA)

invisible(readline(prompt="Press Enter to continue..."))
