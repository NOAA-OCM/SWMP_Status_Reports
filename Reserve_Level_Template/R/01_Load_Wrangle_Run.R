# Source files ------------
source('R/00_load_global_decisions_variables.R')

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
source('R/01-01_make_maps.R')

# ----------------------------------------------
# Load water quality data ----------------------
# ----------------------------------------------

## load, clean, and filter data
data_type <- 'wq'
source('R/00_Load_Analyses_Variables.R')

ls_par <- lapply(wq_sites, SWMPr::import_local, path = 'data')
ls_par <- lapply(ls_par, qaqc, qaqc_keep = keep_flags)
ls_par <- lapply(ls_par, subset, subset = c(start, end), select = par)

## convert select parameters
if(convert_temp) ls_par <- lapply(ls_par, function(x) {x$temp <- x$temp * 9 / 5 + 32; x})
if(convert_depth) ls_par <- lapply(ls_par, function(x) {x$depth <- x$depth * 3.28; x})

# Do water quality analyses ---------
source('R/01-02_all_plot_analyses.R')
source('R/01-03_all_trend_analyses.R')

# Unload the water quality data -----
rm(ls_par)

# ----------------------------------------------
# Load meterological data ----------------------
# ----------------------------------------------
data_type <- 'met'
source('R/00_Load_Analyses_Variables.R')

ls_par <- lapply(met_sites, SWMPr::import_local, path = 'data')
ls_par <- lapply(ls_par, qaqc, qaqc_keep = keep_flags)
ls_par <- lapply(ls_par, subset, subset = c(start, end), select = par)

if(convert_temp) ls_par <- lapply(ls_par, function(x) {x$atemp <- x$atemp * 9 / 5 + 32; x})
if(convert_precip) ls_par <- lapply(ls_par, function(x) {x$totprcp <- x$totprcp / 25.4; x})


# Do meterological analyses ---------
source('R/01-02_all_plot_analyses.R')
source('R/01-03_all_trend_analyses.R')

# Unload the meterological data -----
rm(ls_par)

# ----------------------------------------------
# Load nutrient data ---------------------------
# ----------------------------------------------
data_type <- 'nut'
source('R/00_Load_Analyses_Variables.R')

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
source('R/01-02_all_plot_analyses.R')
source('R/01-03_all_trend_analyses.R')

# Unload the nutrient data -----
rm(ls_par)

# ----------------------------------------------
# Reformat/prepare handoff files ---------------
# ----------------------------------------------
source('R/01-04_prepare_handoff_files.R')