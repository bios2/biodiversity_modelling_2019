#' Run the model over time
#'
#' This function generates the spatiotemporal dynamics based in the initial landscape, climate change and forest management
#' @param steps numeric, the total number of steps to run the model. Here 1 step is equivalent to 5 years.
#' @param initLand output object from the \code{\link{create_virtual_landscape}} or \code{\link{create_real_landscape}} function
#' @param managInt vector, intensity of the four ordered management practices: plantation, harvest, thinning and enrichment plantation. Values must be bounded between \code{0} and \code{1}, where \code{0} means the natural dynamics without forest management.
#' @param RCP Numeric, \href{https://en.wikipedia.org/wiki/Representative_Concentration_Pathway}{Representative Concentration Pathway}. Five scenarios of RCP are available: \code{0}, \code{2.6}, \code{4.5}, \code{6} and \code{8.5}
#' @param stoch logical, if \code{TRUE}, the prevalence of each cell will depend in a probabilistic random generator. Otherwise the prevalence will be deterministic.
#' @param cores numeric, the number of cores to be used in a parallel computation. The parallel is computed with the \code{mclapply} function. If \code{cores = 1}, a loop for will be used instead.
#' @param outputLand vector, an integer vector to define the time steps to be saved at the end of the simulation. This argument is useful when we only need to compare the first and last time step \code{outputLand = c(1, steps)}, or when the size of the landscape is too big so we need to reduce memory usage.
#' @param rangeLimitOccup numeric between 0 and 1. If not \code{NULL}, the function will calculate the landscape position of the boreal trailing edge and the temperate leading edge for each time step. The defined value betwen 0 and 1 determines the minimum occupancy a row of the landscape must be occupied by a specific forest state to be considered part of the state range. E.g. if \code{rangeLimitOccup = 0.8}, the furthest row of the landscape with a proportion less than 0.8 will be considered the range limit of the state. Default is \code{0.85}, but values ranging from \code{0.7} to \code{0.95} does not have much effect on migration rate (see \href{https://github.com/willvieira/STManaged/issues/3}{figure 3} of sensitivity analysis). It returns a data frame.
#' @param stateOccup logical, calculate the proportion of the four forest states for each row of the landscape for all time steps. This argument is useful when you need the information from each time step but cannot save all landscapes because of memory limitation. Returns a list with a data frame for each time step
#' @param saveOutput logical, if \code{TRUE} it will save the output list in the 'output' directory with an automatic name with the main information from the simulation
#' @param fileOutput, character, if not \code{NULL}, define the name of the file output
#' @param folderOutput, character, if not \code{NULL}, define the name of the folder other than the default 'output'
#' @return a list with the (i) landscape configuration for each step, (ii) scaled temperature gradient, (iii) steps, (iv) management intensity, (v) RCP scenario, (vi) landscape dimensions and (vii) range limit data frame
#' @importFrom parallel mcmapply
#' @export
#' @examples
#' \dontrun{
#' initLand = create_virtual_landscape(cellSize = 5)
#'
#' lands <- run_model(steps = 10, initLand,
#'                    managInt = c(0.15, 0, 0, 0),
#'                    RCP = 4.5,
#'                    rangeLimitOccup = 0.75)
#' }

