###############################
# Automate the creation of R script and bash files to run simulation
# Simulation to test for range limit occupancy
# Will Vieira
# May 1, 2019
# Last update: May 1, 2019
##############################

##############################
# Steps:
  # define simulation variants
  # create initial landscapes
  # create all subfolders for the simulation output
  # for each sim, create a bash + Rscript file and submit it
##############################

library(STManaged)
set.seed(42)

# define simulation variants

  # 6 different sizes interacting with 5 management scenarios = 30 simulations
  # Each simulation will be repeated 30 times following a different initial landscape
  cellSize = c(0.5, 0.8, 1, 2.5)
  managPractice <- 0
  managInt <- 0
  reps = 1:15

#



# create initial landscapes (30 for each cell size)

  # create folder to store all landscapes
  initLandFoder = 'initLandscape'
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



# create bash with Rscript
  for(cellSz in cellSize) {
    for(mg in managPractice) {
      for(mgInt in managInt) {
        for(rp in reps) {

          # define simulation name
          simName = paste0('cs', cellSz, 'pract', mg, 'rep', rp)
          # define initLand file
          initFile = paste0(initLandFoder, '/initLand_cellSize_', cellSz, '_rep_', rp, '.RDS')
          # define fileOutput
          fOutput = paste0('cellSize_', cellSz, '_pract', '_', mg, '_rep_', rp)
          # define folderOutput
          fdOutput = paste0('cellSize_', cellSz, '_pract', '_', mg)

          # define management practice and intensity
          management <- c(0, 0, 0, 0)
          if(mg != 0) {
            management[mg] <- mgInt
          }

          # memory usage
          if(cellSz == 0.5) {
            mem = 3000
          }else{
            mem = 1500
          }

# Bash + Rscript
bash <- paste0('#!/bin/bash

#SBATCH --account=def-dgravel
#SBATCH -t 1-00:00:00
#SBATCH --mem=', mem, '
#SBATCH --job-name=', simName, '
#SBATCH --mail-user=willian.vieira@usherbrooke.ca
#SBATCH --mail-type=FAIL

R --vanilla <<code', '\n',
'library(STManaged)

initLand <- readRDS("', initFile,'")

run_model(steps = 200, initLand = initLand,
    managInt = c(', management[1], ',', management[2], ',', management[3], ',', management[4], '),
    RCP = 4.5,
    stoch = TRUE,
    cores = 1,
    outputLand = NA,
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
        }
      }
    }
  }
#
