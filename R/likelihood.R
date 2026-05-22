#' performing a likelihood profile for EM
#' 
#' @iter an iteration number in simulation replicates
#' @stock stock name
#' @species species name
#' @dir_out a directory for the EM output files
#' @dir_retro a directory for retrospective analysis files
#' @ss3exe the location of a ss3 excutable
#' @conv_criteria a convergence criteria for ss3
#' @increment a increment size for the vector of a profiling parameter
#' 
#' 

run_profile <- function(iter = iter,
                      stock = stock,
                      species = species,
                      dir_out = dir_out,
                      likelihood_dir = likelihood_dir,
                      ss3exe = ss3exe,
                      conv_criteria = 0.1,
                      increment = 0.2,
                      verbose = FALSE) {


  # copy ss3 input files from EM
  files <- c("data_echo.ss_new", "control.ss_new", "starter.ss", "forecast.ss", "ss3.par")
  file.copy(from = file.path(dir_out, files), to = likelihood_dir) 
  
  # update starter file
  start_likelihood <- r4ss::SS_readstarter(file = file.path(likelihood_dir, "starter.ss"),  verbose = verbose)
  start_likelihood$datfile <- "data_echo.ss_new"
  start_likelihood$ctlfile <- "control.ss_new" 
  r4ss::SS_writestarter(start_likelihood, dir = likelihood_dir, overwrite=TRUE)
  dir_profile <- file.path(likelihood_dir, "profile")
  dir.create(dir_profile, showWarnings = FALSE, recursive = TRUE)
  list.files(likelihood_dir)

  # coopy ss input files
  files <- c("data_echo.ss_new", "control.ss_new", "starter.ss", "forecast.ss", "ss3.par")
  file.copy(from = file.path(likelihood_dir, files), to = dir_profile)
  CTL <- r4ss::SS_readctl_3.30(file = file.path(dir_profile, "control.ss_new"), datlist = file.path(dir_profile, "data_echo.ss_new"))
  print(CTL$SR_parms)
  
  # get the estimated r0 value
  r0 <- CTL$SR_parms$INIT[1]
  
  # creating a vector that is +/- 1 unit away from the estimated value
  r0_vec <- seq(r0-1, r0+1, by = increment)
  print(r0_vec) 
  
  # update start file
  START <- r4ss::SS_readstarter(file = file.path(dir_profile, "starter.ss"), verbose = verbose)
  START$prior_like <- 1
  START$ctlfile <- "control_modified.ss"
  r4ss::SS_writestarter(START, dir = dir_profile, overwrite = TRUE, verbose = verbose)
  
  # run a profile on R0
  r4ss::profile(dir = dir_profile,
                newctlfile = "control_modified.ss",
                string = "SR_LN",
                profilevec = r0_vec,
                conv_criteria = conv_criteria,
                exe = ss3exe,
                verbose = verbose)
  
  # visualize output
  profile_mods <- r4ss::SSgetoutput(dirvec = dir_profile, keyvec = 1:length(r0_vec), verbose = FALSE)
  
  # save output
  readr::write_rds(profile_mods, file = file.path(dir_profile, paste0("likelihood_output.rds")))
  
  return(profile_mods)
}




