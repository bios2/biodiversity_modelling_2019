###############################
# Plot range limit simulation
# Will Vieira
# May 1, 2019
##############################

##############################
# Steps:
  # getting data
  # organize range limit and migration distance in km for all 3 plots
  # plot range limit in function of time
  # plot km migration distance in function of time
  # plot km migration distance mean and sd in function of occupancy
##############################


library(STManaged)

# getting data (it takes about 2 minutes to load all 900 simulations)
  cellSize <- c(0.5, 0.8, 1, 2.5)
  occupancy <- c(0.7, 0.75, 0.8, 0.85, 0.9, 0.95)
  managPractice <- 0
  managInt <- 0
  reps = 1:15
  steps = 200

  mainFolder = 'output/rangeLimit/'
  for(cs in cellSize) {
    for(mg in managPractice) {
      folderName = paste0('cellSize_', cs, '_pract_', mg)
      for(rp in reps) {
        fileName = paste0('cellSize_', cs, '_pract_', mg, '_rep_', rp, '.RDS')
        assign(sub('\\.RDS$', '', fileName), readRDS(paste0(mainFolder, folderName, '/', fileName)))
      }
    }
    cat('   loading ouput files ', round(which(cs == cellSize)/length(cellSize) * 100, 1), '%\r')
  }
#



# organize range limit and migration distance in km for all 3 plots

  # Confidence interval function
  ci = function(x) qt(0.975, df=length(x)-1)*sd(x)/sqrt(length(x))

  # get 24 summary data frames (4 cellSizes * 6 occupancy values)

  count = 1
  for(cs in cellSize) {

    # list to store all different managements results (each list is for one plot)
    listCellSizeProp = list()
    listCellSizeDist = list()
    listCellSizetotalDist = list()

    # management practice
    mg = 0

    # for each management practice, save the mean and sd of all 30 replications
    for(occup in occupancy) {
      # name of files for each replication
      fileNames = paste0('cellSize_', cs, '_pract_', mg, '_rep_', reps)
      # data frames to store nCol's proportion for each forest state (to be used latter for mean and IC)
      propB = propT = data.frame(matrix(rep(NA, length(reps) * (steps + 1)), ncol = reps[length(reps)]))
      # data frames to store km distance of migration
      distB = distT = data.frame(matrix(rep(NA, length(reps) * (steps)), ncol = reps[length(reps)]))
      # data frame to store the total migration rate
      totalDist = data.frame(B = rep(NA, length(reps)), T = rep(NA, length(reps)))


      for(rp in reps) {
        # get simulation
        sim <- get(fileNames[rp])
        # calculate range limit
        rg <- lapply(sim[1:(steps + 1)], STManaged::range_limit, nCol = sim[['nCol']], nRow = sim[['nRow']], occup = occup)
        # list to data.frame
        dfProp <- do.call(rbind.data.frame, rg)
        # calculate migration distance for each time step
        dfDist <- apply(dfProp, 2, diff) * cs/5 # diff of cells times size of cell divided by the number of years of one step (unit = km/year)
        # calculate migration rate for all simulation (last time step - first time step)
        totalDist[rp, ] <- (dfProp[1, ] - dfProp[steps + 1, ]) * cs/(steps * 5)

        # save it
        propB[, rp] = dfProp[, 1]
        propT[, rp] = dfProp[, 2]
        distB[, rp] = dfDist[, 1]
        distT[, rp] = dfDist[, 2]

        cat('   calculating range limit ->', round(count/(length(cellSize) * length(occupancy) * length(reps)) * 100, 0), '%\r')
        count <- count + 1
      }

      # calculate mean and sd
      propSummary <- data.frame(meanB = apply(propB, 1, mean))
      propSummary$ciB <- apply(propB, 1, ci)
      propSummary$meanT <- apply(propT, 1, mean)
      propSummary$ciT <- apply(propT, 1, ci)

      distSummary <- data.frame(meanB = apply(distB, 1, mean))
      distSummary$ciB <- apply(distB, 1, ci)
      distSummary$meanT <- apply(distT, 1, mean)
      distSummary$ciT <- apply(distT, 1, ci)

      totalDistSummary <- data.frame(mean = apply(totalDist, 2, mean))
      totalDistSummary$ci <- apply(totalDist, 2, ci)

      # append in the list
      listCellSizeProp[[paste0('occup', occup)]] <- propSummary
      listCellSizeDist[[paste0('occup', occup)]] <- distSummary
      listCellSizetotalDist[[paste0('occup', occup)]] <- totalDistSummary

      ocCount = ocCount + length(reps)
    }

    # save specific cellSize list
    assign(paste0('listCellSizeProp', cs), listCellSizeProp)
    assign(paste0('listCellSizeDist', cs), listCellSizeDist)
    assign(paste0('listCellSizetotalDist', cs), listCellSizetotalDist)

  }

