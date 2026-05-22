#' performing a retrospective analysis, hindcast cross-validation and prediction skill for EM
#' 
#' @iter an iteration number in simulation replicates
#' @stock stock name
#' @species species name
#' @dir_out a directory for the EM output files
#' @dir_retro a directory for retrospective analysis files
#' @ss3exe the location of a ss3 excutable
#' 

run_retro <- function(iter = iter,
                      stock = stock,
                      species = species,
                      dir_out = dir_out,
                      dir_retro = dir_retro,
                      ss3exe = ss3exe,
                      verbose = FALSE
    ) {
  
    # copy ss3 input files from EM
    files <- c("data_echo.ss_new", "control.ss_new", "starter.ss", "forecast.ss", "ss3.par")
    file.copy(from = file.path(dir_out, files), to = dir_retro) 
    
    # update starter file
    start_retro <- r4ss::SS_readstarter(file = file.path(dir_retro, "starter.ss"),  verbose = verbose)
    start_retro$datfile <- "data_echo.ss_new"
    start_retro$ctlfile <- "control.ss_new" 
    r4ss::SS_writestarter(start_retro, dir = dir_retro, overwrite=TRUE)

    # run retrospective analysis
    r4ss::retro(dir = dir_retro, exe = ss3exe, years = 0:-5, verbose = verbose)
    
    # post-process outputs
    retro_mods <- r4ss::SSgetoutput(dirvec = file.path(dir_retro, "retrospectives", paste0("retro", seq(0, -5, by = -1))), verbose = verbose)
    
    # save summary outputs
    readr::write_rds(retro_mods, file = file.path(dir_retro, paste0("retro_output.rds"))) 
  
  return(retro_mods)
}

