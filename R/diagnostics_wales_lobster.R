# running diagnostic tests for stock synthesis EMs

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
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# load functions
source("retrospective.R")
source("likelihood.R")
source("aspm.R")

setwd("..")
dir.main <- getwd()
stock <- "wales"
species <- "lobster"
om_scenario <- "OM0_F0_R0_diagtest" # test only
om_em_scenario <- "D0-E0-F0-R0-X0-M0-St0-Sl0-G0-wales-lobster"
niter <- 5
ss3exe <- file.path(dir.main, "ss3_win.exe")
extra_cores <- 4

# compute model convergence rates 
run_success <- NULL
for(iter in c(1:niter)) {
  
  dir_out <- file.path(file.path(dir.main, om_scenario, om_em_scenario, iter), "em")
  print(mod_convergence(dir_out))
  run_success <- dplyr::bind_rows(run_success, mod_convergence(dir_out)) 
}
run_success_rate <- run_success |> dplyr::reframe(ran_prop = sum(ran)/dplyr::n(),
                                                  hess_prop = sum(hess)/dplyr::n()) |>
  dplyr::glimpse()



# run diagnostics 
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
#doParallel::registerDoParallel(cl)

# Create a progress bar
pb <- txtProgressBar(min = 0, max = 10, style = 3)

# Progress function to update the bar
progress <- function(n) {
  setTxtProgressBar(pb, n)
}
# Export the progress function to workers
opts <- list(progress = progress)


system.time(foreach::foreach(iter = 1:niter, .options.snow = opts) %dopar% { 

  #iter <- 1

  # set a directory for model output files
  dir_out <- file.path(file.path(dir.main, om_scenario, om_em_scenario, iter), "em")
  
  if (mod_convergence(dir_out)[2] == 1) { # only for converged models
  
    #~~~~~~~~~~~~~~~    
    # retrospectives
    # create a folder
    dir_retro <- file.path(file.path(dir.main, om_scenario, om_em_scenario, iter), "retrospectives")
    dir.create(dir_retro, showWarnings = FALSE)
    
    # run retrospective analysis
    retro_mods <- run_retro(iter = iter,
              stock = stock,
              species = species,
              dir_out = dir_out,
              dir_retro = dir_retro,
              ss3exe = ss3exe,
              verbose = FALSE) 
    
    # get summaries
    retroSummary <- r4ss::SSsummarize(retro_mods, verbose = FALSE)
    
    # plot retrospectives
    ss3diags::SSplotRetro(retroSummary, subplots = "SSB", add = TRUE)
    ss3diags::SSplotRetro(retroSummary, subplots = "F", add = TRUE) 
    
    # Hindcast Cross-Validation & prediction skill 
    hci <- ss3diags::SSplotHCxval(retroSummary, add = TRUE, verbose = FALSE, ylimAdj = 1.3, legendcex = 0.7)
    
    # Hindcasting cross-validation for mean lengths
    retroSummary_comps <- ss3diags::SSretroComps(retro_mods)
    hcl <- ss3diags::SSplotHCxval(retroSummary_comps, subplots = "len", add = TRUE, verbose = FALSE, ylimAdj = 1.3, legendcex = 0.7)
    mase1 <- ss3diags::SSmase(retroSummary_comps, quant = "len", MAE.base.adj = 0.1)
  
    # save summary outputs
    readr::write_rds(retroSummary_comps, file = paste0(dir_retro, "/retroSummary_comps.rds"))
    readr::write_rds(hcl, file = paste0(dir_retro, "/hcxval_output_index.csv"))
    readr::write_rds(mase1, file = paste0(dir_retro, "/hcxval_output_len.csv"))
    
    
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # age-structured production model (ASPM)
    # create a folder
    dir_aspm <- file.path(file.path(dir.main, om_scenario, om_em_scenario, iter), "aspm")
    dir.create(dir_aspm, showWarnings = FALSE, recursive = TRUE)
    
    aspm_mods <- run_aspm(iter = iter,
                          stock = stock,
                          species = species,
                          dir_out = dir_out,
                          dir_aspm = dir_aspm,
                          ss3exe = ss3exe,
                          n_fleet = 7,
                          verbose = FALSE)
    
    # get summaries
    aspm_mods_sum <- r4ss::SSsummarize(aspm_mods, verbose = FALSE)
    
    # plot
    r4ss::SSplotComparisons(aspm_mods_sum, legendlabels = c("Ref", "ASPM"), subplots = c(2, 8, 14), new = FALSE)
    
    
    #~~~~~~~~~~~~~~~~~~~
    # likelihood profile 
    # create a folder
    likelihood_dir <- file.path(file.path(dir.main, om_scenario, om_em_scenario, iter), "likelihood_dir")
    dir.create(likelihood_dir, showWarnings = FALSE)
    
    # run a likelihood profile
    profile_mods <- run_profile(iter = iter,
                                stock = stock,
                                species = species,
                                dir_out = dir_out,
                                likelihood_dir = likelihood_dir,
                                ss3exe = ss3exe,
                                conv_criteria = 0.1,
                                increment = 0.2,
                                verbose = FALSE)
    
    # get summaries
    profile_mods_sum <- r4ss::SSsummarize(profile_mods, verbose = FALSE)
    
    # plot
    r4ss::SSplotProfile(profile_mods_sum,
                        profile.string = "SR_LN",
                        profile.label = "SR_LN(R0)")
    r4ss::sspar(mfrow = c(1, 2))
    r4ss::PinerPlot(profile_mods_sum,
                    component = "Length_like",
                    main = "length composition")
    r4ss::PinerPlot(profile_mods_sum,
                    component = "Surv_like",
                    main = "abundance index")
    
    
    #~~~~~~~~~~~~~~~~~~
    # residual analyses
    # runs test
    # get summaries of model outputs
    report <- r4ss::SS_output(dir = dir_out, verbose = FALSE, printstats = FALSE)
    r4ss::sspar(mfrow = c(1, 2))
    ss3diags::SSplotRunstest(report, add = TRUE)
    
    r4ss::sspar(mfrow = c(2, 2))
    ss3diags::SSplotRunstest(report, subplots = "len", add = TRUE, ylim = c(-0.2, 0.2))
    ss3diags::SSplotRunstest(report, subplots = "len", add = TRUE, ylim = c(-0.2, 0.2), ylimAdj = 1)
    
    # summary table
    rcpue <- ss3diags::SSrunstest(report, quants = "cpue")
    rlen <- ss3diags::SSrunstest(report, quants = "len")
    rbind(rcpue, rlen)
    
    # compute rmse for lenthe comp and cpue
    r4ss::sspar(mfrow = c(2, 2))
    ss3diags::SSplotJABBAres(report, subplots = "cpue", add = TRUE)
    ss3diags::SSplotJABBAres(report, subplots = "len", add = TRUE, ylim = c(-0.2, 0.2))
    
  }
})

# stop the cluster
stopCluster(cl)
