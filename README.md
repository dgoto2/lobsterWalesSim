### lobsterWalesSim
This repository contains code for a simulation testing framework for the stock assessment model (Stock Synthesis, SS3) of European lobster (*Homarus gammarus*) in Welsh waters. The framework consists of an operating model (OM) based on the [2024 stock assessment](https://github.com/Sustainable-Fisheries-Wales/lobsterWales2024/tree/main) and an estimation model (EM) developed using SS3 (>v3.30.22) to evaluate model misspecification (natural mortality, recruitment steepness, length-at-50% selectivity, and asymptotic length) in EM under two levels (low and high) of recruitment variability and fishing mortality scenarios in OM.  


#### Description

R: This folder contains R files for running simulation tests and diagnostic tests

`simtest_wales_lobster.R`: a script for running simulation testing

`condition_base_wales_lobster.R`: a function for conditioning OM based on the assessment model

`update_om_wales_lobster.R`: a function for updating OM (sigmaR and F)

`update_em_wales_lobster.R`: a function for updating EM (model mispecification)

`om_scenarios_wales_lobster.R`: a function for specifying OM scenarios

`em_scenarios_wales_lobster.R`: a function for specifying EM scenarios

`generate_om_em_id.R`: a function for generating a scenario ID for OM & EM combinations

`diagnostics_wales_lobster.R`: a script for running diagnostic tests (retrospective analysis, likelihood profiling, age-structured production modeling, and residual analysis) for each EM

`aspm.R`: a function for running age-structured production modeling for each EM

`likelihood.R`: a function for running likelihood profiling for each EM 

`retrospective.R`: a function for running retrospective analysis for each EM

## Prerequisites
Install the following packages:
```r
required <- c("ss3sim", "r4ss", "foreach", "doParallel", "stats", "dplyr", "pak")
installed <- rownames(installed.packages())
(not_installed <- required[!required %in% installed])
install.packages(not_installed[!not_installed %in% c("r4ss", "ss3sim")], dependencies = TRUE)
pak::pkg_install("r4ss/r4ss")
pak::pkg_install("ss3sim/ss3sim")

```

## Running simulations
To run simulations, see `R/simtest_wales_lobster.R`. The script contains the configuration for conditioning OM and running OM and EM scenarios. The script is currently set up to run 16 EM scenarios: combinations of 1 to 4 parameter misspecifications (+/-10% bias in natural mortality, steepness, selectivity, and asymptotic length) for 6 OM scenarios (`R/om_scenarios_wales_lobster.R`):
```r
# EM scenarios - modify param values for misspecification scenarios: Value that results in ~10% decrease/increase in terminal SSB (see R/em_scenarios_wales_lobster.R)
# set up EM scenarios; 0 (base) to 1 (+10 bias) or -1 (-10% bias)
scenario_em <- matrix(c(0,  0,  0,  0,
                        1,	0,	0,	0,
                        0,	1,	0,	0,
                        0,	0,	1,	0,
                        0,	0,	0,	1,
                        1,	1,	0,	0,
                        1,	0,	1,	0,
                        1,	0,	0,	1,
                        0,	1,	1,	0,
                        0,	1,	0,	1,
                        0,	0,	1,	1,
                        1,	1,	1,	0,
                        1,	0,	1,	1,
                        0,	1,	1,	1,
                        1,	1,	0,	1,
                        1,	1,	1,	1), nrow = 4, ncol = 16)
rownames(scenario_em) <- c("m", "st", "sl", "linf")
colnames(scenario_em) <- 1:16

# select OM scenario
scenario_om <- 0 # 0 (base) to 6
(F_multi <- om_scenario(scenario_om)[1])
(sigmaR_dev <- om_scenario(scenario_om)[2])

iteration <- 100
extra_cores <- 4

# run simulations though em scenarios
for (scen_em in 1:ncol(scenario_em)) {
  seed1 <- 1234*scen_em
  set.seed(seed1)
  cat("OM scenario:", scenario_om, "; EM scenario:", scen_em)
  
  scenario_m <- scenario_em[1, scen_em] * sample(c(-1,1), replace=TRUE, size=1) # natural mortality 
  scenario_st <- scenario_em[2, scen_em] * sample(c(-1,1), replace=TRUE, size=1) # steepness
  scenario_sl <- scenario_em[3, scen_em] * sample(c(-1,1), replace=TRUE, size=1) # selectivity (retention curve inflection)
  scenario_linf <- scenario_em[4, scen_em] * sample(c(-1,1), replace=TRUE, size=1) # growth (asymptotic length, Linf)
  scenario_ess <- 0 # effective sample size for size comp data 
  
  # 1.natural mortality 
  (m_mult1 <- em_scenario(scenario_m=scenario_m, scenario_st=scenario_st, scenario_sl=scenario_sl, 
                          scenario_linf=scenario_linf, scenario_ess=scenario_ess, scenario_om=scenario_om)[1])
  (m_mult2 <- em_scenario(scenario_m=scenario_m, scenario_st=scenario_st, scenario_sl=scenario_sl, 
                          scenario_linf=scenario_linf, scenario_ess=scenario_ess, scenario_om=scenario_om)[2])
  
  # 2.steepness -> estimated -> change & fix
  (steep_mult <- em_scenario(scenario_m=scenario_m, scenario_st=scenario_st, scenario_sl=scenario_sl, 
                             scenario_linf=scenario_linf, scenario_ess=scenario_ess, scenario_om=scenario_om)[3])
  (steep_phase <- em_scenario(scenario_m=scenario_m, scenario_st=scenario_st, scenario_sl=scenario_sl, 
                              scenario_linf=scenario_linf, scenario_ess=scenario_ess, scenario_om=scenario_om)[4])
  
  # 3.selectivity params -> estimated -> change & fix
  (sel_mult1 <- em_scenario(scenario_m=scenario_m, scenario_st=scenario_st, scenario_sl=scenario_sl, 
                            scenario_linf=scenario_linf, scenario_ess=scenario_ess, scenario_om=scenario_om)[5])
  (sel_mult2 <- em_scenario(scenario_m=scenario_m, scenario_st=scenario_st, scenario_sl=scenario_sl, 
                            scenario_linf=scenario_linf, scenario_ess=scenario_ess, scenario_om=scenario_om)[6])
  (sel_mult3 <- em_scenario(scenario_m=scenario_m, scenario_st=scenario_st, scenario_sl=scenario_sl, 
                            scenario_linf=scenario_linf, scenario_ess=scenario_ess, scenario_om=scenario_om)[7])
  (sel_phase <- em_scenario(scenario_m=scenario_m, scenario_st=scenario_st, scenario_sl=scenario_sl, 
                            scenario_linf=scenario_linf, scenario_ess=scenario_ess, scenario_om=scenario_om)[8])
  
  # 4.asymptotic length (growth param Linf)
  (linf_mult1 <- em_scenario(scenario_m=scenario_m, scenario_st=scenario_st, scenario_sl=scenario_sl, 
                             scenario_linf=scenario_linf, scenario_ess=scenario_ess, scenario_om=scenario_om)[9])
  (linf_mult2 <- em_scenario(scenario_m=scenario_m, scenario_st=scenario_st, scenario_sl=scenario_sl, 
                             scenario_linf=scenario_linf, scenario_ess=scenario_ess, scenario_om=scenario_om)[10])
  
  # effective sample size for lencomp
  (ess <- em_scenario(scenario_m=scenario_m, scenario_st=scenario_st, scenario_sl=scenario_sl, 
                      scenario_linf=scenario_linf, scenario_ess=scenario_ess, scenario_om=scenario_om)[11])

  # create a new om folder
  scenarioID <- scenario_id(scenario_m=scenario_m, scenario_st=scenario_st, scenario_sl=scenario_sl, 
                            scenario_linf=scenario_linf, scenario_ess=scenario_ess, scenario_om=scenario_om)
  stock <- "wales"
  species <- "lobster"
  print(scenario_name <- paste0("0D", scenarioID[1], "-E", scenarioID[2], "-F", scenarioID[3], "-R", scenarioID[4], "-X", scenarioID[5],   
                                "-M", scenarioID[6], "-St", scenarioID[7], "-Sl", scenarioID[8], "-G", scenarioID[9],  
                                "-", stock, "-", species))
  scenario <- scenario_name 

    
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # run simulations in parallel
  # Setup parallel cores and iterations to run
  # clean up clusters
  unregister_dopar <- function() {
      env <- foreach:::.foreachGlobals
    rm(list = ls(name = env), pos = env)
  }
  unregister_dopar()
  closeAllConnections()
  
  # set up clusters
  require(doParallel)
  Sys.getenv("NUMBER_OF_PROCESSORS")
  cl <- makeCluster(as.numeric(Sys.getenv("NUMBER_OF_PROCESSORS")) - extra_cores, outfile="", type = "SOCK")
  doSNOW::registerDoSNOW(cl)

  # Create a progress bar
  pb <- txtProgressBar(min = 0, max = 10, style = 3)
  # Progress function to update the bar
  progress <- function(n) {
    setTxtProgressBar(pb, n)
  }
  # Export the progress function to workers
  opts <- list(progress = progress)
 
  system.time(foreach::foreach(iter_i = 1:iteration, .options.snow = opts) %dopar% { 
    seed <- 1234*iter_i
    set.seed(seed)
    
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # OM
    # 1.create a new directory to put a modified model
    mod_path <- file.path(dir.main, scenario, iter_i)
    dir.create(file.path(mod_path), showWarnings = FALSE, recursive = TRUE)
    new_mod_path_om <- file.path(mod_path, "om")
    
    # 2.copy over the base model files from mod_path to new_mod_path
    r4ss::copy_SS_inputs(dir.old = dir.base, dir.new = new_mod_path_om, overwrite = TRUE)
    
    # 3.read in input files
    start_om <- r4ss::SS_readstarter(file = file.path(new_mod_path_om, "starter.ss"),  verbose = FALSE)
    dat_om <- r4ss::SS_readdat(file = file.path(new_mod_path_om, "ss3.dat"), verbose = FALSE)
    ctl_om <- r4ss::SS_readctl(file = file.path(new_mod_path_om, "ss3.ctl"), verbose = FALSE, use_datlist = TRUE, datlist = dat_om)
    fore_om <- r4ss::SS_readforecast(file = file.path(new_mod_path_om, "forecast.ss"), verbose = FALSE)
    
    # 4.update om files
    update_om(fore_om = fore_om, 
              start_om = start_om, 
              dat_om = dat_om, 
              ctl_om = ctl_om, 
              new_mod_path_om = new_mod_path_om,
              nyears = nyears, 
              iter_i = iter_i, 
              nboot = nboot,
              ess = ess, 
              sigmaR_dev = sigmaR_dev, 
              F_mult = F_mult, 
              scenario = scenario,
              inityr_recdev = 1983, 
              inityr_fore = 2025,
              overwrite = TRUE)

    # run om to generate bootstrapped dat file
    r4ss::run(dir = new_mod_path_om, 
              extras = extras_om, 
              exe = ss3exe, 
              skipfinished = FALSE, 
              show_in_console = FALSE) # switch to FALSE when not testing


    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # EM
    # 0.create a new directory to put a modified model
    new_mod_path_em <- file.path(mod_path, "em")
    dir.create(file.path(new_mod_path_em), showWarnings = FALSE, recursive = TRUE)
    
    # 1.copy over the model files from mod_path to new_mod_path
    files2copy <- list.files(new_mod_path_om, all.files = TRUE, full.names = TRUE)
    ss_modelfiles <- file.copy(from = files2copy, to = new_mod_path_em, overwrite = TRUE)

    # 2.read in input files
    start_em <- r4ss::SS_readstarter(file = file.path(new_mod_path_em, "starter.ss_new"),  verbose = FALSE)
    dat_em <- r4ss::SS_readdat(file = file.path(new_mod_path_om, "data_boot_001.ss"), verbose = FALSE) 
    ctl_em <- r4ss::SS_readctl(file = file.path(new_mod_path_em, "control.ss_new"), verbose = FALSE, use_datlist = TRUE, datlist = dat_em)
    fore_em <- r4ss::SS_readforecast(file = file.path(new_mod_path_em, "forecast.ss_new"), verbose = FALSE)
    
    # 3.update em files
    update_em(fore_em = fore_em, 
              start_em = start_em, 
              dat_em = dat_em, 
              ctl_em = ctl_em, 
              new_mod_path_em = new_mod_path_em,
              recdev_early = 1938,
              m_mult1 = m_mult1, 
              m_mult2 = m_mult2,
              steep_mult = steep_mult, 
              steep_phase = steep_phase,
              sel_mult1 = sel_mult1, 
              sel_phase1 = sel_phase1, 
              sel_mult2 = sel_mult2, 
              sel_phase2 = sel_phase2,
              sel_mult3 = sel_mult3, 
              sel_phase3 = sel_phase3,
              linf_mult = linf_mult, 
              linf_phase = linf_phase,
              overwrite = TRUE)
    
    # run em  
    r4ss::run(dir = new_mod_path_em, 
              extras = extras_em, 
              exe = ss3exe, 
              skipfinished = FALSE,
              show_in_console = FALSE) # switch to FALSE when not testing

  })
  
  # stop the cluster
  stopCluster(cl)
}


# plot SSB from the 1st iteration of OM and EM
iter <- 1
r_om1 <- r4ss::SS_output(file.path(file.path(dir.main, scenario, iter), "om"),
                         verbose = FALSE, 
                         printstats = FALSE, 
                         covar = TRUE)
r_em1 <- r4ss::SS_output(file.path(file.path(dir.main, scenario, iter), "em"),
                         verbose = FALSE, 
                         printstats = FALSE, 
                         covar = TRUE)
r4ss::SSplotComparisons(r4ss::SSsummarize(list(r_om1, r_em1)),
                        legendlabels = c(paste0("OM", iter), paste0("EM", iter)), 
                        subplots = 2)

```

##### Time series of spawning stock biomass from 1 iteration of OM and EM under the baseline scenario
<p align="center">
<img src="https://github.com/Sustainable-Fisheries-Wales/lobsterWalesSim/blob/main/plots/wales_lobster_base_em_om_comparison.png?raw=true" width="600"> 
</p>

```
