% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_landscape.R
\name{create_real_landscape}
\alias{create_real_landscape}
\title{Create real landscape}
\usage{
create_real_landscape()
}
\value{
a list with the (i) raster landscape containing the states, temperature and precipition for each cell, (ii) landscape dimensions, (iii) position and neighbor are internal objects to run the model in parallel.
}
\description{
This function creates an initial real landscape to run the simulations
}
\examples{
initLand = create_real_landscape()
}
