###############################
# Plot management intensity simulation
# Will Vieira
# May 6, 2019
##############################

##############################
# Steps:
  # getting data
  # organize RCP and migration distance in km
  # plot RCP in function of time
  # plot km migration distance in function of time
  # plot km migration distance mean and sd in function of omgIntupancy
##############################


library(STManaged)

# getting data

  cellSize = 0.5
  managPractice <- 1:4
  managInt <- c(0.05, 0.1, 0.2, 0.4, 0.8)
  reps = 1:15
  steps = 200

  mainFolder = 'output/managInt/'
  for(mg in managPractice) {
    for(mgInt in managInt) {
      folderName = paste0('mg_', mg, '_mgInt_', mgInt)
      for(rp in reps) {
        fileName = paste0('mg_', mg, '_mgInt_', mgInt, '_rep_', rp, '.RDS')
        assign(sub('\\.RDS$', '', fileName), readRDS(paste0(mainFolder, folderName, '/', fileName)))
      }
    }
    cat('   loading ouput files ', round(which(mg == managPractice)/length(managPractice) * 100, 1), '%\r')
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

  # cell size
  cs <- cellSize

  count = 1
  for(mg in managPractice) {

    # list to store all different managements results (each list is for one plot)
    listManagPracProp = list()
    listManagPracRange = list()
    listManagPracMig = list()

    # for each management practice, save the mean and sd of all 30 replications
    for(mgInt in managInt) {
      # name of files for each replication
      fileNames = paste0('mg_', mg, '_mgInt_', mgInt, '_rep_', reps)
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

        cat('   calculating ->', round(count/(length(managPractice) * length(managInt) * length(reps)) * 100, 0), '%\r')
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
      listManagPracProp[[paste0('mgInt_', mgInt)]] <- propSummary
      listManagPracRange[[paste0('mgInt_', mgInt)]] <- rangeSummary
      listManagPracMig[[paste0('mgInt_', mgInt)]] <- migSummary
    }

    # save specific cellSize list
    assign(paste0('listManagPracProp', mg), listManagPracProp)
    assign(paste0('listManagPracRange', mg), listManagPracRange)
    assign(paste0('listManagPracMig', mg), listManagPracMig)

  }

#



# plot landscape proportion
  # define cellSize colors
  cols = rainbow(length(managInt))
  colsT = rainbow(length(managInt), alpha = 0.2)
  titleLine = 1 + 14 * 0:3
  mgTitles = c('plantation', 'harvest', 'thinning', 'enrichment')

  pdf('simulations/landProp_mangInt.pdf', height = 9)
  par(mfrow = c(4, 2), mar = c(2.1, 2.5, 1.1, 0.5), mgp = c(1.2, 0.2, 0), tck = -.01, cex = 0.8)
  for(mg in managPractice) {
    # boreal
    plot(0, pch = '', xlim = c(0, 1), ylim = c(0, 1), xlab = '', ylab = 'Boreal omgIntupancy')
    for(mgInt in 1:length(managInt)) {
      df = get(paste0('listManagPracProp', mg))[[paste0('mgInt_', managInt[mgInt])]]
      polygon(c((1:nrow(df))/nrow(df), rev((1:nrow(df))/nrow(df))),
            c(smooth.spline(df$meanB + df$ciB, spar = 0.4)$y, rev(smooth.spline(df$meanB - df$ciB, spar = 0.4)$y)), col = colsT[mgInt], border = FALSE)
      lines(smooth.spline(x = df$x, y = df$meanB, spar = 0.4), col = cols[mgInt])
    }
    if(mg == 1) legend('topright', legend = managInt, lty = 1, col = cols, cex = 0.9, bty = 'n', title = 'manag intensity')
    if(mg == 4) mtext('Latitudinal gradient', 1, line = 1.1, cex = 0.85)
    # temperate
    plot(0, pch = '', xlim = c(0, 1), ylim = c(0, 1), xlab = '', ylab = 'Temperate omgIntupancy')
    for(mgInt in 1:length(managInt)) {
      df = get(paste0('listManagPracProp', mg))[[paste0('mgInt_', managInt[mgInt])]]
      polygon(c((1:nrow(df))/nrow(df), rev((1:nrow(df))/nrow(df))),
            c(smooth.spline(df$meanT + df$ciT, spar = 0.4)$y, rev(smooth.spline(df$meanT - df$ciT, spar = 0.4)$y)), col = colsT[mgInt], border = FALSE)
      lines(smooth.spline(x = df$x, y = df$meanT, spar = 0.4), col = cols[mgInt])
    }
    if(mg == 4) mtext('Latitudinal gradient', 1, line = 1.1, cex = 0.85)
    mtext(mgTitles[mg], side = 3, line = - titleLine[mg], outer = T, cex = 0.9)
  }
  dev.off()
#



# plot range limit in function of time
  pdf('simulations/rangeLimit_managInt.pdf', height = 6)
  par(mfrow = c(2, 2), mar = c(2.5, 2.5, 1, 0.5), mgp = c(1, 0.2, 0), tck = -.01, cex = 0.8)

  for(mg in managPractice) {
    plot(0, pch = '', xlim = c(0, steps), ylim = c(1, 0), xlab = '', ylab = '', yaxt = 'n')
    for(mgInt in 1:length(managInt)) {
      df = get(paste0('listManagPracRange', mg))[[paste0('mgInt_', managInt[mgInt])]]
      # Boreal
      polygon(c((1:nrow(df)), rev((1:nrow(df)))),
            c(df$meanB + df$ciB, rev(df$meanB - df$ciB)), col = colsT[mgInt], border = FALSE)
      lines(df$meanB, col = cols[mgInt])
      # Temperate
      polygon(c((1:nrow(df)), rev((1:nrow(df)))),
            c(df$meanT + df$ciT, rev(df$meanT - df$ciT)), col = colsT[mgInt], border = FALSE)
      lines(df$meanT, col = cols[mgInt])
    }
    # Boreal
    abline(h = max(df[, 'meanB']), lty = 3, col = 'grey', lwd = 2)
    mtext('Boreal', 2, at = max(df[, 'meanB']), cex = 0.7)
    # Temperate
    abline(h = max(df[, 'meanT']), lty = 3, col = 'grey', lwd = 2)
    mtext('Temperate', 2, at = max(df[, 'meanT']), cex = 0.7)
    # Coordinates
    if(mg == 1) { mtext('South', 1, line = -1, cex = 0.75); mtext('North', 3, line = -1, cex = 0.75) }
    # legend
    if(mg == 3) legend('topleft', legend = managInt, lty = 1, col = cols, bty = 'n', cex = 0.9, title = 'manag intensity')
    # Management practice
    mtext(mgTitles[mg], 3, cex = 0.9)
    # labs
    if(mg == 3 | mg == 4) mtext('Time steps (steps * 5 = year)', 1, line = 1.2, cex = 0.9)
    if(mg == 1 | mg == 3) mtext('Latitudinal gradient', 2, line = 1.2, cex = 0.9)
  }
  dev.off()
#



# plot migration rate in function of cell size

  totalMgInt = length(managInt)

  pdf('simulations/migrationRate_managInt.pdf', height = 6)
  par(mfrow = c(2, 2), mar = c(2.5, 2.5, 1, 0.5), mgp = c(1, 0.2, 0), tck = -.01, cex = 0.8)

  for(mg in managPractice) {
    plot(1:(totalMgInt * 2), 1:(totalMgInt * 2), pch = '', ylim = c(0.05, 0.5), xlab = '', ylab = '', xaxt = 'n')
    countB = 0
    countT = 1
    for(mgInt in 1:length(managInt)) {
      df = get(paste0('listManagPracMig', mg))[[paste0('mgInt_', managInt[mgInt])]]
      # Boreal
      arrows(mgInt + countB, df['B', 1] - df['B', 2], mgInt + countB, df['B', 1] + df['B', 2], length=0.05, angle=90, code=3)
      points(mgInt + countB, df['B', 'mean'], pch = 19, col = 'darkcyan')
      # Temperate
      arrows(mgInt + countT, df['T', 1] - df['T', 2], mgInt + countT, df['T', 1] + df['T', 2], length=0.05, angle=90, code=3)
      points(mgInt + countT, df['T', 'mean'], pch = 19, col = 'orange')
      countB = countB + 1; countT = countT + 1
    }

    # separate cellSize values
    abline(v = (2 * 1:(totalMgInt - 1)) + 0.5, lty = 2, col = 'gray', lwd = 0.8)
    # xlab
    axis(1, at = (1 * seq(1, (totalMgInt * 2), 2)) + 0.5, labels = managInt)
    # legend
    if(mg == 1) legend('topleft', legend = c('Boreal', 'Temperate'), pch = 19, col = c('darkcyan', 'orange'), bty = 'n', cex = 0.9)
    # title
    mtext(mgTitles[mg], 3, cex = 0.9)
    # labs
    if(mg == 3 | mg == 4) mtext('Management intensity', 1, line = 1.2, cex = 0.9)
    if(mg == 1 | mg == 3) mtext('Mean migration rate of sim. (Km/year)', 2, line = 1.2, cex = 0.9)

  }
  dev.off()

#
