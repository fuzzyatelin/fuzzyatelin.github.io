library(devtools)
devtools::install_github("ctmm-initiative/ctmm")
library(ctmm)
library(dplyr)
library(rlist)
# Loading in data

setwd("C:/Users/fshor/OneDrive/Desktop/Project Design in BioAnthro/Create a Module")
data=read.csv("Site fidelity in cougars and coyotes, Utah_Idaho USA (data from Mahoney et al. 2016)-gps.csv")



data=as.telemetry(data)
data=data[c(1,4)]
data=data[-2]
plot(data[[1]])
#removing outliers. Uses ctmm in-built function to detect points with excessively high speeds. 

OUT <- outlie(data[[1]],standardize=FALSE,plot=TRUE)
plot(OUT, level= 0.95, units=TRUE)
BAD <- which.max(OUT$speed)
data[[1]] <- data[[1]][-BAD,]

#fitting model

dt=c(3600,10800,14400)
control=list(method="pNewton",cores=2)
proto=ctmm(error=5,circle=FALSE)
# At suaq we decided an error of 15, whereas at Tuanan I believe it is 10. 

variograms=lapply(1:1,function(i) variogram(data[[i]]))
plot(variograms[[1]],fraction = 0.5)
guess=lapply(1:1,function(i) ctmm.guess(data[[i]], CTMM=proto,variogram=variograms[[i]],interactive=FALSE))
fits=lapply(1:1,function(i) ctmm.fit(data[[i]],guess[[i]],control=control))
summary(fits)

#if doing individually
fits<-ctmm.select(data[[1]],guess[[1]],control=control)
#plotting variogram and fit to see accuracy
plot(variograms[[1]],CTMM=fits,fraction= 0.5)

#Creating monthly AKDE from fitted model
uds=lapply(1:1,function(i) akde(data[[1]], fits))

#Plotting AKDE for CO28 (coyote)
plot(uds)

#AKDE area for CO28 (coyote
summary(uds[[1]])

#Printing AKDE Results
udsFlSuaqAll<-lapply(1:24,function(i) summary(uds[[i]]))
dfUdsFlSuaqAll<-data.frame(matrix(unlist(udsFlSuaqAll), nrow=24, byrow=TRUE),stringsAsFactors=FALSE)
colnames(dfUdsFlSuaqAll) <- c("area","bandwidth","akde.min","akde.estimate","akde.max")
write.csv(dfUdsFlSuaqAll, file="SuaqFllAKDEAll.csv")

#This is used for calculating distance traveled in a day. We likely won't use this in our module, but it is an option.
res=c()
speeds=c()
count=1
for(i in 26:27) {
  days=unique(data[[i]]$Day)
  print(data[[i]]@info$identity)
  try( for(j in 1:length(days)){
    #select data for day#
    possibleError=tryCatch({
      data.subset= data[[i]][which(data[[i]]$Day==days[j]),]
      date=as.character(as.Date(data.subset$timestamp[1]))
      message("estimating distance traveled on day",j,":",date)
      id=data[[i]]@info$identity
      #calculating duration of sampling period#
      samp.time=diff(c(data.subset$t[1],data.subset$t[nrow(data.subset)]))
      guess=ctmm.guess(data[[i]],CTMM=proto,variogram=variograms[[i]],interactive=FALSE)
      fits=ctmm.fit(data.subset,CTMM=guess,method="pHREML",control=list(method="pNewton",cores=-1))
      ctmm_speed=speed(object=data.subset,CTMM=fits,units=FALSE)
      ctmm_dist=ctmm_speed*samp.time
      print(ctmm_dist[2])
      rownames(ctmm_dist)="distance(meters)"
      x=c(i,ctmm_dist[2],ctmm_dist[1],ctmm_dist[3],date,id)
      names(x)=c("day","ctmm.estimate","ctmm.min","ctmm.max","date","id")
      res[count]=list(x)
      count = count + 1
    },error=function(e)e)
    if(inherits(possibleError,"error"))next
  })
  #res=as.data.frame(do.call(rbind,res))
  #   speeds[i]=list(res)
}
speeds=do.call(rbind,res)
speeds=as.data.frame(speeds)
write.csv(speeds,file="FlangedDailyPathLengthsTuanan.csv")




