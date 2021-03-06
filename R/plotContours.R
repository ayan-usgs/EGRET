#' Color contour plot of the estimated surfaces as a function of discharge and time (surfaces include log concentration, standard error, and concentration)
#'
#' These plots are normally used for plotting the estimated concentration surface (whatSurface=3) but can be used to explore the 
#' estimated surfaces for the log of concentration or for the standard error (in log space) which is what determines the bias correction. 
#' The plots are often more interpretable when the time limits are only about 4 years apart.
#' To explore changes over a long time period it is best to do this multiple times, for various time slices of 4 years (for example) or to use the function plotDiffContours.
#'
#' @param yearStart numeric value for the starting date for the graph, expressed as decimal year (typically whole number such as 1989.0)
#' @param yearEnd numeric value for the ending date for the graph, expressed as decimal year, (for example 1993.0)
#' @param qBottom numeric value for the bottom edge of the graph, expressed in the units of discharge that are being used (as specified in qUnit)
#' @param qTop numeric value for the top edge of the graph, expressed in the units of discharge that are being used (as specified in qUnit)
#' @param whatSurface numeric value, can only accept 1, 2, or 3;  whatSurface=1 is yHat (log concentration), whatSurface=2 is SE (standard error of log concentration), and whatSurface=3 is ConcHat (unbiased estimate of concentration), default = 3
#' @param localsurfaces string specifying the name of the matrix that contains the estimated surfaces, default is surfaces
#' @param localINFO string specifying the name of the data frame that contains the metadata, default name is INFO
#' @param localDaily string specifying the name of the data frame that contains the daily data, default name is Daily
#' @param qUnit object of qUnit class. \code{\link{qConst}}, or numeric represented the short code, or character representing the descriptive name. 
#' @param contourLevels numeric vector containing the contour levels for the contour plot, arranged in ascending order, default is NA (which causes the contour levels to be set automatically, based on the data)
#' @param span numeric, it is the half-width (in days) of the smoothing window for computing the flow duration information, default = 60
#' @param pval numeric, the probability value for the lower flow frequency line on the graph
#' @param printTitle logical variable if TRUE title is printed, if FALSE not printed 
#' @param vert1 numeric, the location in time for a black vertical line on the figure, yearStart<vert1<yearEnd, default is NA (vertical line is not drawn) 
#' @param vert2 numeric, the location in time for a black vertical line on the figure, yearStart<vert2<yearEnd, default is NA (vertical line is not drawn)
#' @param horiz numeric, the location in discharge for a black horizontal line on the figure, qBottom<vert1<qTop, default is NA (no horizontal line is drawn)
#' @param \dots arbitrary functions sent to the generic plotting function.  See ?par for details on possible parameters
#' @param flowDuration logical variable if TRUE plot the flow duration lines, if FALSE do not plot them, default = TRUE
#' @keywords water-quality statistics graphics
#' @export
#' @examples 
#' yearStart<-2001
#' yearEnd<-2010
#' qBottom<-0.2
#' qTop<-20
#' clevel<-seq(0,2,0.5)
#' INFO <- exINFO
#' Daily <- exDaily
#' surfaces <- exsurfaces
#' plotContours(yearStart,yearEnd,qBottom,qTop, contourLevels = clevel)  
plotContours<-function(yearStart, yearEnd, qBottom, qTop, whatSurface = 3, 
                       localsurfaces = surfaces, localINFO = INFO, localDaily = Daily, 
                       qUnit = 2, contourLevels = NA, span = 60, pval = 0.05, 
                       printTitle = TRUE, vert1 = NA, vert2 = NA, horiz = NA, 
                       flowDuration = TRUE, ...) {
  #  This funtion makes a contour plot 
  #  x-axis is bounded by yearStart and yearEnd
  #  y-axis is bounded by qBottom and qTop (in whatever discharge units are specified by qUnit)
  #  whatSurface specifies which of three surfaces to plot
  #     1 is the yHat surface (log concentration)
  #     2 is the SE surface (standard error of log concentration)
  #     3 is the ConcHat (unbiased estimate of Concentration)
  #  surf is the name of the data frame that contains the three surfaces, typically it is surfaces
  #  info is the name of the data frame that contains the indexing parameters for the surfaces, typically it is INFO
  #  qUnit is the units of discharge to be used in the graphic: 1 is cfs, 2 is cms, 3 is 10^3 cfs, and 4 is 10^3 cms
  #  contourLevels the default is NA (which lets the program set up the contour intervals)
  #    if you want to set the contourLevels then you need to define a vector containing the limits of the contour intervals
  #    for example, to have 4 levels we could say > contourLevels<-c(0,0.5,1,1.5,2)  or > contourLevels<-seq(0,2,0.5)
  #    note that the length of contourLevels is the number of intervals plus 1
  #  span is a smoothing parameter for the flow duration information, if it is too jagged you can increase it to smooth it out
  #      note that it doesn't influence any calculations, just the appearance of the figure
  #  pval is the lower flow frequency for the flow duration information
  #     pval = 0.05 means that the lines will be at the 5 and 95%tiles of the flow distribution
  #       other options could be pval=0.01 (for 1 and 99) or pval=10 (for 10 and 90)
  #     pval must be greater than zero and less than 0.5
  #   printTitle is a logical variable to indicate if a title is desired
  #   vert1 defines the location of a vertical black line that represents a given date
  #         this is often useful in explaining the meaning of the contour plot
  #       vert1 must be between yearStart and yearEnd and it is expressed as a decimal year, 
  #       for example 1July1998 would be vert1=1998.5
  #       the default is no vertical line
  #   vert2 is the location of a second vertical line (used so that two points in time can be compared)
  #   horiz is the location of a horizontal line at some specified discharge (helpful in discussing changes over time)
  #        it must be between qBottom and qTop and is defined in the units specified by qUnit
  #        the default is no vertical line
  ################################################################################
  # I plan to make this a method, so we don't have to repeat it in every funciton:
  if (is.numeric(qUnit)){
    qUnit <- qConst[shortCode=qUnit][[1]]
  } else if (is.character(qUnit)){
    qUnit <- qConst[qUnit][[1]]
  }
  ################################################################################
  par(oma=c(6,1,6,0))
  par(mar=c(5,5,4,2)+0.1)
  surfaceName<-c("log of Concentration","Standard Error of log(C)","Concentration")
  j<-3
  j<-if(whatSurface==1) 1 else j
  j<-if(whatSurface==2) 2 else j
  surf<-localsurfaces
  surfaceMin<-min(surf[,,j])
  surfaceMax<-max(surf[,,j])
  surfaceSpan<-c(surfaceMin,surfaceMax)
  contourLevels<-if(is.na(contourLevels[1])) pretty(surfaceSpan,n=5) else contourLevels
  # computing the indexing of the surface, the whole thing, not just the part being plotted
  bottomLogQ<-localINFO$bottomLogQ
  stepLogQ<-localINFO$stepLogQ
  nVectorLogQ<-localINFO$nVectorLogQ
  bottomYear<-localINFO$bottomYear
  stepYear<-localINFO$stepYear
  nVectorYear<-localINFO$nVectorYear
  x<-((1:nVectorYear)*stepYear) + (bottomYear - stepYear)
  y<-((1:nVectorLogQ)*stepLogQ) + (bottomLogQ - stepLogQ)
  yLQ<-y
  qFactor<-qUnit@qUnitFactor
  y<-exp(y)*qFactor
  numX<-length(x)
  numY<-length(y)
  qBottom<-max(0.9*y[1],qBottom)
  qTop<-min(1.1*y[numY],qTop)
  xSpan<-c(yearStart,yearEnd)
  xTicks<-pretty(xSpan,n=5)
  yTicks<-logPretty3(qBottom,qTop)
  nYTicks<-length(yTicks)
  surfj<-surf[,,j]
  surft<-t(surfj)
  # the next section does the flow duration information, using the whole period of record in Daily, not just the graph period
  plotTitle<-if(printTitle) paste(localINFO$shortName,"  ",localINFO$paramShortName,"\nEstimated",surfaceName[j],"Surface in Color") else ""
  if(flowDuration) {
    numDays<-length(localDaily$Day)
    freq<-rep(0,nVectorLogQ)
    durSurf<-rep(0,nVectorYear*nVectorLogQ)
    dim(durSurf)<-c(nVectorYear,nVectorLogQ)
    centerDays<-seq(1,365,22.9)
    centerDays<-floor(centerDays)
    for (ix in 1:16) {
      startDay<-centerDays[ix]-span
      endDay<-centerDays[ix]+span
      goodDays<-seq(startDay,endDay,1)
      goodDays<-ifelse(goodDays>0,goodDays,goodDays+365)
      goodDays<-ifelse(goodDays<366,goodDays,goodDays-365)
      numDays<-length(localDaily$Day)
      isGood<-rep(FALSE,numDays)
      for(i in 1:numDays) {
        count<-ifelse(localDaily$Day[i]==goodDays,1,0)
        isGood[i]<-if(sum(count)>0) TRUE else FALSE
      }
      spanDaily<-data.frame(localDaily,isGood)
      spanDaily<-subset(spanDaily,isGood)
      n<-length(spanDaily$Day)
      LogQ<-spanDaily$LogQ
      for(jQ in 1:nVectorLogQ) {
        ind<-ifelse(LogQ<yLQ[jQ],1,0)
        freq[jQ]<-sum(ind)/n
      }
      xInd<-seq(ix,numX,16)
      numXind<-length(xInd)
      for(ii in 1:numXind) {
        iX<-xInd[ii]
        durSurf[iX,]<-freq
      }
    }
    plevels<-c(pval,1-pval)
    pct1<-format(plevels[1]*100,digits=2)
    pct2<-format(plevels[2]*100,digits=2)
    plotTitle<-if(printTitle) paste(localINFO$shortName,"  ",localINFO$paramShortName,"\nEstimated",surfaceName[j],"Surface in Color\nBlack lines are",pct1,"and",pct2,"flow percentiles") else ""
  }
  # setting up for the possible 3 straight lines to go on the graph
  # if the lines aren't being plotted they are just located outside the plot area
  vectorNone<-c(yearStart,log(yTicks[1],10)-1,yearEnd,log(yTicks[1],10)-1)
  v1<-if(is.na(vert1)) vectorNone else c(vert1,log(yTicks[1],10),vert1,log(yTicks[nYTicks],10))
  v2<-if(is.na(vert2)) vectorNone else c(vert2,log(yTicks[1],10),vert2,log(yTicks[nYTicks],10))
  h1<-if(is.na(horiz)) vectorNone else c(yearStart,log(horiz,10),yearEnd,log(horiz,10))
  
  yLab<-qUnit@qUnitExpress
  filled.contour(x,log(y,10),surft,levels=contourLevels,xlim=c(yearStart,yearEnd),ylim=c(log(yTicks[1],10),log(yTicks[nYTicks],10)),main=plotTitle,xlab="",ylab=yLab,xaxs="i",yaxs="i",cex.main=0.95,
                 plot.axes={
                   axis(1,tcl=0.5,at=xTicks,labels=xTicks)
                   axis(2,tcl=0.5,las=1,at=log(yTicks,10),labels=yTicks)
                   axis(3, tcl = 0.5, at = xTicks, labels =FALSE)
                   axis(4, tcl = 0.5, at = log(yTicks, 10), labels=FALSE)
                   if(flowDuration) contour(x,log(y,10),durSurf,add=TRUE,drawlabels=FALSE,levels=plevels)
                   segments(v1[1],v1[2],v1[3],v1[4])
                   segments(v2[1],v2[2],v2[3],v2[4])
                   segments(h1[1],h1[2],h1[3],h1[4])
                 }, ...)
  par(oma=c(0,0,0,0))
  par(mar=c(5,4,4,2)+0.1)
}