#



# plot range limit in function of time

  # define occup colors
  cols = rainbow(length(occupancy))
  colsT = rainbow(length(occupancy), alpha = 0.2)
  # ylim depending on cellSize
  csYlim <- numeric()
  for(cs in cellSize) {
    csYlim[which(cs ==cellSize)] <- get(paste0('cellSize_', cs, '_pract_', managPractice[1], '_rep_', reps[1]))[['nCol']]
  }

  pdf('simulations/rangeLimit_rangeLimit.pdf', height = 6)
  par(mfrow = c(2, 2), mar = c(2.5, 2.5, 1, 0.5), mgp = c(1, 0.2, 0), tck = -.01, cex = 0.8)

  for(cs in 1:length(cellSize)) {
    plot(0, pch = '', xlim = c(0, 200), ylim = c(csYlim[cs], 0), xlab = '', ylab = '', yaxt = 'n')
    for(ocp in 1:length(occupancy)) {
      df = get(paste0('listCellSizeProp', cellSize[cs]))[[paste0('occup', occupancy[ocp])]]
      # Boreal
      polygon(c((1:nrow(df)), rev((1:nrow(df)))),
            c(df$meanB + df$ciB, rev(df$meanB - df$ciB)), col = colsT[ocp], border = FALSE)
      lines(df$meanB, col = cols[ocp])
      # Temperate
      polygon(c((1:nrow(df)), rev((1:nrow(df)))),
            c(df$meanT + df$ciT, rev(df$meanT - df$ciT)), col = colsT[ocp], border = FALSE)
      lines(df$meanT, col = cols[ocp])
    }
    # Boreal
    abline(h = max(df[, 'meanB']), lty = 3, col = 'grey', lwd = 2)
    mtext('Boreal', 2, at = max(df[, 'meanB']), cex = 0.7)
    # Temperate
    abline(h = max(df[, 'meanT']), lty = 3, col = 'grey', lwd = 2)
    mtext('Temperate', 2, at = max(df[, 'meanT']), cex = 0.7)
    # Coordinates
    if(cs == 1) {mtext('South', 1, line = -1, cex = 0.75); mtext('North', 3, line = -1, cex = 0.75)}
    # legend
    if(cs == 1) legend('topleft', legend = occupancy, lty = 1, col = cols, bty = 'n', cex = 0.8)
    # Management practice
    mtext(paste0('cellSize = ', cellSize[cs]), 3, cex = 0.9)
    # labs
    if(cs == 3 | cs == 4) mtext('Time (years * 5)', 1, line = 1.2, cex = 0.9)
    if(cs == 1 | cs == 3) mtext('Latitudinal gradient', 2, line = 1.2, cex = 0.9)
  }
  dev.off()
#



