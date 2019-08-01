# Load libraries ----------
library(SWMPrExtension)
library(dplyr)
library(tidyr)
library(lubridate)
library(mapview)
library(readxl)

## DEFINE SEASONS ----
wb <- readxl::read_xlsx(path = wb_name, sheet = sheets[3], n_max = 12)
wb_season_starts <- readxl::read_xlsx(path = wb_name, sheet = sheets[3]) %>% .[13, ]

#### Assign season groupings and season names
if(all(is.na(wb[ , 3]))) {
  wq_season_grp <- NULL
  wq_season_names <- NULL
} else {
  wq_season_grp <- split(wb[, 2], f = wb[, 3]) %>% lapply(., '[[', 'Month_No')
  wq_season_names <- unique(wb[, 3]) %>% .[[1]]
  wq_season_grp <- wq_season_grp[c(wq_season_names)]
}

if(all(is.na(wb[ , 4]))) {
  met_season_grp <- NULL
  met_season_names <- NULL
} else {
  met_season_grp <- split(wb[, 2], f = wb[, 4]) %>% lapply(., '[[', 'Month_No')
  met_season_names <- unique(wb[, 4]) %>% .[[1]]
  met_season_grp <- met_season_grp[c(met_season_names)]
}

if(all(is.na(wb[ , 5]))) {
  nut_season_grp <- NULL
  nut_season_names <- NULL
} else {
  nut_season_grp <- split(wb[, 2], f = wb[, 5]) %>% lapply(., '[[', 'Month_No')
  nut_season_names <- unique(wb[, 5]) %>% .[[1]]
  nut_season_grp <- nut_season_grp[c(nut_season_names)]
}

if(all(is.na(wb[ , 6]))) {
  barplot_season_grp <- NULL
  barplot_season_names <- NULL
} else {
  barplot_season_grp <- split(wb[, 2], f = wb[, 6]) %>% lapply(., '[[', 'Month_No')
  barplot_season_names <- unique(wb[, 6]) %>% .[[1]]
  barplot_season_grp <- barplot_season_grp[c(barplot_season_names)]
}

if(all(is.na(wb[ , 7]))) {
  sk_nut_season_grp <- NULL
  sk_nut_season_names <- NULL
} else {
  sk_nut_season_grp <- split(wb[, 2], f = wb[, 7]) %>% lapply(., '[[', 'Month_No')
  sk_nut_season_names <- names(sk_nut_season_grp)
}

#### Assign season starts
wq_season_start <- ifelse(is.na(wb_season_starts %>% .[[3]]), list(NULL), wb_season_starts %>% .[[3]])
met_season_start <- ifelse(is.na(wb_season_starts %>% .[[4]]), list(NULL), wb_season_starts %>% .[[4]])
nut_season_start <- ifelse(is.na(wb_season_starts %>% .[[5]]), list(NULL), wb_season_starts %>% .[[5]])
barplot_season_start <- ifelse(is.na(wb_season_starts %>% .[[6]]), list(NULL), wb_season_starts %>% .[[6]])
sk_nut_season_start <- ifelse(is.na(wb_season_starts %>% .[[7]]), list(NULL), wb_season_starts %>% .[[7]])

# Set data type specific variables ----
# Set season arguments and trend map labels based on data type
if(data_type == 'wq') {
  
  par_season_grp <- wq_season_grp
  par_season_names <- wq_season_names
  par_season_start <- wq_season_start
  par_trend_labs <- wq_trend_labs
  
} else if (data_type == 'met') {
  
  par_season_grp <- met_season_grp
  par_season_names <- met_season_names
  par_season_start <- met_season_start
  par_trend_labs <- met_trend_labs
  
} else {
  
  par_season_grp <- nut_season_grp
  par_season_names <- nut_season_names
  par_season_start <- nut_season_start
  par_trend_labs <- nut_trend_labs
}

wb_basic <- readxl::read_xlsx(path = wb_name, sheet = sheets[6])%>% filter(Parameter_Category == data_type)
wb_thresh_plot <- readxl::read_xlsx(path = wb_name, sheet = sheets[7]) %>% filter(Parameter_Category == data_type)
wb_thresh_id <- readxl::read_xlsx(path = wb_name, sheet = sheets[8]) %>% filter(Parameter_Category == data_type)

par <- wb_basic %>% .[[1]]
par_type <- wb_basic %>% .[[3]]
par_threshold <- wb_basic %>% .[[5]]
par_log_transform<- wb_basic %>% .[[4]] %>% as.logical

#### Which criteria should be used for threshold_plot?
par_criteria_type <- wb_thresh_plot %>% .[[3]]

#### Which values should be used for the upper and lower bounds of the plots?
par_criteria <- wb_thresh_plot[, c(4, 5)]

#### Which labels and colors should be used for threshold_criteria_plot?
par_criteria_labs <- wb_thresh_plot[, c(6:8)]
par_criteria_cols <- wb_thresh_plot[, c(9:11)]

#### threshold_criteria_plot: Should a monthly smooth be included?
par_month_smooth <- wb_thresh_plot %>% .[[12]] %>% as.logical

#### threshold_criteria_plot: Should a critical threshold be included?
par_crit_threshold <- wb_thresh_plot %>% .[[13]]

#### threshold_percentile_plot: Should percentiles be calculated on a monthly basis?
par_monthly <- wb_thresh_plot %>% .[[14]] %>% as.logical

#### Which criteria should be used for threshold identification?
par_threshold_val <- wb_thresh_id %>% .[[4]]
par_threshold_type <- wb_thresh_id %>% .[[3]]
par_threshold_time <- wb_thresh_id %>% .[[5]]
par_threshold_agg <- wb_thresh_id %>% .[[6]]

# Determine which criteria are instantaneous vs cumulative
par_inst <- par[par_type == 'instantaneous']
par_cumulative <- par[par_type == 'cumulative']
