#' Plot landscape occupancy
#'
#' This function plots the distribution of state occupancy over the Latitudinal gradient of the landscape
#' @param lands the object output of the \code{\link{run_model}} function
#' @param step vector, time step to be plotted
#' @param spar numeric, value between 0 and 1 to smooth the state occupancy
#' @param states vector, the forest states to be plotted. 1 for Boreal, 2 for Temperate, 3 for Mixed and 4 for regeneration
#' @param add logical, if \code{TRUE} the lines will be added to an existent plot
#' @export
#' @examples
#' \dontrun{
#' plot_occupancy(lands, step = 1, spar = 0.2, states = 1:4)
#' }

plot_occupancy <- function(lands, step, spar, states = 1:3, add = FALSE)
{
  # define coordinates
  nCol <- lands[['nCol']]
  nRow <- lands[['nRow']]

  # checks
  if(!all(step %in% 0:lands[['steps']])) stop('steps vector must be included in 1:steps')
  if(!all(states %in% 1:4)) stop('states must an integer of at least one forest states values [1:4]')

  # get step name
  stepName <- paste0('land_T', step)

  # vector to matrix
  land <- matrix(lands[[stepName]], nrow = nCol, byrow = TRUE)

  prop <- apply(land, 1, getProp, nRow = nRow)

  # plot
  cols <- c("darkcyan", "orange", "palegreen3", "black")
  stateNames <- c('Boreal', 'Temperate', 'Mixed', 'Regeneration')

  par(mar = c(2.5, 2.5, 3, 0.5), mgp = c(1.5, 0.3, 0), tck = -.008)
  if(add == FALSE) {
    plot(1:nCol, prop[1, ], pch = '', lwd = 1.3, xlab = "", xaxt = 'n', ylim = c(0, 1), ylab = "State occupancy", col = cols[1])
  }
  invisible(sapply(states, function(x) points(1:nCol, if(spar == 0) {prop[x, ]} else {smooth.spline(prop[x, ], spar = spar)$y}, type = 'l', lwd = 1.3, col = cols[x])))
  legend('topleft', legend = stateNames[states], lty = 1, col = cols[states], bg = 'white', cex = 0.8)
  mtext(stepName, 3, line = 0.5)

  # add undescaled env1 xlab
  par(new = TRUE)
  plot(lands[['env1']] * vars.sd['annual_mean_temp'] + vars.means['annual_mean_temp'], 1:length(lands[['env1']]), pch = '', ylim = c(0, 1), yaxt = 'n', xlab = 'Latitude (annual mean temperature)', ylab = '')
}
