\name{plotConcTimeSmooth}
\alias{plotConcTimeSmooth}
\title{Plot up to three curves representing the concentration versus time relationship, each curve representing a different flow.}
\usage{
  plotConcTimeSmooth(q1, q2, q3, centerDate, yearStart,
    yearEnd, qUnit = 2, legendLeft = 0, legendTop = 0,
    concMax = NA, bw = FALSE, printTitle = TRUE,
    printValues = FALSE, localSample = Sample,
    localINFO = INFO, windowY = 10, windowQ = 2,
    windowS = 0.5, cex.main = 1.1, lwd = 2, ...)
}
\arguments{
  \item{q1}{numeric This is the discharge value for the
  first curve to be shown on the plot. It is expressed in
  units specified by qUnit.}

  \item{q2}{numeric This is the discharge value for the
  second curve to be shown on the plot. It is expressed in
  units specified by qUnit. If you don't want a second
  curve then the argument must be q2=NA}

  \item{q3}{numeric This is the discharge value for the
  third curve to be shown on the plot. It is expressed in
  units specified by qUnit. If you don't want a third curve
  then the argument must be q3=NA}

  \item{centerDate}{string This is the time of year to be
  used as the center date for the smoothing. It is
  expressed as a month and day and must be in the form
  "mm-dd"}

  \item{yearStart}{numeric This is the starting year for
  the graph. The first value plotted for each curve will be
  at the first instance of centerDate in the year
  designated by yearStart.}

  \item{yearEnd}{numeric This is the end of the sequence of
  values plotted on the graph.The last value will be the
  last instance of centerDate prior to the start of
  yearEnd. (Note, the number of values plotted on each
  curve will be yearEnd-yearStart.)}

  \item{qUnit}{object of qUnit class. \code{\link{qConst}},
  or numeric represented the short code, or character
  representing the descriptive name.}

  \item{legendLeft}{numeric which represents the left edge
  of the legend, in the units shown on x-axis of graph,
  default is 0, will be placed within the graph but may
  overprint data}

  \item{legendTop}{numeric which represents the top edge of
  the legend, in the units shown on y-axis of graph,
  default is 0, will be placed within the graph but may
  overprint data}

  \item{concMax}{numeric value for upper limit on
  concentration shown on the graph, default = NA (which
  causes the upper limit to be set automatically, based on
  the data)}

  \item{bw}{logical if TRUE graph is produced in black and
  white, default is FALSE (which means it will use color)}

  \item{printTitle}{logical variable if TRUE title is
  printed, if FALSE not printed}

  \item{printValues}{logical variable if TRUE the results
  shown on the graph are also printed to the console (this
  can be useful for quantifying the changes seen visually
  in the graph), default is FALSE (not printed)}

  \item{localSample}{string specifying the name of the data
  frame that contains the Sample data, default name is
  Sample}

  \item{localINFO}{string specifying the name of the data
  frame that contains the metadata, default name is INFO}

  \item{windowY}{numeric specifying the half-window width
  in the time dimension, in units of years, default is 10}

  \item{windowQ}{numeric specifying the half-window width
  in the discharge dimension, units are natural log units,
  default is 2}

  \item{windowS}{numeric specifying the half-window with in
  the seasonal dimension, in units of years, default is
  0.5}

  \item{cex.main}{magnification to be used for main titles
  relative to the current setting of cex}

  \item{lwd}{line width, a positive number, defaulting to
  1}

  \item{\dots}{arbitrary functions sent to the generic
  plotting function.  See ?par for details on possible
  parameters}
}
\description{
  These plots show how the concentration-time relationship
  is changing over flow.
}
\examples{
q1 <- 10
q2 <- 25
q3 <- 75
centerDate <- "07-01"
yearStart <- 2000
yearEnd <- 2010
Sample <- exSample
INFO <- exINFO
plotConcTimeSmooth(q1, q2, q3, centerDate, yearStart, yearEnd)
}
\keyword{graphics}
\keyword{statistics}
\keyword{water-quality}

