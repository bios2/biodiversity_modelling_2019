# - clim_diff (get the params difference between env1 before and after climate change)
clim_diff <- function(env1, # pars as a list for each row of the lanscape
                      RCP = 0, # RCP either 0, 2.6, 4.5, 6 and 8.5
                      nRow,
                      params)
{
  # unscale temperature to add climate change
  tempSc0 <- rep(env1, each = nRow)
  tempUn0 <- tempSc0 * vars.sd['annual_mean_temp'] + vars.means['annual_mean_temp']

  # add climate change
  if(RCP == 2.6) tempUn1 <- tempUn0 + 1 # increase of 1 degree
  if(RCP == 4.5) tempUn1 <- tempUn0 + 1.8
  if(RCP == 6) tempUn1 <- tempUn0 + 2.2
  if(RCP == 8.5) tempUn1 <- tempUn0 + 3.7
  if(RCP == 0) tempUn1 <- tempUn0

  # test if RCP was corectly insert
  if(!exists('tempUn1')) stop("'RCP' must be either '0', '2.6', '4.5', '6' or '8.5'")

  # scale future temperature
  tempSc1 <- setNames((tempUn1 - vars.means['annual_mean_temp'])/vars.sd['annual_mean_temp'], NULL)

  # list of parameters for each row cell before and after climate change (temperature gradient)
  pars0 <- lapply(as.list(tempSc0), function(x) get_pars(ENV1 = x, ENV2 = 0, params, int = 5))
  pars1 <- lapply(as.list(tempSc1), function(x) get_pars(ENV1 = x, ENV2 = 0, params, int = 5))

  # tansform to matrix
  pars0M <- matrix(unlist(pars0), nrow = 9)
  pars1M <- matrix(unlist(pars1), nrow = 9)

  # names
  row.names(pars0M) <- names(pars0[[1]])
  row.names(pars1M) <- names(pars0[[1]])

  # list of difference between before and after climate change
  parsDiff <- mapply("-", pars1, pars0)

  climDiff <- setNames(list(pars0M, pars1M, parsDiff), c('pars0', 'pars1', 'parsDiff'))

  return(climDiff)
}

# Function to create the parameter vector depending on the growth type of climate change
clim_increase <- function(steps, climDiff, growth = 'linear') {

  if(growth == 'linear') {

    # define the increasing parameters (20 because = 100 years of climate change)
    # formula: 1:20 * parsDiff/20 + pars0
      # first part of formula: returns a list of 20 years (each year with one matrix of parameters)
      parsDiff20_120 <- sapply(1:20, function(x) (climDiff[['parsDiff']]/20) * x, simplify = FALSE)
      # second part: sum each matrix 'parsDiff/20' with 'pars0'
      parsDiff20_pars0 <- lapply(parsDiff20_120, function(x) x + climDiff[['pars0']])

      # list with parameter increasing
      # starting with pars0, increasing from 1 to 20 and then fixed until nb of steps
      parsCC <- c(list(climDiff[['pars0']]), parsDiff20_pars0, rep(list(parsDiff20_pars0[[20]]), steps))

  }else if(growth == 'exponential') {

    # furmula: pars0 * [(pars1/pars0)^(1/20*x)]
      # first part: return list with 20 years
      pars1_pars0 <- sapply(1:20, function(x) (climDiff[['pars1']]/climDiff[['pars0']])^(0.05*x), simplify = FALSE)

      # second part: pars0 * pars1_pars0
      pars0_pars1_pars0 <- lapply(pars1_pars0, function(x) climDiff[['pars0']] * x)

      # list with parameter increasing
      # starting with pars0, increasing from 1 to 20 and then fixed until nb of steps
      parsCC <- c(list(climDiff[['pars0']]), pars0_pars1_pars0, rep(list(pars0_pars1_pars0[[20]]), steps))

  }

  return(parsCC)
}
