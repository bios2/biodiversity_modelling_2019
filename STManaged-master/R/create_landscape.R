#' Create virtual landscape
#'
#' This function creates an initial virtual landscape to run the simulations
#' @param climRange vector, annual mean temperature with the respective North and South limits. Values must be between -5.3 and 12.2 to respect the parameterization boundary.
#' @param cellSize numeric, size of the cell of the landscape in Km. Recommended cell size is between 0.3 and 5 km.
#' @return a list with the (i) initial landscape, (ii) scaled temperature gradient, (iii) landscape dimensions, (iv) position and neighbor are internal objects to run the model in parallel.
#' @export
#' @examples
#' initLand = create_virtual_landscape(climRange = c(-2.61, 5.07), cellSize = 4)

create_virtual_landscape <- function(climRange = c(-2.61, 5.07),
                                     cellSize = 0.8)
{

  # checks
  if(any(climRange < -5.3 | climRange > 12.3)) stop("climRange is out of parameterization. Please specify values inside the range [-5.3 to 12.2]")

  if(cellSize < 0.3) warning("Cells smaller than 0.3 km2 will be time consuming and consume too much memory... Consider increasing the cell size")

  if(cellSize > 4) warning("Cells larger than 4 km2 may overestimate dispersion... Consider reducing the cell size")

  # get grid size
  landDist <- 800 # TODO: rethink about it
  nCol <- round(landDist/cellSize, 0) #TODO: define the distance between climRange and real distance
  nRow <- round(nCol/10, 0)

  # Scale temperature ranges
  climR <- setNames((climRange - vars.means['annual_mean_temp'])/vars.sd['annual_mean_temp'], c(NULL, NULL))

  # temperature gradient over the grid
  env1 <- seq(climR[1], climR[2], length.out = nCol)
  landscape <- setNames(rep(env1, each = nRow), 1:(nRow * nCol)) # list for each col of the matrix

  land <- sapply(landscape, getState)

  # get cell positions to be calculated (i.e. ignore border)
  position <- getPosition(nRow = nRow, nCol = nCol)

  # get neighbors for each cell position
  neighbor <- getNeighbor(nRow = nRow, nCol = nCol)

  return(list(land = land, env1 = env1, nCol = nCol, nRow = nRow, position = position, neighbor = neighbor))
}



#' Create real landscape
#'
#' This function creates an initial real landscape to run the simulations
#' @return a list with the (i) raster landscape containing the states, temperature and precipition for each cell, (ii) landscape dimensions, (iii) position and neighbor are internal objects to run the model in parallel.
#' @export
#' @examples
#' initLand = create_real_landscape()

create_real_landscape <- function()
{
  nCol = land.rBio@nrows
  nRow = land.rBio@ncols # I'am aware of the inversion between ncol and nrow

  # get adjacent (neighbors)
  ad <- raster::adjacent(land.rBio[['land']], 1:(nCol * nRow), 8)

  # cells to calculate (all that have 8 neigbors)
  position <- which(table(ad[, 1]) == 8)

  # get neighbours for each cell position
  # neighbor <- list()
  # for(ps in 1:length(position))
  # {
  #   neighbor[[ps]] <- ad[which(ad[, 1] == position[ps]), 2]
  # }

  return(list(land = land.rBio, nCol = nCol, nRow = nRow, position = position, neighbor = neighbor))
}



# initial state over the temperature gradient
getState <- function(env) {
 p <- envProb[which.min(abs(envProb$temp - env)),c(2:5)] # probability for a given temperature
 state <- which(rmultinom(n = 1, size = 1, prob = p) == 1) # get a state depending on the probability `p`
 return(state)
}

# Function to get a vector of cell position (ignoring border first and last line and column)
getPosition <- function(nRow, nCol) {
  nLines <- nRow - 2
  pos <- numeric((nCol - 2) * (nRow - 2))
  i <- 1
  j <- nCol - 2

  for(line in 1:nLines) {
    pos[i:j] <- (nCol * line + 2):((nCol * line) + nCol - 1)
    i <- j + 1
    j <- j + nCol - 2
  }

  return(pos)
}

# Function to get a list of neighborhood index for each cell position
getNeighbor <- function(nRow, nCol) {
  jump <- nCol - 3
  cellPerRow <- nCol - 2
  lineNeighbor <- c(1:3, (4:6 + jump), (7:9 + (jump * 2)))
  totalCells <- (nCol - 2) * (nRow - 2)

  neighList <- rep(list(NA), totalCells)

  count <- 0; count2 <- 0
  for(i in 1:totalCells) {
    neighList[[i]] <- lineNeighbor + count + (nCol * count2)
    count <- count + 1
    if(count == cellPerRow) {
      count <- 0
      count2 <- count2 + 1
    }
  }
  return(neighList)
}
