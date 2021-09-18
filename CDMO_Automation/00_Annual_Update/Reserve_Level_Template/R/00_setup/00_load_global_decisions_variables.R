# Load libraries ----------
suppressPackageStartupMessages({
  library(SWMPrExtension)
  library(dplyr)
  library(tidyr)
  library(mapview)
  library(readxl)
})

# Internal functions for workflow -----------

check_make_dir <- function(fname) {
  if(!dir.exists(dirname(fname))) {
    dir.create(dirname(fname), recursive = TRUE)
    return(TRUE)
  }
}

check_site_validity <- function(possible_sites, time_range) {
  good_sites <- NULL
  for (this_site in possible_sites) {
    site_files <- as.data.frame(list.files(path = "data/", pattern = this_site))
    if(nrow(site_files) >= 1) {
      colnames(site_files) <- "file"
      site_files <- site_files %>% 
        mutate(len = nchar(file),
               year = substring(file, len-7, len-4),
               valid = (year >= time_range[1] & 
                          year <= time_range[2]))
      if(any(site_files$valid)) {
        good_sites <- c(good_sites, this_site)
      }  
    }
  }
  if(length(good_sites) > 0) {
    return(good_sites)
  } else {
    return("")
  }
}

# Set common variables -----
#### Reserve related 
data.loc <- 'data/'
res <- get_reserve(data.file = data.loc)
res_abb <- get_site_code(data.file = data.loc)

#### Variable spreadsheet related
wb_name <- 'figure_files/Reserve_Level_Plotting_Variables.xlsx'
sheets <- c('Flags', 'Years_of_Interest', 'Seasons', 'Mapping', 'Bonus_Settings'
            , 'Basic_Plotting', 'Threshold_Plots', 'Threshold_Identification')

## DEFINE YEARS OF INTEREST ---- DLE, 10/17/2020: Only read if not already defined. Otherwise, doesn't work in batch mode.
if(!exists('year_range')) {year_range <- read_xlsx(path = wb_name, sheet = sheets[2])[[1]]}
if(!exists('target_year')) {target_year <- read_xlsx(path = wb_name, sheet = sheets[2])[[2]][1]}

# DEFINE FLAGS TO KEEP ----
keep_flags <- read_xlsx(path = wb_name, sheet = sheets[1])[[1]]

## DETERMINE CALCULATED & CONVERTED PARAMETERS ----
wb <- read_xlsx(path = wb_name, sheet = sheets[5])

#### Convert temperature values from C to F?
convert_temp <- wb[[2]][1] %>% as.logical

#### Convert precipitation from mm to in?
convert_precip <- wb[[2]][2] %>% as.logical

#### Convert precipitation from mm to in?
convert_depth <- wb[[2]][3] %>% as.logical

#### Calculate dissolved inorganic phosphorus?
#### Calcuated as dip = po4f
calc_dip <- wb[[2]][6] %>% as.logical

#### Calculate dissolved inorganic nitrogen?
#### Calculated as din <- no2f + no3f + nh4f
calc_din <- wb[[2]][7] %>% as.logical
calc_no23 <- wb[[2]][8] %>% as.logical

#### Include station labels on maps?
res_map_station_labels <- wb[[2]][9] %>% as.logical
sk_map_station_labels <- wb[[2]][10] %>% as.logical

#### Convert wind speed from m/s to mph?
convert_wind <- wb[[2]][11] %>% as.logical

## DEFINE PLOTTING VARIABLES -----
include_station_ttl <- wb[[2]][4] %>% as.logical
include_hist_avg <- wb[[2]][5] %>% as.logical

# Set mapping variables ----
wb <- read_xlsx(path = wb_name, sheet = sheets[4])

#### Reserve bounding box
res_bbox <- wb[[1]] %>% .[complete.cases(.)]
sk_bbox <- wb[[2]] %>% .[complete.cases(.)]

#### shapefile parameters
# res_gis_loc <- paste('inst/gis/GIS_Process/', toupper(res_abb), '/Boundaries/Reserve_Boundaries', sep = '')
res_gis_loc <- paste('inst/gis/', toupper(res_abb), sep = '')
res_gis_shp <- get_shp_name(res_gis_loc)

# Load spatial data
res_spatial <- load_shp_file(path = paste(res_gis_loc, res_gis_shp, sep ='/'), dissolve = T)

sites_to_map <- get_sites('data/') %>% .[grep('wq|nut', .)]
sites_to_map <- geographic_unique_stations(sites_to_map)
sites_to_map <- c(sites_to_map, get_sites('data/') %>% .[grep('met', .)])
sites_to_map <- sites_to_map[!duplicated(sites_to_map)]

scale_pos <- 'bottomleft'
map_labels <- wb[[3]] %>% .[complete.cases(.)]

wq_trend_labs <- wb[[4]] %>% .[complete.cases(.)]
met_trend_labs <- wb[[5]] %>% .[complete.cases(.)]
nut_trend_labs <- wb[[6]] %>% .[complete.cases(.)]
