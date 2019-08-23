##########################################
# create real Initial Landscape
# Will Vieira
# August 16, 2019
##########################################

# Steps
  # get info
  # solve to equilibrium for each climate model
  # mean the probabilities
  # get prevalent state from mean using a rmultinom()
  # save raster with Eq, TP and PP


library(raster)


# Get info

  # get name of climate models of climate change
  climData <- dir('climData')
  climModels <- unique(gsub('.{14}$', '', gsub('.*rcp85-', '', climData)))
  years <- seq(2000, 2095, 5)
  load('R/sysdata.rda') # scale parameters
  source('R/model_managed.R')

#



# solve to equilibrium for each climate model

  # run to equilibrium for all climate models (takes about 6 hours in 1 core)
  count = 1
  eq_climModels <- list()
  for(cModel in climModels) {

    # get climate model data for first time step (1985 - 2000)
    climM <- paste0('rcp85-', cModel, '-1985-2000.rda')

    # temperature and precipition
    clim <- readRDS(paste0('climData/', climM))
    tp <- clim[['tp']]@data@values
    pp <- clim[['pp']]@data@values

    # scale temp and precip
    env1 <- (tp - vars.means['annual_mean_temp'])/vars.sd['annual_mean_temp']
    env2 <- (pp - vars.means['tot_annual_pp'])/vars.sd['tot_annual_pp']

    # data frame with env1, env2 and calculated eq
    B = T = M = R = numeric(length(env1))
    df <- data.frame(env1 = env1, env2 = env2, B, T, M, R)

    for(i in 1:nrow(df))
    {
      if(!is.na(df[i, 1])) # skep in case env is NA
      {
        y <- rootSolve::runsteady(y = c(B = 0.25, T = 0.25, M = 0.25), func = model_fm, parms = get_pars(ENV1 = df[i, 1], ENV2 = df[i, 2], params, int = 5), times = c(0, 1000), managInt = c(0, 0, 0, 0))[[1]]
        y['R'] = 1 - sum(y)
        df[i, 3:6] = y
      }

      cat('   Calculating equilibrium   ', round(count/(nrow(df) * length(climModels)) * 100, 0), '%\r')
      count = count + 1
    }

    eq_climModels[[cModel]] <- df

  }

#



# mean the probabilities

  # make a list of state vectors for each climate model
  listB = lapply(eq_climModels, "[", , 'B')
  listT = lapply(eq_climModels, "[", , 'T')
  listM = lapply(eq_climModels, "[", , 'M')
  listR = lapply(eq_climModels, "[", , 'R')

  # transform list in data frame
  dfB = as.data.frame(do.call(cbind, listB))
  dfT = as.data.frame(do.call(cbind, listT))
  dfM = as.data.frame(do.call(cbind, listM))
  dfR = as.data.frame(do.call(cbind, listR))

  # mean of the state probability for each row (cell)
  eqMean <- data.frame(B = rowMeans(dfB))
  eqMean$T <- rowMeans(dfT)
  eqMean$M <- rowMeans(dfM)
  eqMean$R <- rowMeans(dfR)

#



# get prevalent state from mean using a rmultinom()

  states = 1:4
  land = numeric(nrow(eqMean))

  for(cell in 1:nrow(eqMean))
  {
    if(sum(eqMean[cell, ]) != 0)
    {
      eqMean[cell, eqMean[cell, ] < 0] = 0 # check for negative probabilities
      land[cell] <- states[rmultinom(n = 1, size = 1, prob = eqMean[cell, ]) == 1]
    }
    cat('   get state from probability  ', round(cell/nrow(eqMean) * 100, 0), '%\r')
  }

#



# save raster with Eq, TP and PP

  r.raster <- raster(nrows = clim@nrows, ncols = clim@ncols)
  extent(r.raster) <- extent(clim)
  res(r.raster) <- 1000
  crs(r.raster) <- crs(clim)
  values(r.raster) <- land
  names(r.raster) <- 'land'
  land.r <- addLayer(r.raster, clim)

#
