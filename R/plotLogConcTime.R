#' Sample data plot: log of concentration vs. time
#'
#' Concentration data come from a data frame named Sample which contains the sample data. 
#' The metadata come from a data frame named INFO. 
#' This function allows the user to plot all of the data, but also to limit it in two ways. 
#'   The data can be limited to only those observed concentrations collected in a specified discharge range. 
#'   The data can also be limited to only those observed in certain months of the year. 
#'     These two selection criteria can be combined, for example, 
#'     we may only want to plot data for discharges between 100 and 500 cubic feet per second in the months of March, April and May. 
#' There is also a version of this using an arithmetic scale for concentration, plotConcTime. 
#'
#' @param localSample string specifying the name of the data frame that contains the concentration data, default name is Sample
#' @param localINFO string specifying the name of the data frame that contains the metadata, default name is INFO
#' @param qUnit object of qUnit class \code{\link{qConst}}, or numeric representing the short code, or character representing the descriptive name.
#' @param qLower numeric the lower bound on values of discharge used to select the data points to be plotted, units are those specified by qUnit, default = NA which is equivalent to a lower bound of zero but if the desired lower bound is zero use qLower = NA
#' @param qUpper numeric the upper bound on values of discharge for selection of data points to be plotted, units are those specified by qUnit, default = NA which is equivalent to an upper bound of infinity
#' @param paLong numeric, this is the length of the portion of the year from which data should be included in the plot, paLong must be an integer between 1 and 12.  The default is 12, which prints data from all months.
#' @param paStart numeric, this is the starting month of the portion of the year from which data should be included in the plot, paStart must be an integer between 1 and 12.  The default is 10, which corresponds to the water year, which starts in October.  If paLong = 12 then the choice of paStart is of no consequence.  All months will be included.
#' @param tinyPlot logical variable, if TRUE plot is designed to be plotted small as part of a multipart figure, default is FALSE.
#' @param concMax numeric specifying the maximum value to be used on the vertical axis, default is NA (which allows it to be set automatically by the data)
#' @param concMin numeric specifying the minimum value to be used on the vertical axis, default is NA (which allows it to be set automatically by the data)
#' @param printTitle logical variable if TRUE title is printed, if FALSE not printed (this is best for a multi-plot figure)
#' @param \dots arbitrary functions sent to the generic plotting function.  See ?par for details on possible parameters
#' @keywords graphics water-quality statistics
#' @export
#' @seealso \code{\link{plotConcTime}}
#' @examples
#' Sample <- exSample
#' INFO <- exINFO
#' plotLogConcTime()
#' plotLogConcTime(qUnit = 'thousandCfs')
plotLogConcTime<-function(localSample = Sample, localINFO = INFO, qUnit = 2,qLower = NA,
                          qUpper = NA, paLong = 12, paStart = 10, tinyPlot = FALSE, 
                          concMax = NA, concMin = NA, printTitle = TRUE, ...){
 
  plotConcTime(localSample = localSample, localINFO = localINFO, qUnit = qUnit, 
               qLower = qLower, qUpper = qUpper, paLong = paLong, paStart = paStart, 
               tinyPlot = tinyPlot, concMax = concMax, concMin = concMin, 
               printTitle = printTitle, logScale="y",  ...)
 
}