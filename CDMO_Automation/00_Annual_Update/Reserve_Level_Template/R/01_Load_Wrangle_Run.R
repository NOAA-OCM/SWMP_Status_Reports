this_dir <- getwd()
log_prefix <- substring(this_dir, nchar(this_dir) - 2)
logout <- file(paste0(log_prefix,"_output.log"), open = "wt")
logmess <- file(paste0(log_prefix,"_message.log"), open = "wt")
sink(logout, append = FALSE, type = "output", split = FALSE)
sink(logmess, append = FALSE, type = "message", split = FALSE)

# Source files ------------
source('R/00_setup/00_load_global_decisions_variables.R')

# Get reserve stations by type -------
wq_sites <- get_sites(data.file = data.loc, type = 'wq')
met_sites <- get_sites(data.file = data.loc, type = 'met')
nut_sites <- get_sites(data.file = data.loc, type = 'nut')

# Build start and end dates for filtering ----
start <- paste(year_range[1], '-01-01 0:00', sep = '')
end <- paste(year_range[2], '-12-31 23:45', sep = '')

# ----------------------------------------------
# Make basic maps         ----------------------
# ----------------------------------------------
source('R/01_plots/01-01_make_maps.R')

# ----------------------------------------------
# Load water quality data ----------------------
# ----------------------------------------------

## load, clean, and filter data
message("Begin wq -------------------------------------------")
data_type <- 'wq'
source('R/00_setup/00_Load_Analyses_Variables.R')

ls_par <- lapply(wq_sites, SWMPr::import_local, path = 'data')
ls_par <- lapply(ls_par, qaqc, qaqc_keep = keep_flags)
ls_par <- lapply(ls_par, subset, subset = c(start, end), select = par)

## convert select parameters
if(convert_temp) ls_par <- lapply(ls_par, function(x) {x$temp <- x$temp * 9 / 5 + 32; x})
if(convert_depth) ls_par <- lapply(ls_par, function(x) {x$depth <- x$depth * 3.28; x})

# Do water quality analyses ---------
source('R/01_plots/01-02_all_plot_analyses.R')
source('R/01_plots/01-03_all_trend_analyses.R')

# Unload the water quality data -----
rm(ls_par)
message("End wq -------------------------------------------")

# ----------------------------------------------
# Load meteorological data ---------------------
# ----------------------------------------------
message("Begin met -------------------------------------------")
data_type <- 'met'
source('R/00_setup/00_Load_Analyses_Variables.R')

ls_par <- lapply(met_sites, SWMPr::import_local, path = 'data')
ls_par <- lapply(ls_par, qaqc, qaqc_keep = keep_flags)
ls_par <- lapply(ls_par, subset, subset = c(start, end), select = par)

if(convert_temp) ls_par <- lapply(ls_par, function(x) {x$atemp <- x$atemp * 9 / 5 + 32; x})
if(convert_precip) ls_par <- lapply(ls_par, function(x) {x$totprcp <- x$totprcp / 25.4; x})
if(convert_wind) {
  ls_par <- lapply(ls_par, function(x) {x$wspd <- x$wspd * 2.23694; x})
  ls_par <- lapply(ls_par, function(x) {x$maxwspd <- x$maxwspd * 2.23694; x})
} 


# Do meteorological analyses ---------
message("All plots")
source('R/01_plots/01-02_all_plot_analyses.R')

source('R/01_plots/01-03_all_trend_analyses.R')

# Unload the meteorological data -----
rm(ls_par)
message("End met -------------------------------------------")

# ----------------------------------------------
# Load nutrient data ---------------------------
# ----------------------------------------------

message("Begin nut -------------------------------------------")
data_type <- 'nut'
source('R/00_setup/00_Load_Analyses_Variables.R')

ls_par <- lapply(nut_sites, import_local_nut, path = 'data', collMethd = 1)
ls_par <- lapply(ls_par, qaqc, qaqc_keep = keep_flags)
ls_par <- lapply(ls_par, subset, subset = c(start, end))
ls_par <- lapply(ls_par, rem_reps)

if('dip' %in% par) ls_par <- lapply(ls_par, function(x) {x$dip <- x$po4f; x})

if('din' %in% par) {
  if(calc_no23) {
    ls_par <- lapply(ls_par, function(x) {x$din <- x$no23f + x$nh4f; x})
  } else {
    ls_par <- lapply(ls_par, function(x) {x$din <- x$no2f + x$no2f + x$nh4f; x})
  }
} 

for(i in 1:length(ls_par)) {
  attr(ls_par[[i]], 'parameters') <- c(attr(ls_par[[i]], 'parameters'), 'din', 'dip')
}

# Do nutrient analyses ---------
source('R/01_plots/01-02_all_plot_analyses.R')
source('R/01_plots/01-03_all_trend_analyses.R')

# Unload the nutrient data -----
rm(ls_par)
message("End nut -------------------------------------------")

# ----------------------------------------------
# Reformat/prepare handoff files ---------------
# ----------------------------------------------

source('R/01_plots/01-04_prepare_handoff_files.R')

message("End load_wrangle_run, closing log files ===================")
# End output and message redirection
sink(NULL, type = "output")
sink(NULL, type = "message")
for(i in seq_len(sink.number())){  # Just in case there are more
  sink(NULL)
}
close(logout)
close(logmess)