#plot km migration distance in function of time

  #define ylim
  yLim <- c(-10, 10)
  names(listCellSizeDist1)

  pdf('simulations/migrationDist_rangeLimit.pdf', height = 6)
  par(mfrow = c(2, 2), mar = c(2.5, 2.5, 1, 0.5), mgp = c(1, 0.2, 0), tck = -.01, cex = 0.8)

  for(cs in 1:length(cellSize)) {
    plot(0, pch = '', xlim = c(0, 200), ylim = yLim, xlab = '', ylab = '')

    for(ocp in 1:length(occupancy)) {
      df = get(paste0('listCellSizeDist', cellSize[cs]))[[paste0('occup', occupancy[ocp])]]
      # Boreal
      polygon(c((1:nrow(df)), rev((1:nrow(df)))),
            c(df$meanB + df$ciB, rev(df$meanB - df$ciB)), col = colsT[ocp], border = FALSE)
      lines(df$meanB, col = cols[ocp])
      # Temperate
      polygon(c((1:nrow(df)), rev((1:nrow(df)))),
            c(df$meanT + df$ciT, rev(df$meanT - df$ciT)), col = colsT[ocp], border = FALSE)
      lines(df$meanT, col = cols[ocp])
    }
    # legend
    if(cs == 1) legend('topleft', legend = occupancy, lty = 1, col = cols, bty = 'n', cex = 0.8)
    # title
    mtext(paste0('cellSize = ', cellSize[cs]), 3, cex = 0.9)
    # labs
    if(cs == 3 | cs == 4) mtext('Time (years * 5)', 1, line = 1.2, cex = 0.9)
    if(cs == 1 | cs == 3) mtext('Anual migration distance (km/year)', 2, line = 1.2, cex = 0.9)
  }
  dev.off()
#



# plot km migration distance mean and sd in function of occupancy

  totalOcc = length(occupancy)

  pdf('simulations/migrationRate_rangeLimit.pdf', height = 6)
  par(mfrow = c(2, 2), mar = c(2.5, 2.5, 1, 0.5), mgp = c(1, 0.2, 0), tck = -.01, cex = 0.8)

  for(cs in 1:length(cellSize)) {
    plot(1:(totalOcc * 2), 1:(totalOcc * 2), pch = '', ylim = c(0.04, 0.3), xlab = '', ylab = '', xaxt = 'n')
    countB = 0
    countT = 1
    for(ocp in 1:length(occupancy)) {
      df = get(paste0('listCellSizetotalDist', cellSize[cs]))[[paste0('occup', occupancy[ocp])]]
      # Boreal
      arrows(ocp + countB, df['B', 1] - df['B', 2], ocp + countB, df['B', 1] + df['B', 2], length=0.05, angle=90, code=3)
      points(ocp + countB, df['B', 'mean'], pch = 19, col = 'darkcyan')
      # Temperate
      arrows(ocp + countT, df['T', 1] - df['T', 2], ocp + countT, df['T', 1] + df['T', 2], length=0.05, angle=90, code=3)
      points(ocp + countT, df['T', 'mean'], pch = 19, col = 'orange')
      countB = countB + 1; countT = countT + 1
      }
      # separate occupancy values
      abline(v = (2 * 1:(totalOcc - 1)) + 0.5, lty = 2, col = 'gray', lwd = 0.8)
      # xlab
      axis(1, at = (1 * seq(1, (totalOcc * 2), 2)) + 0.5, labels = occupancy)
      # legend
      if(cs == 1) legend('topleft', legend = c('Boreal', 'Temperate'), pch = 19, col = c('darkcyan', 'orange'), bty = 'n', cex = 0.8)
      # title
      mtext(paste0('cellSize = ', cellSize[cs]), 3, cex = 0.9)
      # labs
      if(cs == 3 | cs == 4) mtext('Range limit occupancy', 1, line = 1.2, cex = 0.9)
      if(cs == 1 | cs == 3) mtext('Mean migration rate of sim (Km/year)', 2, line = 1.2, cex = 0.9)

    }
    dev.off()
#
