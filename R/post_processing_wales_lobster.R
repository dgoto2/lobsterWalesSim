# post-processing simulation output files

# load a function to check convergence (from ss3sim)
mod_convergence <- function(dir) {
  outvec <- c("ran" = 0, "hess" = 0)
  if (file.exists(file.path(dir, "Report.sso"))) {
    outvec["ran"] <- 1
  } else {
    return(outvec)
  }
  cor_file_in <- dir(dir, pattern = ".+\\.cor$")
  stopifnot(length(cor_file_in) <= 1)
  if (length(cor_file_in) == 1) {
    if (file.exists(file.path(dir, "covar.sso"))) {
      outvec["hess"] <- 1
    }
  }
  return(outvec)
}


# set directories
dir.main <- getwd()

# locate folders with all OM simulation outputs
(om_scenario <- list.dirs(path = file.path(dir.main), recursive = FALSE))

# check model convergence of each replicate 
niter <- 100 # N of reps
run_success <- NULL
run_success_all <- NULL
run_success_all2 <- NULL
for (om_folder in 1:length(om_scenario)) { # loop through OM scenarios
  scenario_om <- om_folder - 1 # 0 (base) to 6
  (om_em_scenario_all <- list.dirs(path = file.path(om_scenario[om_folder]), recursive = FALSE))
  
  # run though all EM scenarios
  for (scen_em in 1:length(om_em_scenario_all)) { 
    print(om_em_scenario <- om_em_scenario_all[scen_em]) 
    (n_files <- length(list.dirs(path = om_em_scenario, recursive = FALSE)))

    # compute model convergence rates for all replicates
    for(i in c(1:niter)) {
      # rep output
      dir_out_run <- file.path(file.path(om_em_scenario, i), "em")
      print(mod_convergence(dir_out_run))
      run_success <- dplyr::bind_rows(run_success, mod_convergence(dir_out_run))
      run_success$om <- stringr::str_extract(om_scenario[om_folder], "[^////]+$")
      run_success$em <- stringr::str_extract(om_em_scenario, "[^////]+$")
    }
    run_success_rate <- run_success |> 
      dplyr::reframe(ran_prop = sum(ran)/dplyr::n(),
                     hess_prop = sum(hess)/dplyr::n()) |>
      dplyr::glimpse()
    run_success$run_success_rate1 <- run_success_rate[1]
    run_success$run_success_rate2 <- run_success_rate[2]
    print(run_success_all <- dplyr::bind_rows(run_success_all, run_success))
  
  }
  print(run_success_all2 <- dplyr::bind_rows(run_success_all2, run_success_all))
}
run_success_all2[,5]  <- run_success_all2$run_success_rate1$ran_prop
run_success_all2[,6]  <- run_success_all2$run_success_rate2$hess_prop
colnames(run_success_all2)[c(5,6)] <- c("ran_prop", "hess_prop")

# save outputs
readr::write_rds(run_success_all2, file = file.path(paste0(getwd(), "/modelconvergencetest_wales_lobster.rds")))

# get convergence rates for all scenarios
run_success_all2_summary <- readr::read_rds(run_success_all2, file = file.path(paste0(getwd(), "/modelconvergencetest_wales_lobster.rds"))) |> 
  dplyr::group_by(om, em) |> dplyr::reframe(ran_prop = unique(ran_prop),
                                            hess_prop = unique(hess_prop)) |>
  dplyr::glimpse()


# calculate output summary for each scenario
for (om_folder in 1:length(om_scenario)) { # loop through all OM scenarios
  print(om_folder)
  scenario_om <- om_folder - 1 # 0 (base) to 6
  setwd(file.path(om_scenario)[om_folder])
  getwd()
  (om_em_scenario_all <- list.dirs(path = file.path(om_scenario[om_folder]), recursive = FALSE))
  
  # extract outputs through EM scenarios (all outputs are saved by the function)
  ss3sim::get_results_all(
    directory = getwd(), 
    overwrite_files = TRUE,
    user_scenarios = c(stringr::str_extract(om_em_scenario_all, "[^////]+$")), # names of scenarios/folders
    type = c("long", "wide"),
    filename_prefix = "ss3sim") 
  
  # Read in the data frames stored in the csv files
  scalar_dat <- read.csv("ss3sim_scalar.csv")
  ts_dat <- read.csv("ss3sim_ts.csv")
  
  # Calculate the relative error (RE)
  (scalar_dat <- ss3sim::calculate_re(scalar_dat))
  (ts_dat <- ss3sim::calculate_re(ts_dat))
  
  # Save the output
  readr::write_csv(scalar_dat, file = "scalar_dat.csv")
  readr::write_csv(ts_dat, file = "ts_dat.csv")
}

