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
  # calculate parameters for climate change in advance
  # save calculated parameters


library(raster)


# Get info

  # get name of climate models of climate change
  clim <- readRDS('climData/climate_Present.RDS')
  clim <- clim[[c('bio1', 'bio12')]]
  names(clim) <- c('tp', 'pp')
  years <- seq(2000, 2095, 5)
  load('R/sysdata.rda') # scale parameters
  source('R/model_managed.R')

#



# solve to equilibrium for each climate model

  # run to equilibrium for all the landscape
    # temperature and precipition
    tp <- clim[['tp']]@data@values
    # adjust to put distribution southward
    tp = tp - 1
    pp <- clim[['pp']]@data@values

    # scale temp and precip
    env1 <- (tp - vars.means['annual_mean_temp'])/vars.sd['annual_mean_temp']
    env2 <- (pp - vars.means['tot_annual_pp'])/vars.sd['tot_annual_pp']

    # data frame with env1, env2 and calculated eq
    B = T = M = R = numeric(length(env1))
    df <- data.frame(env1 = env1, env2 = env2, B, T, M, R)

    count = 1
    for(i in 1:nrow(df))
    {
      if(!is.na(df[i, 1])) # skep in case env is NA
      {
        y <- rootSolve::runsteady(y = c(B = 0.25, T = 0.25, M = 0.25), func = model_fm, parms = get_pars(ENV1 = df[i, 1], ENV2 = df[i, 2], params, int = 5), times = c(0, 1000), managInt = c(0, 0, 0, 0))[[1]]
        y['R'] = 1 - sum(y)
        df[i, 3:6] = y

        cat('   Calculating equilibrium   ', round((count/nrow(df)) * 100, 0), '%\r')
        count = count + 1
      }
    }

#



# get prevalent state from mean using a rmultinom()

  states = 1:4
  land = numeric(nrow(df))
  df2 <- df[, 3:6]

  for(cell in 1:nrow(df2))
  {
    if(sum(df2[cell, ]) != 0)
    {
      df2[cell, df2[cell, ] < 0] = 0 # check for negative probabilities
      land[cell] <- states[rmultinom(n = 1, size = 1, prob = df2[cell, ]) == 1]
    }
    cat('   get state from probability  ', round(cell/nrow(df2) * 100, 0), '%\r')
  }

#



# save raster with Eq, TP and PP

  r.raster <- raster(nrows = clim@nrows, ncols = clim@ncols)
  extent(r.raster) <- extent(clim)
  #res(r.raster) <- 1000
  crs(r.raster) <- crs(clim)
  values(r.raster) <- land
  names(r.raster) <- 'land'
  land.rBio <- addLayer(r.raster, clim)

#

# plot(land.rBio[['land']], col = c("white", "darkcyan", "orange", "palegreen3", "black"))
#load('R/sysdata.rda')
#save(envProb, land.r, land.rBio, neighbor, params, vars.means, vars.sd, file = 'R/sysdata.rda')



# calculate parameters for climate change in advance

  years <- seq(2015, 2090, 5)

  pars <- list()
  for(yr in years)
  {
    clim <- readRDS(paste0('climData/newClim/climate_Scenario_ACCESS1_0_', yr, '.RDS'))
    tp <- raster::values(clim[['bio1']])
    pp <- raster::values(clim[['bio12']])

    # scale temp and precip
    env1 <- (tp - vars.means['annual_mean_temp'])/vars.sd['annual_mean_temp']
    env2 <- (pp - vars.means['tot_annual_pp'])/vars.sd['tot_annual_pp']

    # list of parameters for each row cell before and after climate change (temperature gradient)
    parsYr <- data.frame(matrix(NA, ncol = length(env1), nrow = 9))
    for(i in 1:length(env1))
    {
      parsYr[, i] <- get_pars(ENV1 = env1[i], ENV2 = env2[i], params, int = 5)

      cat('   calculating parameters  ', round(i/(length(env1) * length(years)) * 100, 0), '%\r')
    }

    pars[[which(yr == years)]] <- parsYr
  }

#



# save parameters for virtual

  #  load('R/sysdata.rda')
  #  save(envProb, land.r, land.rBio, pars, neighbor, params, vars.means, vars.sd, file = 'R/sysdata.rda')

#
