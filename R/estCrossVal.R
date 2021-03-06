#' Jack-Knife cross validation of the WRTDS (Weighted Regressions on Time, Discharge, and Season)
#'
#' This function fits the WRTDS model n times (where n is the number of observations).  
#' For each fit, the data value being estimated is eliminated from the record. 
#' This gives predictions that do not depend on knowing the actual result for that day. 
#' Thus it provides for a more "honest" estimate of model performance than a traditional 
#' error analysis that uses all the data. 
#'
#' @param SampleCrossV string specifying the name of the data frame containing the sample values, default is Sample
#' @param windowY numeric specifying the half-window width in the time dimension, in units of years, default is 10
#' @param windowQ numeric specifying the half-window width in the discharge dimension, units are natural log units, default is 2
#' @param windowS numeric specifying the half-window with in the seasonal dimension, in units of years, default is 0.5
#' @param minNumObs numeric specifying the miniumum number of observations required to run the weighted regression, default is 100
#' @param minNumUncen numeric specifying the minimum number of uncensored observations to run the weighted regression, default is 50
#' @keywords water-quality statistics
#' @import survival
#' @return SampleCrossV data frame containing the sample data augmented by the results of the cross-validation exercise
#' @export
#' @examples
#' Sample <- exSample
#' SampleCrossV <- estCrossVal()
estCrossVal<-function(SampleCrossV = Sample, windowY = 10, windowQ = 2, windowS = 0.5, minNumObs = 100, minNumUncen = 50){
  #  this function fits the WRTDS model making an estimate of concentration for every day
  #    But, it uses leave-one-out-cross-validation
  #    That is, for the day it is estimating, it leaves that observation out of the data set
  #      It returns a Sample data frame with three added columns
  #      yHat, SE, and ConcHat
  numObs<-length(SampleCrossV$DecYear)
  yHat<-rep(0,numObs)
  SE<-rep(0,numObs)
  ConcHat<-rep(0,numObs)
  iCounter<-seq(1,numObs)
  cat("\n estCrossVal % complete:\n")
  SampleCV<-data.frame(SampleCrossV,iCounter,yHat,SE,ConcHat)

  printUpdate <- floor(seq(1,numObs,numObs/100))
  
  for(i in 1:numObs) {
    if(i %in% printUpdate) cat(floor(i*100/numObs),"\t")
#     SampleCV$keep<-ifelse(SampleCV$iCounter==i,FALSE,TRUE)
#     SampleMinusOne<-subset(SampleCV,keep)
    #This is ever-so-slightly faster:
    SampleMinusOne<-SampleCV[SampleCV$iCounter!=i,]
    
    result<-runSurvReg(SampleCrossV$DecYear[i],SampleCrossV$LogQ[i],SampleMinusOne,windowY,windowQ,windowS,minNumObs,minNumUncen,message=FALSE)
    
    SampleCrossV$yHat[i]<-result[1]
    SampleCrossV$SE[i]<-result[2]
    SampleCrossV$ConcHat[i]<-result[3]
  }	
  return(SampleCrossV)
}