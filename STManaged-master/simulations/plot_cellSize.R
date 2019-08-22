###############################
# Plot cell size simulation
# Will Vieira
# April 8, 2019
##############################

##############################
# Steps:
  # getting data
  # calculate col proportion, range limit and migration rate
  # plot landscape proportion
  # plot range limit in function of time
  # plot migration rate in function of cell size
##############################



# getting data (it takes about 10 minutes to load all 900 simulations)
  cellSize = c(0.1, 0.3, 0.5, 0.8, 1, 2.5, 5)
  managPractice <- 0:4
  managInt <- 0.15
  reps = 1:30
  steps = 200
  nCols <- setNames(round(800/cellSize, 0), cellSize)

# calculate col proportion, range limit and migration rate

  # function to get summary for each col
  getProp <- function(x, nRow) {
     B <- sum(x == 1)/nRow
     T <- sum(x == 2)/nRow
     M <- sum(x == 3)/nRow
     R <- 1 - sum(B, T, M)
     return(setNames(c(B, T, M, R), c('B', 'T', 'M', 'R')))
  }

  # Confidence interval function
  ci = function(x) qt(0.975, df=length(x)-1)*sd(x)/sqrt(length(x))


  # get 30 summary data frames (6 cellSizes * 5 managements)
  mainFolder = 'output/cellSize/'
  count = 1
  for(cs in cellSize) {
    # list to store all different managements results
    listCellSizeProp = list()
    listCellSizeRange = list()
    listCellSizeMig = list()

    # for each management practice, save the mean and sd of all 30 replications
    for(mg in managPractice) {
      # folder name to look for simulation file
      folderName = paste0('cellSize_', cs, '_pract_', mg)

      # data frames to store nCol's proportion for each forest state (to be used latter for mean and IC)
        propB = propT = data.frame(matrix(rep(NA, length(reps) * nCols[cs == cellSize]), ncol = reps[length(reps)]))
      # data frames to store km distance of migration
      rangeB = rangeT = data.frame(matrix(rep(NA, length(reps) * (steps + 1)), ncol = reps[length(reps)]))
      # data frame to store the total migration rate
      mig = data.frame(B = rep(NA, length(reps)), T = rep(NA, length(reps)))

      # get the information for each of the next 3 plots and save it the above data frames
      # (i) landscape proportion
      # (ii) range limit over time
      # (iii) migration rate
      for(rp in reps) {
        # get simulation
        fileName = paste0('cellSize_', cs, '_pract_', mg, '_rep_', rp, '.RDS')
        sim <- readRDS(paste0(mainFolder, folderName, '/', fileName))
        rg <- sim[['rangeLimit']]
        nCol <- sim[['nCol']]
        nRow <- sim[['nRow']]

        # landscape proportion
        land = matrix(sim[[paste0('land_T', steps)]], ncol = nCol, byrow = T)
        props = apply(land, 2, getProp, nRow = nRow)
        propB[, rp] = props["B", ]
        propT[, rp] = props["T", ]

        # range limit over time
        rangeB[, rp] = rg[, 'limitB']
        rangeT[, rp] = rg[, 'limitT']

        #migration rate
        rg[, 2:3] <- rg[, 2:3] * nCol
        mig[rp, ] <- (rg[1, 2:3] - rg[steps + 1, 2:3]) * cs/(steps * 5)

        cat('   calculating ->', round(count/(length(cellSize) * length(managPractice) * length(reps)) * 100, 0), '%\r')
        count <- count + 1
      }

      # calculate mean and sd
        # landscape proportion
        propSummary <- data.frame(meanB = apply(propB, 1, mean))
        propSummary$ciB <- apply(propB, 1, ci)
        propSummary$meanT <- apply(propT, 1, mean)
        propSummary$ciT <- apply(propT, 1, ci)

        # range limit over time
        rangeSummary <- data.frame(meanB = apply(rangeB, 1, mean))
        rangeSummary$ciB <- apply(rangeB, 1, ci)
        rangeSummary$meanT <- apply(rangeT, 1, mean)
        rangeSummary$ciT <- apply(rangeT, 1, ci)

        # migration rate
        migSummary <- data.frame(mean = apply(mig, 2, mean))
        migSummary$ci <- apply(mig, 2, ci)


      # add a x axis value to standardize for all cell size
      propSummary$x = (1:nCol)/nCol

      # remove border
      propSummary = propSummary[c(-1, -nrow(propSummary)), ]

      # append in the list
      listCellSizeProp[[paste0('pract_', mg)]] <- propSummary
      listCellSizeRange[[paste0('pract_', mg)]] <- rangeSummary
      listCellSizeMig[[paste0('pract_', mg)]] <- migSummary
    }

    # save specific cellSize list
    assign(paste0('listCellSizeProp', cs), listCellSizeProp)
    assign(paste0('listCellSizeRange', cs), listCellSizeRange)
    assign(paste0('listCellSizeMig', cs), listCellSizeMig)

  }
