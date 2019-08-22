#' Plot range limit migration
#'
#' This function plots the how the range limit of boreal and temperate states varies over time
#' @param lands the object output of the \code{\link{run_model}} function
#' @param rangeLimitOccup numeric between 0 and 1 to define the minimum row occupancy of a state in the landscape. See \code{\link{run_model}} for more details
#' @export
#' @examples
#' \dontrun{
#' plot_rangeShift(lands)
#' }

plot_rangeShift <- function(lands, rangeLimitOccup = NULL) {

  # if range limit is not present, calculate it
  if(!'rangeLimit' %in% names(lands)) {
    # ask for the rangeLimitOccup information
    if(is.null(rangeLimitOccup)) stop('Aparently range limit was not calculated in "run_model", so I will have to calculate here. Please specify a "rangeLimitOccup" value')

    rg <- data.frame(step = 1:(lands[['steps']] + 1), limitB = numeric(lands[['steps']] + 1), limitT = numeric(lands[['steps']] + 1))

    for(timeStep in seq_len(lands[['steps']] + 1)) {
      rg[timeStep, 2:3] <- range_limit(lands[[timeStep]], nRow = lands[['nRow']], nCol = lands[['nCol']], occup = rangeLimitOccup)/lands[['nCol']]
    }

  }else{
    rg <- lands[['rangeLimit']]
    # check
    if(!is.null(rangeLimitOccup)) warning(cat('We are using the range limit information from the run_model output. The argument "rangeLimitOccup = ', rangeLimitOccup, '" is ignored'))
  }

  cols <- c("darkcyan", "orange", "palegreen3", "black")
  par(mar = c(2.5, 2.2, 1.5, 0.5), mgp = c(1.3, 0.3, 0), tck = -.008)
  plot(0, pch = '', xlim = c(0, lands[['steps']]), ylim = c(1, 0), xlab = '', ylab = '', yaxt = 'n')
  # boreal
  lines(rg[, 'limitB'], col = cols[1])
  # temperate
  lines(rg[, 'limitT'], col = cols[2])

  # legends
    # xylab
    mtext('Latitude (annual mean temperature)', side = 2, line = 1.2)
    mtext('Time steps (step * 5 = year)', side = 1, line = 1.2)
    # boreal
    mtext('Boreal trailing edge', line = -0.9, side = 2, at = rg[1, 'limitB'], cex = 0.85, col = cols[1])
    abline(h = rg[1, 'limitB'], col = 'gray', lty = 2, lwd = 0.8)
    # temperate
    mtext('Temperate leading edge', line = -0.9, side = 2, at = rg[1, 'limitT'], cex = 0.85, col = cols[2])
    abline(h = rg[1, 'limitT'], col = 'gray', lty = 2, lwd = 0.8)
    # the limit of climate change increase
    mtext('End of temp increase', side = 3, line = 0.1, at = 20)
    abline(v = 20, lty = 3, col = 2, lwd = 0.8)

    # add ylab with unscaled env1
    par(new = TRUE)
    plot(1:length(lands[['env1']]), lands[['env1']] * vars.sd['annual_mean_temp'] + vars.means['annual_mean_temp'], pch = '', xlim = c(0, lands[['steps']]), xaxt = 'n', xlab = '', ylab = '')
}
