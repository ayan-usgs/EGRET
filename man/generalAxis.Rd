\name{generalAxis}
\alias{generalAxis}
\title{Axis generation for log discharge}
\usage{
  generalAxis(x, maxVal, minVal, logScale = FALSE,
    tinyPlot = FALSE, padPercent = 5, max_offset = 0,
    min_offset = 0, year_search = FALSE)
}
\arguments{
  \item{x}{vector to create scale about}

  \item{maxVal}{number maximum value on returned scale}

  \item{minVal}{number minimum value on returned scale}

  \item{logScale}{logical whether or not to return a log
  scale}

  \item{tinyPlot}{logical}

  \item{padPercent}{number used to pad the max and min if
  not specified}

  \item{max_offset}{maximum value offset}

  \item{min_offset}{minimum value offset}

  \item{year_search}{default is false; decides if the
  function needs to find the min and max as years}
}
\description{
  Discharge axis tick generation
}
\examples{
Daily <- exDaily
x <- Daily$Q
max <- max(x)
min <- 0
generalAxis(x, max, min)
min <- min(x)
generalAxis(x, max, min, log=TRUE)
}
\keyword{graphics}
\keyword{statistics}
\keyword{water-quality}