#



# plot landscape proportion
  # define cellSize colors
  cols = rainbow(length(cellSize))
  colsT = rainbow(length(cellSize), alpha = 0.2)
  titleLine = 1 + 15 * 0:4
  mgTitles = c('noManagement', 'plantation', 'harvest', 'thinning', 'enrichment')

  pdf('simulations/landProp_cellSize.pdf', height = 12)
  par(mfrow = c(5, 2), mar = c(2.1, 2.5, 1.1, 0.5), mgp = c(1.2, 0.2, 0), tck = -.01, cex = 0.8)
  for(mg in managPractice) {
    # boreal
    plot(0, pch = '', xlim = c(0, 1), ylim = c(0, 1), xlab = '', ylab = 'Boreal occupancy')
    for(cs in 1:length(cellSize)) {
      df = get(paste0('listCellSizeProp', cellSize[cs]))[[paste0('pract_', mg)]]
      polygon(c((1:nrow(df))/nrow(df), rev((1:nrow(df))/nrow(df))),
            c(smooth.spline(df$meanB + df$ciB, spar = 0.4)$y, rev(smooth.spline(df$meanB - df$ciB, spar = 0.4)$y)), col = colsT[cs], border = FALSE)
      lines(smooth.spline(x = df$x, y = df$meanB, spar = 0.4), col = cols[cs])
    }
    if(mg == 0) legend('topright', legend = cellSize, lty = 1, col = cols, bty = 'n')
    if(mg == 4) mtext('Latitudinal gradient', 1, line = 1.1, cex = 0.85)
    # temperate
    plot(0, pch = '', xlim = c(0, 1), ylim = c(0, 1), xlab = '', ylab = 'Temperate occupancy')
    for(cs in 1:length(cellSize)) {
      df = get(paste0('listCellSizeProp', cellSize[cs]))[[paste0('pract_', mg)]]
      polygon(c((1:nrow(df))/nrow(df), rev((1:nrow(df))/nrow(df))),
            c(smooth.spline(df$meanT + df$ciT, spar = 0.4)$y, rev(smooth.spline(df$meanT - df$ciT, spar = 0.4)$y)), col = colsT[cs], border = FALSE)
      lines(smooth.spline(x = df$x, y = df$meanT, spar = 0.4), col = cols[cs])
    }
    if(mg == 4) mtext('Latitudinal gradient', 1, line = 1.1, cex = 0.85)
    mtext(mgTitles[mg + 1], side = 3, line = - titleLine[mg + 1], outer = T, cex = 0.9)
  }
  dev.off()
#



