#' Calculate state range limit
#'
#' This function calculates the south range limit of boreal and the north range limit of temperate states in a specific landscape configuration
#' @param land vector, one element of the \code{\link{run_model}} output
#' @param nRow numeric, number of rows of the landscape. Value is found in the output list from the \code{\link{run_model}} function
#' @param nCol numeric, number of columns of the landscape. Value is found in the output list from the \code{\link{run_model}} function
#' @param occup numeric between 0 and 1. The value determines the minimum occupancy a row of the landscape must be occupied by a specific forest state to be considered part of the state range
#' @export
#' @examples
#' \dontrun{
#' lands <- run_model(steps = 10, initLand)
#' range_limit(lands[['land_TX']], lands[['nRow']], lands[['nCol']], occup = .7)
#' }

range_limit <- function(land, nRow, nCol, occup)
{
  # list to matrix
  landM <- matrix(land, ncol = nRow, byrow = TRUE)

  prop <- apply(landM, 1, getProp, nRow = nRow)

  # get range limit
  lastB <- which(prop['B',] > occup)
  lastT <- which(prop['T',] > occup)

  # the `length(lastB/T) == 0` is to define extreme limit in case there is no row larger than `occup`
  # limit Boreal
  if(length(lastB) == 0) {
    limB <- 1
  }else{
    limB <- as.numeric(max(which(prop['B',] > occup)))
  }
  # limit Temperate
  if(length(lastT) == 0) {
    limT <- nCol
  }else{
    limT <- as.numeric(min(which(prop['T',] > occup)))
  }

  rtrn <- setNames(c(limB, limT), c('limitB', 'limitT'))

  return(rtrn)
}
