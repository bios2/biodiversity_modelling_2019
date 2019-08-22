###############################
# Automate the creation of R script and bash files to run simulation
# Simulation to test for cell size
# Will Vieira
# March 30, 2019
# Last update: May 2, 2019
##############################

##############################
# Steps:
  # define simulation variants
  # create initial landscapes (30 for each cell size)
  # create all subfolders for the simulation output
  # for each sim, create a bash + Rscript file and submit it
##############################

library(STManaged)
set.seed(42)

# define simulation variants

  # 7 different sizes interacting with 5 management scenarios = 30 simulations
  # Each simulation will be repeated 30 times following a different initial landscape
  cellSize = c(0.1, 0.3, 0.5, 0.8, 1, 2.5, 5)
  managPractice <- 0:4
  managInt <- c(0.0025, 0.001, 0.0025, 0.0025)
  reps = 1:30

#



# create initial landscapes (30 for each cell size)

  # create folder to store all landscapes
  initLandFoder = '../initLandscape'
  if(!dir.exists(initLandFoder)) dir.create(initLandFoder)

  # file names
  initLandFiles = do.call(paste, c(expand.grid(paste0("initLand_cellSize_", cellSize), paste0("_rep_", reps), ".RDS"), sep = ""))

  # check if initial landscapes are already created (very time consuming)
  files = dir(initLandFoder)
  run = ifelse(!all(initLandFiles %in% files), T, F)
  cat('creating init_landscapes ? -> ', run, '\n')

  # 1 land for each repetion x 6 different cell size = 180 initLand objects
  if(run == TRUE) {
  count = 0
    for(cellSz in cellSize) {
      for(rp in reps) {
        saveRDS(create_virtual_landscape(climRange = c(-2.5, 0.35), cellSize = cellSz), file = paste0(initLandFoder, '/initLand_cellSize_', cellSz, '_rep_', rp, '.RDS'))
        cat('    creating initial landscapes', round((rp + count)/(length(cellSize) * length(reps)) * 100, 1), '%\r')
      }
      count = count + length(reps)
    }
  }

#



# create all subfolders for the simulation output

  mainFolder = 'output'
  if(!dir.exists(mainFolder)) dir.create(mainFolder)
  cs <- paste0('cellSize_', cellSize)
  mg <- paste0('pract_', managPractice)
  folders <- do.call(paste, c(expand.grid(cs, mg), sep = "_"))
  invisible(sapply(paste0(mainFolder, '/', folders), dir.create))

#



# create bash with Rscript and run it
  job = 1
  for(cellSz in cellSize) {
    for(mg in managPractice) {
      for(rp in reps) {

        # define simulation name
        simName = paste0(cellSz, '_', mg, '_', rp)
        # define initLand file
        initFile = paste0(initLandFoder, '/initLand_cellSize_', cellSz, '_rep_', rp, '.RDS')
        # define fileOutput
        fOutput = paste0('cellSize_', cellSz, '_pract', '_', mg, '_rep_', rp)
        # define folderOutput
        fdOutput = paste0('cellSize_', cellSz, '_pract', '_', mg)

        # define management practice and intensity
        management <- c(0, 0, 0, 0)
        if(mg != 0) {
          management[mg] <- managInt[mg]
        }

        # define running time and memory depending on cell size
        if(cellSz == 0.1 | cellSz == 0.3 | cellSz == 0.5) {
          runTime <- '3-12:00:00'
          memory <- 3000
        }else{
          runTime <- '1-00:00:00'
          memory <- 1500
        }

        # send me an email when the longest simulation is over
        if(cellSz == 0.1 & mg == managPractice[length(managPractice)] & rp == reps[length(reps)]) {
          mail <- 'ALL'
        }else {
          mail <- 'FAIL'
        }


# Bash + Rscript
bash <- paste0('#!/bin/bash

#SBATCH --account=def-dgravel
#SBATCH -t ', runTime, '
#SBATCH --mem=', memory, '
#SBATCH --job-name=', simName, '
#SBATCH --mail-user=willian.vieira@usherbrooke.ca
#SBATCH --mail-type=', mail, '

R --vanilla <<code', '\n',
'library(STManaged)

initLand <- readRDS("', initFile,'")

run_model(steps = 200, initLand = initLand,
    managInt = c(', management[1], ',', management[2], ',', management[3], ',', management[4], '),
    RCP = 4.5,
    stoch = TRUE,
    cores = 1,
    outputLand = c(0, 200),
    rangeLimitOccup = 0.85,
    saveOutput = TRUE,
    fileOutput = "', fOutput, '",
    folderOutput = "', fdOutput, '")
code')

        # save sh file
        system(paste0("echo ", "'", bash, "' > sub.sh"))

        # run sh
        system('sbatch sub.sh')

        # remove sh file
        system('rm sub.sh')

        cat('                           - job ', job, 'of', length(cellSize) * length(managPractice) * length(reps), '\r')
        job <- job + 1
      }
    }
  }
#
