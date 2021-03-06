#' Estimate the three surfaces (for yHat, SE and ConcHat) as a function of DecYear and logQ and store in the three-dimensional object called surfaces
#'
#' This function uses weighted survival regression to estimate three surfaces that cover the complete range
#' of DecYear and log(Q) values in the Daily data set. 
#' These surfaces are:
#'   (1) is the estimated log concentration (yHat), 
#'   (2) is the estimated standard error (SE), 
#'   (3) is the estimated concentration (ConcHat). 
#' They are mapped as an array that covers the complete space of daily discharge and time. 
#' The first index is discharge, layed out in 14 equally spaced levels of log(Q).
#' The second index is time, layed out as 16 increments of the calendar year, starting January 1.
#'  It returns the 3 dimensional array called surfaces.
#'  This array will be used to estimate these 3 quantities for any given day in the daily values record. 
#'
#' @param localDaily string specifying the name of the data frame containing the daily values, default is Daily
#' @param localSample string specifying the name of the data frame containing the sample values, default is Sample
#' @param windowY numeric specifying the half-window width in the time dimension, in units of years, default is 10
#' @param windowQ numeric specifying the half-window width in the discharge dimension, units are natural log units, default is 2
#' @param windowS numeric specifying the half-window with in the seasonal dimension, in units of years, default is 0.5
#' @param minNumObs numeric specifying the miniumum number of observations required to run the weighted regression, default is 100
#' @param minNumUncen numeric specifying the minimum number of uncensored observations to run the weighted regression, default is 50
#' @keywords water-quality statistics
#' @import survival
#' @return surfaces array containing the three surfaces estimated, array is 3 dimensional
#' @export
#' @examples
#' Daily <- exDaily
#' Sample <- exSample
#' surfaces <- estSurfaces()
estSurfaces<-function(localDaily = Daily, localSample = Sample, windowY=10,windowQ=2,windowS=0.5,minNumObs=100,minNumUncen=50){
  # this function estimates the 3 surfaces based on the Sample data
  # one is the estimated log concentration (yHat)
  # the second is the estimated standard error (SE)
  # the third is the estimated concentration (ConcHat)
  # they are mapped as an array that covers the complete space of daily discharge and time
  # the first index is discharge, layed out in 14 equally spaced levels of log(Q)
  # the second index is time, layed out as 16 increments of the calendar year, starting January 1.
  # it returns the data frame called surfaces 
  #
  bottomLogQ<-min(localDaily$LogQ) - 0.05
  topLogQ<-max(localDaily$LogQ) + 0.05
  stepLogQ<-(topLogQ-bottomLogQ)/13
  vectorLogQ<-seq(bottomLogQ,topLogQ,stepLogQ)
  stepYear<-1/16
  bottomYear<-floor(min(localDaily$DecYear))
  topYear<-ceiling(max(localDaily$DecYear))
  vectorYear<-seq(bottomYear,topYear,stepYear)
  nVectorYear<-length(vectorYear)
  estPtLogQ<-rep(vectorLogQ,nVectorYear)
  estPtYear<-rep(vectorYear,each=14)

  resultSurvReg<-runSurvReg(estPtYear,estPtLogQ,localSample,windowY,windowQ,windowS,minNumObs,minNumUncen)
  
  surfaces<-array(0,dim=c(14,nVectorYear,3))

  for(iQ in 1:14) {
    for(iY in 1:nVectorYear){ 
      k<-(iY-1)*14+iQ
      surfaces[iQ,iY,]<-resultSurvReg[k,]
    }
  }

  return(surfaces)
}