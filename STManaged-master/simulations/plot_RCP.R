###############################
# Plot RCP simulation
# Will Vieira
# May 5, 2019
##############################

##############################
# Steps:
  # getting data
  # organize RCP and migration distance in km
  # plot RCP in function of time
  # plot km migration distance in function of time
  # plot km migration distance mean and sd in function of occupancy
##############################


library(STManaged)

# getting data

  cellSize <- c(0.3, 0.5, 0.8, 1)
  managPractice <- 0
  managInt <- 0
  RCP <- c(2.6, 4.5, 6, 8.5)
  reps = 1:15
  steps = 200

  mainFolder = 'output/RCP/'
  for(cs in cellSize) {
    for(cc in RCP) {
      folderName = paste0('cellSize_', cs, '_cc_', cc)
      for(rp in reps) {
        fileName = paste0('cellSize_', cs, '_cc_', cc, '_rep_', rp, '.RDS')
        assign(sub('\\.RDS$', '', fileName), readRDS(paste0(mainFolder, folderName, '/', fileName)))
      }
    }
    cat('   loading ouput files ', round(which(cs == cellSize)/length(cellSize) * 100, 1), '%\r')
  }
#



# organize range limit and migration distance in km for all 3 plots

  # Confidence interval function
  ci = function(x) qt(0.975, df=length(x)-1)*sd(x)/sqrt(length(x))

  # function to get summary for each col
  getProp <- function(x, nRow) {
     B <- sum(x == 1)/nRow
     T <- sum(x == 2)/nRow
     M <- sum(x == 3)/nRow
     R <- 1 - sum(B, T, M)
     return(setNames(c(B, T, M, R), c('B', 'T', 'M', 'R')))
  }

  count = 1
  for(cs in cellSize) {

    # list to store all different managements results (each list is for one plot)
    listCellSizeProp = list()
    listCellSizeRange = list()
    listCellSizeMig = list()

    # management practice
    cc = managPractice
    # for each management practice, save the mean and sd of all 30 replications
    for(cc in RCP) {
      # name of files for each replication
      fileNames = paste0('cellSize_', cs, '_cc_', cc, '_rep_', reps)
      # data frames to store nCol's proportion for each forest state (to be used latter for mean and IC)
      propB = propT = data.frame(matrix(rep(NA, length(reps) * (get(fileNames[[1]])[['nCol']])), ncol = reps[length(reps)]))
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
        sim <- get(fileNames[rp])
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

        cat('   calculating ->', round(count/(length(cellSize) * length(RCP) * length(reps)) * 100, 0), '%\r')
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
      listCellSizeProp[[paste0('cc_', cc)]] <- propSummary
      listCellSizeRange[[paste0('cc_', cc)]] <- rangeSummary
      listCellSizeMig[[paste0('cc_', cc)]] <- migSummary
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
  titleLine = 1 + 14 * 0:3

  pdf('simulations/landProp_RCP.pdf', height = 9)
  par(mfrow = c(4, 2), mar = c(2.1, 2.5, 1.1, 0.5), mgp = c(1.2, 0.2, 0), tck = -.01, cex = 0.8)
  for(cs in 1:length(cellSize)) {
    # boreal
    plot(0, pch = '', xlim = c(0, 1), ylim = c(0, 1), xlab = '', ylab = 'Boreal occupancy')
      for(cc in 1:length(RCP)) {
      df = get(paste0('listCellSizeProp', cellSize[cs]))[[paste0('cc_', RCP[cc])]]
      polygon(c((1:nrow(df))/nrow(df), rev((1:nrow(df))/nrow(df))),
            c(smooth.spline(df$meanB + df$ciB, spar = 0.4)$y, rev(smooth.spline(df$meanB - df$ciB, spar = 0.4)$y)), col = colsT[cc], border = FALSE)
      lines(smooth.spline(x = df$x, y = df$meanB, spar = 0.4), col = cols[cc])
    }
      if(cs == 1) legend('topright', legend = RCP, lty = 1, col = cols, cex = 0.9, bty = 'n', title = 'RCP')
      if(cs == 4) mtext('Latitudinal gradient', 1, line = 1.1, cex = 0.85)
      # temperate
      plot(0, pch = '', xlim = c(0, 1), ylim = c(0, 1), xlab = '', ylab = 'Temperate occupancy')
      for(cc in 1:length(RCP)) {
        df = get(paste0('listCellSizeProp', cellSize[cs]))[[paste0('cc_', RCP[cc])]]
        polygon(c((1:nrow(df))/nrow(df), rev((1:nrow(df))/nrow(df))),
              c(smooth.spline(df$meanT + df$ciT, spar = 0.4)$y, rev(smooth.spline(df$meanT - df$ciT, spar = 0.4)$y)), col = colsT[cc], border = FALSE)
        lines(smooth.spline(x = df$x, y = df$meanT, spar = 0.4), col = cols[cc])
      }
      if(cs == 4) mtext('Latitudinal gradient', 1, line = 1.1, cex = 0.85)
      mtext(paste('cell size =', cellSize[cs], 'Km'), side = 3, line = - titleLine[cs], outer = T, cex = 0.9)
    }
    dev.off()
#



# plot range limit in function of time
  pdf('simulations/rangeLimit_RCP.pdf', height = 6)
  par(mfrow = c(2, 2), mar = c(2.5, 2.5, 1, 0.5), mgp = c(1, 0.2, 0), tck = -.01, cex = 0.8)

  for(cs in 1:length(cellSize)) {
    plot(0, pch = '', xlim = c(0, steps), ylim = c(1, 0), xlab = '', ylab = '', yaxt = 'n')
    for(cc in 1:length(RCP)) {
      df = get(paste0('listCellSizeRange', cellSize[cs]))[[paste0('cc_', RCP[cc])]]
      # Boreal
      polygon(c((1:nrow(df)), rev((1:nrow(df)))),
            c(df$meanB + df$ciB, rev(df$meanB - df$ciB)), col = colsT[cc], border = FALSE)
      lines(df$meanB, col = cols[cc])
      # Temperate
      polygon(c((1:nrow(df)), rev((1:nrow(df)))),
            c(df$meanT + df$ciT, rev(df$meanT - df$ciT)), col = colsT[cc], border = FALSE)
      lines(df$meanT, col = cols[cc])
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
    if(cs == 1) legend('topleft', legend = RCP, lty = 1, col = cols, bty = 'n', cex = 0.9, title = 'RCP')
    # Management practice
    mtext(paste('cell size =', cellSize[cs], 'Km'), 3, cex = 0.9)
    # labs
    if(cs == 3 | cs == 4) mtext('Time steps (steps * 5 = year)', 1, line = 1.2, cex = 0.9)
    if(cs == 1 | cs == 3) mtext('Latitudinal gradient', 2, line = 1.2, cex = 0.9)
  }
  dev.off()
#



# plot migration rate in function of cell size

  totalCC = length(RCP)

  pdf('simulations/migrationRate_RCP.pdf', height = 6)
  par(mfrow = c(2, 2), mar = c(2.5, 2.5, 1, 0.5), mgp = c(1, 0.2, 0), tck = -.01, cex = 0.8)

  for(cs in 1:length(cellSize)) {
    plot(1:(totalCC * 2), 1:(totalCC * 2), pch = '', ylim = c(0.03, 0.44), xlab = '', ylab = '', xaxt = 'n')
    countB = 0
    countT = 1
    for(cc in 1:length(RCP)) {
      df = get(paste0('listCellSizeMig', cellSize[cs]))[[paste0('cc_', RCP[cc])]]
      # Boreal
      arrows(cc + countB, df['B', 1] - df['B', 2], cc + countB, df['B', 1] + df['B', 2], length=0.05, angle=90, code=3)
      points(cc + countB, df['B', 'mean'], pch = 19, col = 'darkcyan')
      # Temperate
      arrows(cc + countT, df['T', 1] - df['T', 2], cc + countT, df['T', 1] + df['T', 2], length=0.05, angle=90, code=3)
      points(cc + countT, df['T', 'mean'], pch = 19, col = 'orange')
      countB = countB + 1; countT = countT + 1
    }

    # separate cellSize values
    abline(v = (2 * 1:(totalCC - 1)) + 0.5, lty = 2, col = 'gray', lwd = 0.8)
    # xlab
    axis(1, at = (1 * seq(1, (totalCC * 2), 2)) + 0.5, labels = RCP)
    # legend
    if(cs == 1) legend('topleft', legend = c('Boreal', 'Temperate'), pch = 19, col = c('darkcyan', 'orange'), bty = 'n', cex = 0.9)
    # title
    mtext(paste('cell size =', cellSize[cs], 'Km'), 3, cex = 0.9)
    # labs
    if(cs == 3 | cs == 4) mtext('Climate change scenario (RCP)', 1, line = 1.2, cex = 0.9)
    if(cs == 2) mtext('Mean migration rate of sim. (Km/year)', 2, line = 1.2, cex = 0.9)

  }
  dev.off()

#