# plot range limit in function of time
  pdf('simulations/rangeLimit_cellSize.pdf', height = 9)
  par(mfrow = c(3, 2), mar = c(2.5, 2.5, 1, 0.5), mgp = c(1, 0.2, 0), tck = -.01, cex = 0.8)

  for(mg in managPractice) {
    plot(0, pch = '', xlim = c(0, steps), ylim = c(1, 0), xlab = '', ylab = '', yaxt = 'n')
    for(cs in 1:length(cellSize)) {
      df = get(paste0('listCellSizeRange', cellSize[cs]))[[paste0('pract_', mg)]]
      # Boreal
      polygon(c((1:nrow(df)), rev((1:nrow(df)))),
            c(df$meanB + df$ciB, rev(df$meanB - df$ciB)), col = colsT[cs], border = FALSE)
      lines(df$meanB, col = cols[cs])
      # Temperate
      polygon(c((1:nrow(df)), rev((1:nrow(df)))),
            c(df$meanT + df$ciT, rev(df$meanT - df$ciT)), col = colsT[cs], border = FALSE)
      lines(df$meanT, col = cols[cs])
    }
    # Boreal
    abline(h = max(df[, 'meanB']), lty = 3, col = 'grey', lwd = 2)
    mtext('Boreal', 2, at = max(df[, 'meanB']), cex = 0.7)
    # Temperate
    abline(h = max(df[, 'meanT']), lty = 3, col = 'grey', lwd = 2)
    mtext('Temperate', 2, at = max(df[, 'meanT']), cex = 0.7)
    # Coordinates
    if(mg == 0) {mtext('South', 1, line = -1, cex = 0.75); mtext('North', 3, line = -1, cex = 0.75)}
    # legend
    if(mg == 0) legend('topleft', legend = cellSize, lty = 1, col = cols, bty = 'n', cex = 0.8)
    # Management practice
    mtext(mgTitles[mg + 1], 3, cex = 0.9)
    # labs
    if(mg == 3 | mg == 4) mtext('Time steps (steps * 5 = year)', 1, line = 1.2, cex = 0.9)
    if(mg == 2) mtext('Latitudinal gradient', 2, line = 1.2, cex = 0.9)
  }
  dev.off()
#



# plot migration rate in function of cell size

  totalCs = length(cellSize)

  pdf('simulations/migrationRate_cellSize.pdf', height = 9)
  par(mfrow = c(3, 2), mar = c(2.5, 2.5, 1, 0.5), mgp = c(1, 0.2, 0), tck = -.01, cex = 0.8)

  for(mg in managPractice) {
    plot(1:(totalCs * 2), 1:(totalCs * 2), pch = '', ylim = c(0.03, 0.38), xlab = '', ylab = '', xaxt = 'n')
    countB = 0
    countT = 1
    for(cs in 1:length(cellSize)) {
      df = get(paste0('listCellSizeMig', cellSize[cs]))[[paste0('pract_', mg)]]
      # Boreal
      arrows(cs + countB, df['B', 1] - df['B', 2], cs + countB, df['B', 1] + df['B', 2], length=0.05, angle=90, code=3)
      points(cs + countB, df['B', 'mean'], pch = 19, col = 'darkcyan')
      # Temperate
      arrows(cs + countT, df['T', 1] - df['T', 2], cs + countT, df['T', 1] + df['T', 2], length=0.05, angle=90, code=3)
      points(cs + countT, df['T', 'mean'], pch = 19, col = 'orange')
      countB = countB + 1; countT = countT + 1
    }

    # separate cellSize values
    abline(v = (2 * 1:(totalCs - 1)) + 0.5, lty = 2, col = 'gray', lwd = 0.8)
    # xlab
    axis(1, at = (1 * seq(1, (totalCs * 2), 2)) + 0.5, labels = cellSize)
    # legend
    if(mg == 0) legend('topleft', legend = c('Boreal', 'Temperate'), pch = 19, col = c('darkcyan', 'orange'), bty = 'n', cex = 0.8)
    # title
    mtext(mgTitles[mg + 1], 3, cex = 0.9)
    # labs
    if(mg == 3 | mg == 4) mtext('Landscape cell size (Km)', 1, line = 1.2, cex = 0.9)
    if(mg == 2) mtext('Mean migration rate of sim. (Km/year)', 2, line = 1.2, cex = 0.9)

  }
  dev.off()

#
