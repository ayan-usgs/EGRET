#' Plot up to three curves representing the log concentration versus discharge relationship, each curve is a different point in time
#'
#' These plots are like a vertical slice of the estimated concentration surface that is seen in the plotContours function.  
#' These plots show how the concentration-discharge relationship is changing over time. 
#' Typically the time points selected would be in three years at the same time of year spaced out over the period of record.  But that is not necessary.  
#' Another possibility is to use this to explore seasonal differences.  In this case the three
#' dates would be in the same year but different times during the year.
#'
#' @param date1 string specifying the date for the first curve on the graph, it is in the form "yyyy-mm-dd" (must be in quotes) 
#' @param date2 string specifying the date for the second curve on the graph, it is in the form "yyyy-mm-dd" (must be in quotes).  If only one curve is wanted this should be NA
#' @param date3 string specifying the date for the third curve on the graph, it is in the form "yyyy-mm-dd" (must be in quotes).  If a third curve is not wanted this should be NA
#' @param qLow numeric value for the lowest discharge to be considered, expressed in the units of discharge that are being used (as specified in qUnit)
#' @param qHigh numeric value for the highest discharge to be considered, expressed in the units of discharge that are being used (as specified in qUnit)
#' @param qUnit object of qUnit class. \code{\link{qConst}}, or numeric represented the short code, or character representing the descriptive name. 
#' @param legendLeft numeric which represents the left edge of the legend, in the units shown on x-axis of graph, default is 0, will be placed within the graph but may overprint data
#' @param legendTop numeric which represents the top edge of the legend, in the units shown on y-axis of graph, default is 0, will be placed within the graph but may overprint data
#' @param concMax numeric value for upper limit on concentration shown on the graph, default = NA (which causes the upper limit to be set automatically, based on the data)
#' @param concMin numeric value for lower limit on concentration shown on the graph, default = NA (which causes the lower limit to be set automatically, based on the data)
#' @param bw logical if TRUE graph is produced in black and white, default is FALSE (which means it will use color)
#' @param printTitle logical variable if TRUE title is printed, if FALSE not printed 
#' @param printValues logical variable if TRUE the results shown on the graph are also printed to the console (this can be useful for quantifying the changes seen visually in the graph), default is FALSE (not printed)
#' @param localSample string specifying the name of the data frame that contains the Sample data, default name is Sample
#' @param localINFO string specifying the name of the data frame that contains the metadata, default name is INFO
#' @param windowY numeric specifying the half-window width in the time dimension, in units of years, default is 10
#' @param windowQ numeric specifying the half-window width in the discharge dimension, units are natural log units, default is 2
#' @param windowS numeric specifying the half-window with in the seasonal dimension, in units of years, default is 0.5
#' @param cex.main magnification to be used for main titles relative to the current setting of cex
#' @param lwd line width, a positive number, defaulting to 1
#' @param \dots arbitrary graphical parameters that will be passed to genericEGRETDotPlot function (see ?par for options)
#' @keywords water-quality statistics graphics
#' @import survival
#' @export
#' @examples 
#' date1<-"2001-06-01"
#' date2<-"2009-06-01"
#' date3<-NA
#' qLow<-1
#' qHigh<-1000
#' Sample <- exSample
#' INFO <- exINFO
#' plotLogConcQSmooth(date1,date2,date3,qLow,qHigh)
plotLogConcQSmooth<-function(date1,date2,date3,qLow,qHigh,qUnit = 2, legendLeft = 0,
                             legendTop = 0, concMax = NA, concMin = NA, bw = FALSE, 
                             printTitle = TRUE, printValues = FALSE, 
                             localSample = Sample, localINFO = INFO, windowY = 10, 
                             windowQ = 2, windowS = 0.5, cex.main=1.1, lwd=2, ...) {
  ##################################################
  if (is.numeric(qUnit)) {
    qUnit <- qConst[shortCode = qUnit][[1]]
  }
  else if (is.character(qUnit)) {
    qUnit <- qConst[qUnit][[1]]
  }
  ################################################# 
  numDates<-3
  numDates<-if(is.na(date2)) 1 else 3
  numDates<-if(is.na(date3)) 2 else 3
  dates<-rep(as.POSIXlt(date1),3)
  dates[1]<-as.POSIXlt(date1)
  dates[2]<-as.POSIXlt(date2)
  dates[3]<-as.POSIXlt(date3)
  LogQLow<-log(qLow)
  LogQHigh<-log(qHigh)
  step<-(LogQHigh-LogQLow)/47
  x<-exp(seq(LogQLow,LogQHigh,step))
  qFactor<-qUnit@qUnitFactor
  LQ<-log(x/qFactor)
  # note the vector x is the set of 48 discharge values used to construct the curve, expressed in the selected units (such as cfs or 1000 cfs)
  # and the vector LQ is the same set of 48 discharge values but expressed in units of natural log of cubic meters per second
  y<-rep(NA,3*48)
  dim(y)<-c(3,48)
  day<-dates$yday + 1
  year<-dates$year + 1900
  decYear<-year+((day-0.5)/366)
  for(iCurve in 1:numDates) {
    yrs<-rep(decYear[iCurve],48)
    result<-runSurvReg(yrs,LQ,localSample,windowY = windowY, windowQ = windowQ, windowS = windowS,message=FALSE)
    y[iCurve,]<-result[,3]
  }
  title<-if(printTitle) paste (localINFO$shortName,"  ",localINFO$paramShortName,"\nEstimated Concentration Versus Discharge Relationship\nat",numDates,"specific dates") else ""
  xLab=qUnit@qUnitExpress
  yLab="Concentration in mg/L"
  #xTicks<-logPretty3(qLow,qHigh)
  #numXTicks<-length(xTicks)
  #xLeft<-xTicks[1]
  #xRight<-xTicks[numXTicks]
  yMax<-max(y,na.rm=TRUE)
  yTop<-if(is.na(concMax)) yMax else concMax
  #yMin<-min(y,na.rm=TRUE)
  #yBottom<-if(is.na(concMin)) yMin else concMin
  #yTicks<-logPretty3(yBottom,yTop)
  #numYTicks<-length(yTicks)
  #yTop<-yTicks[numYTicks]
  colorVal<-if(bw) c("black","black","black") else c("black","red","green")
  lineVal<-if(bw) c(1,2,3) else c(1,1,1)
  
  ######################
  
  xInfo <- generalAxis(x=x, minVal=qLow, maxVal=qHigh, log=TRUE)
  
  yInfo_n <- generalAxis(x=y[1,2,3,], minVal=min(y,na.rm=TRUE), maxVal=max(y,na.rm=TRUE), log=TRUE)

  genericEGRETDotPlot(x=x, y=y[1,],
                      xTicks=xInfo$ticks, yTicks=yInfo_n$ticks,
                      xlim=c(xInfo$bottom,xInfo$top),ylim=c(yInfo_n$bottom,yInfo_n$top),
                      xlab=xLab,ylab=yLab,plotTitle=title,
                      type="l",lwd=lwd,col=colorVal[1],lty=lineVal[1],cex.main=cex.main,
                      log="xy", ...
    )

  #par(new=TRUE)
  lines(x=x, y=y[2, ], lwd=lwd, col=colorVal[2], lty=lineVal[2], ...)


  #par(new=TRUE)
  lines(x=x, y=y[3, ], lwd=lwd, col=colorVal[3], lty=lineVal[3], ...)

#   plot(log(x,10),log(y[3,],10),axes=FALSE,xlim=c(log(xLeft,10),log(xRight,10)),xaxs="i",xlab="", ylim=c(log(yBottom,10), log(yTop,10)) ,yaxs="i",ylab="",main="",type="l",lwd=2,col=colorVal[3],lty=lineVal[3],cex=0.7,cex.main=1.1,font.main=2,cex.lab=1.2)
  legendLeft<-if(legendLeft==0) qLow*2 else legendLeft
#   legendLeft<-log(legendLeft,10)
  legendTop<-if(legendTop==0) 0.3*yInfo_n$top else legendTop
#   legendTop<-log(legendTop,10) 
  words<-as.character(dates[1:numDates])
  ltys<-lineVal[1:numDates]
  cols<-colorVal[1:numDates]
  legend(legendLeft,legendTop,legend=words,lty=ltys,col=cols,lwd=2,cex=1.5)
  printResults<-rep(NA,48*4)
  dim(printResults)<-c(48,4)
  for(j in 1:48) {printResults[j,1]<-format(x[j],width=9)
                  printResults[j,2:4]<-format(y[1:3,j],width=10)}
  topLine<-c("discharge",as.character(dates[1:numDates]))
  if(printValues) write(topLine,file="",ncolumns=4)
  if(printValues) write.table(printResults,file="",quote=FALSE,row.names=FALSE,col.names=FALSE) 
}