#' performing an age-structured production model (ASPM) for EM
#' 
#' @iter an iteration number in simulation replicates
#' @stock stock name
#' @species species name
#' @dir_out a directory for the EM output files
#' @dir_retro a directory for retrospective analysis files
#' @ss3exe the location of a ss3 excutable
#' @n_fleet the total number of fleets in the model
#' 
#' 

run_aspm <- function(iter = iter,
                     stock = stock,
                     species = species,
                     dir_out = dir_out,
                     dir_aspm = dir_aspm,
                     ss3exe = ss3exe,
                     n_fleet = n_fleet,
                     verbose = FALSE) {

  # generate file
  files <- c("data_echo.ss_new", "control.ss_new", "starter.ss", "forecast.ss", "ss3.par")
  file.copy(from = file.path(dir_out, files), to = dir_aspm)
  
  # set the recruitment devations in ss.par to 0.
  par <- r4ss::SS_readpar_3.30(parfile = file.path(dir_aspm, "ss3.par"),
                               datsource = file.path(dir_aspm, "data_echo.ss_new"),
                               ctlsource = file.path(dir_aspm, "control.ss_new"),
                               verbose = verbose)
  print(par$recdev_early)
  print(par$recdev_forecast)
  par$recdev_early[, "recdev"] <- 0
  # par$recdev_forecast[,"recdev"] <- 0
  r4ss::SS_writepar_3.30(parlist = par,
                         outfile = file.path(dir_aspm, "ss3.par"),
                         overwrite = TRUE, 
                         verbose = verbose)
  
  # update starter file
  # read from ss.par and to use the new data and control files
  start_aspm <- r4ss::SS_readstarter(file = file.path(dir_aspm, "starter.ss"), verbose = verbose)
  start_aspm$datfile <- "data_echo.ss_new"
  start_aspm$ctlfile <- "control.ss_new" 
  start_aspm$init_values_src <- 1
  r4ss::SS_writestarter(start_aspm, dir = dir_aspm, overwrite = TRUE)
  
  # update control file
  # initial F
  control <- r4ss::SS_readctl_3.30(file = file.path(dir_aspm, "control.ss_new"),
                                   datlist = file.path(dir_aspm, "data_echo.ss_new"), verbose = verbose)
  print(control$SR_parms)
  control$size_selex_parms[, "PHASE"] <- abs(control$size_selex_parms[, "PHASE"]) * -1
  control$recdev_early_phase <- -4
  control$recdev_phase <- -2
  
  # read in input files
  start <- r4ss::SS_readstarter(file = file.path(dir_out, "starter.ss"),  verbose = verbose)
  dat <- r4ss::SS_readdat(file = file.path(dir_out, start$datfile), verbose = verbose)
  ctl <- r4ss::SS_readctl(file = file.path(dir_out, start$ctlfil), verbose = verbose, use_datlist = TRUE, datlist = dat)
  fore <- r4ss::SS_readforecast(file = file.path(dir_out, "forecast.ss"), verbose = verbose)
  ctl$lambdas
  
  # update lambdas
  new_lambdas <- ctl$lambdas
  new_lambdas <- data.frame(like_comp = ctl$lambdas$like_comp,
                            fleet = ctl$lambdas$fleet,
                            phase = rep(1, n_fleet),
                            value = rep(0, n_fleet),
                            sizefreq_method = rep(1, n_fleet))
  print(new_lambdas)
  control$lambdas <- new_lambdas
  control$N_lambdas <- nrow(new_lambdas)
  r4ss::SS_writectl_3.30(control, outfile = file.path(dir_aspm, "control.ss_new"), overwrite = TRUE, verbose = verbose)
  
  # run aspm
  r4ss::run(dir = dir_aspm, exe = ss3exe, skipfinished = FALSE, verbose = verbose)
  
  # get model outputs
  aspm_mods <- r4ss::SSgetoutput(dirvec = c(dir_out, dir_aspm), verbose = verbose)

  # save outputs
  readr::write_rds(aspm_mods, file = file.path(dir_aspm, paste0("aspm_output.rds")))
  
  return(aspm_mods)
}