run_model <- function(steps,
                      initLand,
                      managInt = c(0, 0, 0, 0), # for plant, harv, thin and enrich
                      RCP = 0,
                      stoch = TRUE,
                      cores = 1,
                      outputLand = NA, # if NA, everything is out, otherwise specify a vector of timeSteps values [1 - steps]
                      rangeLimitOccup = NULL,
                      stateOccup = FALSE, # get state occupancy proportion for each col of the landscape at every time step
                      saveOutput = FALSE,
                      fileOutput = NULL, # name of the file
                      folderOutput = NULL) # name of the output file, if NULL will just save in the mail `output` folder
{

  cat(" Preparing the model...\r")

  # define type of initLand (raster or list?)
  isRaster <- !is.integer(initLand[['land']])

  # lands
  if(isRaster) {
    land0 <- raster::values(initLand[['land']][['land']])
    lands.r <- initLand[['land']]
    names(lands.r) <- c('land_T0', 'tp', 'pp')
    land1.r <- raster::raster(nrows = lands.r@nrows, ncols = lands.r@ncols)
    raster::extent(land1.r) <- raster::extent(lands.r)
    raster::crs(land1.r) <- raster::crs(lands.r)

  }else{
    lands <- list(land_T0 = initLand[['land']])
    land0 <- initLand[['land']]
  }

  # lands information
  nRow <- initLand[['nRow']]
  nCol <- initLand[['nCol']]
  position <- initLand[['position']]
  neighbor <- initLand[['neighbor']]
  states <- 1:4

  # climate change
  if(!isRaster)
  {
    climDiff <- clim_diff(initLand[['env1']], RCP = RCP, nRow = nRow, params)
    pars <- clim_increase(steps = steps, climDiff, growth = 'linear')
  }else {
    # repeate last set of parameters in case steps are higher than climate change time
    if(length(pars) < steps) {
      # define missing years
      missYr <- which(!seq_len(steps) %in% (1:length(pars)))
      for(i in missYr)
      pars[[i]] <- pars[[length(pars)]]
    }
  }

  if(cores > 1) {
    # create a border vector with states from land0 to be added at each time step (the border will not be updated
    indexToAdd <- which(!(1:(nCol * nRow) %in% position))
    border <- land0[indexToAdd]
  }

  # rangeLimit occup dataframe
  if(!is.null(rangeLimitOccup)) {
    # range limit table (divided by nCol so I can compare with different landcape cell size)
    rangeLimitDF <- data.frame(step = 1:(steps + 1), limitB = numeric(steps + 1), limitT = numeric(steps + 1))
    rangeLimitDF[1, 2:3] <- range_limit(land0, nRow = nRow, nCol = nCol, occup = rangeLimitOccup)/nCol
  }

  # stateOccup dataframe
  if(stateOccup == TRUE) {
    stateOccupDF <- apply(matrix(land0, ncol = nRow), 1, getProp, nRow = nRow)
    stateOccupList <- list(stateOccupDF)
  }

  # define cells to run (dealing with NA cells in the real landscape)
  cellsToRun = which(land0[position] != 0)

  if(cores == 1) land1 <- land0

  for(i in 1:steps) {

    # two run options (non-parallel and parallel)
    if(cores == 1) {
      for(cell in cellsToRun) {
        # get neighborhood
        y0 <- neighbor_prop(land0[neighbor[[cell]]])
        # run the model
        parsOfCell <- setNames(pars[[i]][, position[cell]], c('alphab', 'alphat', 'betab', 'betat', 'theta', 'thetat', 'epsB', 'epsT', 'epsM'))
        y1 <- model_fm(t = 1, y0, params = parsOfCell, managInt)
        y1 <- y0 + unlist(y1) # update cell
        y1['R'] <- 1 - sum(y1)

        if(stoch == T) {
          land1[neighbor[[cell]][5]] <- states[rmultinom(n = 1, size = 1, prob = y1) == 1] # get a state depending on the probability `p`
        }else {
          land1[neighbor[[cell]][5]] <- states[y1 == max(y1)] # update landStep
        }
      }
    }else if(cores > 1) {
      # run for all cells
      land <- parallel::mcmapply(function(cell) cellRun(cell, neighbor, land0, pars, parCell, i, managInt, stoch, nCol), seq_along(neighbor), mc.cores = cores)

      land1 <- setNames(land, position)

      # add border to keep same size at each time step
      land1 <- c(land1, border)
      land1 <- land1[match(seq_len(length(land1)), as.numeric(names(land1)))] # sort to keep same order
    }else{
      stop("cores must be a numeric greater than zero")
    }

    # calculate range limit
    if(!is.null(rangeLimitOccup)) rangeLimitDF[i + 1, 2:3] <- range_limit(land1, nRow = nRow, nCol = nCol, occup = rangeLimitOccup)/nCol

    # calculate state occupancy of each col of the landscape
    if(stateOccup == TRUE) stateOccupList[[i + 1]] <- apply(matrix(land0, ncol = nRow), 1, getProp, nRow = nRow)

    land0 <- land1 # update land0 for next time step

    # keep all output lands or just a part of it?
    if(!any(is.na(outputLand))) {
      if(i %in% outputLand) {
        if(isRaster) {
          raster::values(land1.r) <- land1
          lands.r <- raster::addLayer(lands.r, land1.r)
        }else{
        lands[[paste0('land_T', i)]] <- land1 # save land time step
        }
      }
    }else{
      if(isRaster) {
        raster::values(land1.r) <- land1
        lands.r <- raster::addLayer(lands.r, land1.r)
      }else{
        lands[[paste0('land_T', i)]] <- land1 # save land time step
      }
    }

    # print progress
    cat("==>", format(100*i/steps, digits = 2), "%", "\r")
  }

  # add steps, management and RCP information
  if(isRaster)
  {
    # rename layers
    names(lands.r)[4:(steps + 3)] <- paste0('land_T', 1:steps)
    output <- list(lands = lands.r)

  }else
  {
    output <- lands
    output[['env1']] <- initLand[['env1']]
  }

  output[['steps']] <- steps
  output[['manag']] <- managInt
  output[['RCP']] <- ifelse(isRaster, '8.5', RCP)
  output[['nCol']] <- nCol
  output[['nRow']] <- nRow
  if(!is.null(rangeLimitOccup)) output[['rangeLimit']] <- rangeLimitDF
  if(stateOccup == TRUE) output[['stateOccup']] <- stateOccupList


  # save or simply return the output
  if(saveOutput == TRUE) {
    # define fileName
    if(is.null(fileOutput)) {
      fileName <- paste0('RCP', RCP, paste(managInt, collapse = ''))
    }else {
      fileName <- fileOutput
    }
    # define directory
    if(is.null(folderOutput)) {
      directoryName <- paste0('output/', fileName, '.RDS')
    }else {
      fo <- paste0('output/', folderOutput)
      if(!dir.exists(fo)) dir.create(fo) # ckeck if directory exists and if not, create it
      directoryName <- paste0(fo, '/', fileName, '.RDS')
    }
    saveRDS(output, file = directoryName)
  }else {
    return(output)
  }
}

# function to return neighborhood proportion considering the 8 neighbors
neighbor_prop <- function(neighbor) {
  return(c(B = sum(neighbor == 1), T = sum(neighbor == 2), M = sum(neighbor == 3))/9)
}

cellRun <- function(cell, neighbor, land0, pars, parCell, i, managInt, stoch, nCol) {
  states <- 1:4
  y0 <- neighbor_prop(land0[neighbor[[cell]]])
  y1 <- model_fm(t = 1, y = y0, params = pars[[i]][, parCell[cell]], managInt)
  y1 <- y0 + unlist(y1) # update cell
  y1['R'] <- 1 - sum(y1)
  if(stoch == T) {
    cell <- states[rmultinom(n = 1, size = 1, prob = y1) == 1] # get a state depending on the probability `p`
  }else {
    cell <- states[y1 == max(y1)] # update cell
  }

  return(cell)
}
