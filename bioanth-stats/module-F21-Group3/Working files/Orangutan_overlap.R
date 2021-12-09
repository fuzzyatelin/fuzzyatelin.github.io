##July 17 2020

#Load package:Continuous-Time Movement Modeling
library(ctmm)
#CTMM vignettes: https://cran.r-project.org/web/packages/ctmm/vignettes/akde.html

#Download only the months we are interested in from movebank as .csv files
#Note: Don't open the csv file in excel it will mess up the timestamps and you'll have to re-download it
#In this example I downloaded only Jan and Feb from 2016 for all orangutans

#First, set your working directory to wherever you've saved the downloaded orangutan data from movebank
#To set working directory: Click Session -> Set Working Directory -> Choose Location
#OR use the function setwd
setwd("C:/Users/black/Documents/Documents/BU Summer 2020/UROP 2020/movement data_July")

#Load the orangutan data. 
#R will read this data as a telemetry object, since the R package CTMM is specifically for movebank files, its very easy
GP_JAN16ctmm <- as.telemetry("GP_JAN_FEB_2016.csv")

#PUll out just BIB and WA into a new dataset
BIB_WA_JAN16<-GP_JAN16ctmm[c('BIB', 'WA')]

#Fit the movement models 
#NOTE: This can take a LONG time to run
GUESS_2 <- lapply(GP_JAN16ctmm[1:2], function(b) ctmm.guess(b,interactive=FALSE) )
#For subsetted datasets, pHREML more accurately captured long-term space use than ML or REML (Fleming et al. 2019)
FITS_BIB_WA_JAN16 <- lapply(1:2, function(i) ctmm.fit(BIB_WA_JAN16[[i]],GUESS_2[[i]], method="pHREML"))
names(FITS_BIB_WA_JAN16) <- names(BIB_WA_JAN16[1:2])

#Create autocorrelated Utilization Distributions for these Orangutans
#AKDE corrects for biases due to autocorrelation, small effective sample size, and irregular sampling in time
UDS_BIB_WA_JAN16 <- akde(BIB_WA_JAN16[1:2],FITS_BIB_WA_JAN16)

# This function calculates a useful measure of similarity between distributions 
# evaluate overlap of 95% Home Range
#The choice method="BA" computes the Bhattacharyya's affinity (BA)
#Values range from zero (no overlap) to 1 (identical Utilization Distributions).
# 95% level of confidence
overlap(UDS_BIB_WA_JAN16)

#summary of BIB's 95% AKDE UD 
summary(UDS_BIB_WA_JAN16$BIB)
#summary of WA's 95% AKDE UD
summary(UDS_BIB_WA_JAN16$WA)
  
#summary of BIB's 50% AKDE UD 
summary(UDS_BIB_WA_JAN16$BIB, level.UD=0.5)
#summary of WA's 50% AKDE UD 
summary(UDS_BIB_WA_JAN16$WA, level.UD=0.5)

#use the plot function to look at the orangutans AKDE UD
par(mfrow=c(1,1))
#95% Home Range (95% is the default)
#The middle contour represent the maximum likelihood area where the animal spends 95% of its time.
plot(BIB_WA_JAN16, UD=UDS_BIB_WA_JAN16, col=rainbow(length(BIB_WA_JAN16))) 

#50% Home Range
#The middle contour represent the maximum likelihood area where the animal spends 50% of its time.
plot(BIB_WA_JAN16, UD=UDS_BIB_WA_JAN16, level.UD=0.5, col=rainbow(length(BIB_WA_JAN16))) 

#IF you want to look at the orangutans' areas of use individually
plot(BIB_WA_JAN16, UD=UDS_BIB_WA_JAN16$BIB)
plot(BIB_WA_JAN16, UD=UDS_BIB_WA_JAN16$BIB, level.UD=0.5)
plot(BIB_WA_JAN16, UD=UDS_BIB_WA_JAN16$WA) 
plot(BIB_WA_JAN16, UD=UDS_BIB_WA_JAN16$WA, level.UD=0.5) 


#Estimate the CDE (conditional distribution of encounters) (Noonan et al., 2020)
#CDE is a concept describing the long-term encounter location probabilities for movement within home ranges
CDE_BIB_WA_JAN16 <- encounter(UDS_BIB_WA_JAN16)
CDE_BIB_WA_JAN16

plot(BIB_WA_JAN16,
     col=c("#FF0000", "#F2AD00"),
     UD=CDE_BIB_WA_JAN16,
     col.DF="#046C9A", 
     col.grid = NA)

    
#-----------------write to shapefiles for ArcMap/QGIS--------------------------
#Turn each orangutans utilization distribution into spatial polygons for export to ArcMap

#BIB 95% HR with 95% Confidence Interval
UDS_BIB_Jan16_sp_95<-SpatialPolygonsDataFrame.UD(UDS_BIB_WA_JAN16$BIB, d, driver = "ESRI Shapefile", level.UD=0.95,level=0.95, proj4string=proj4string)
#BIB 50% HR with 95% Confidence Interval
UDS_BIB_Jan16_sp_50<-SpatialPolygonsDataFrame.UD(UDS_BIB_WA_JAN16$BIB, d, driver = "ESRI Shapefile", level.UD=0.50,level=0.95, proj4string=proj4string)
#WA 95% HR with 95% Confidence Interval
UDS_WA_Jan16_sp_95<-SpatialPolygonsDataFrame.UD(UDS_BIB_WA_JAN16$WA, d, driver = "ESRI Shapefile", level.UD=0.95,level=0.95, proj4string=proj4string)
#WA 50% HR with 95% Confidence Interval
UDS_WA_Jan16_sp_50<-SpatialPolygonsDataFrame.UD(UDS_BIB_WA_JAN16$WA, d, driver = "ESRI Shapefile", level.UD=0.50,level=0.95, proj4string=proj4string)

#WA and BIB 95% CDE 
CDE_BIB_WA_JAN16_SP<-SpatialPolygonsDataFrame.UD(CDE_BIB_WA_JAN16, d, driver = "ESRI Shapefile", level.UD=0.95,level=0.95, proj4string=proj4string)

#load the package rgdal
library(rgdal)

#Export as shapefiles (it will save to wherever you've set your working directory)

#BIB
writeOGR(UDS_BIB_Jan16_sp_95, dsn=".", "UDS_BIB_Jan16_sp_95", driver="ESRI Shapefile")
writeOGR(UDS_BIB_Jan16_sp_50, dsn=".", "UDS_BIB_Jan16_sp_50", driver="ESRI Shapefile")
#WA
writeOGR(UDS_WA_Jan16_sp_95, dsn=".", "UDS_WA_Jan16_sp_95", driver="ESRI Shapefile")
writeOGR(UDS_WA_Jan16_sp_50, dsn=".", "UDS_WA_Jan16_sp_50", driver="ESRI Shapefile")

#CDE (Intersection of BIB & WA)
writeOGR(CDE_BIB_WA_JAN16_SP, dsn=".", "CDE_BIB_WA_JAN16_SP", driver="ESRI Shapefile")
