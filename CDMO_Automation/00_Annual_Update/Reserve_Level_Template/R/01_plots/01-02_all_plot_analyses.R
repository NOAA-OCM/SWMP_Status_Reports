##################################################################
# This script generates all of the data plots for later use     ##
# with the reserve level template                               ##
#                                                               ##
# It performs the following actions                             ##
# for instantaneous parameters:                                 ##
### raw_boxplot()                                               ##
### seasonal_boxplot()                                          ##
### seasonal_boxplot() with target year                         ##
### annual_range()                                              ##
### historical_daily_range() (for WQ and MET parameters)        ##
### historical_range()                                          ##
### seasonal_dot()                                              ##
#                                                               ##
#                                                               ##
# It performs the following actions                             ##
# for cumulative parameters:                                    ##
### seasonal_barplot() (stacked seasons)                        ##
### seasonal_barplot() (dodged seasons)                         ##
### seasonal_barplot() (facet_wrap by seasons)                  ##
##################################################################

message("Begin all_plot_analysis")

# Perform analyses for instantaneous parameters --------
for(i in 1:length(ls_par)) {
  
  # select a station data frame
  dat <- ls_par[[i]]
  
  for(j in 1:length(par_inst)) {
    # determine a station
    sta <- attributes(dat)$station
    
    # check for non-NA values
    if(all(is.na(dat[par_inst[j]]))) {
      warning(paste('All values for', par_inst[j], 'at station', sta, 'are NA'))
      next
    }
    
    # Determine plot conversion
    converted_par <- ifelse(convert_temp && (par_inst[j] == 'atemp' || par_inst[j] == 'temp'), TRUE,
                            ifelse(convert_wind && (par_inst[j] == 'wspd' || par_inst[j] == 'maxwspd'), TRUE,
                            ifelse(convert_depth && par_inst[j] == 'depth', TRUE, FALSE)))
    
    if(is.na(par_threshold[j])) par_threshold[j] <- list(NULL)
    
    # RAW BOXPLOT ----
    message("Creating boxplot_raw")
    # Make plot name
    raw_box_ttl <- paste('output/', data_type, '/boxplot_raw/raw_boxplot_', sta, '_', par_inst[j], '_yr.png', sep = '')
    raw_box <- raw_boxplot(dat
                           , param = par_inst[j]
                           , target_yr = target_year
                           , criteria = par_threshold[[j]]
                           , log_trans = par_log_transform[j]
                           , free_y = par_free_y[j]
                           , converted = converted_par
                           , plot_title = include_station_ttl
                           , season_grps = par_season_grp
                           , season_names = par_season_names
                           , season_start = par_season_start[[1]])
    
    new_dir_result <- check_make_dir(raw_box_ttl)
    ggsave(filename = raw_box_ttl, plot = raw_box, height = 4, width = 6, units = 'in', dpi = 300)
    
    # SEASONAL BOXPLOT ----
    message("Creating boxplot_seasonal")
    # Make plot name
    seasonal_box_ttl <- paste('output/', data_type, '/boxplot_seasonal/seasonal_boxplot_', sta, '_', par_inst[j], '_yr.png', sep = '')

    seasonal_box <- seasonal_boxplot(dat
                                     , param = par_inst[j]
                                     , hist_rng = year_range
                                     , target_yr = NULL
                                     , criteria = par_threshold[[j]]
                                     , log_trans = par_log_transform[j]
                                     , free_y = par_free_y[j]
                                     , converted = converted_par
                                     , criteria_lab = "WQ Threshold"
                                     , stat_lab = "Average"
                                     , plot_title = include_station_ttl
                                     , plot = TRUE
                                     , FUN = function(x) mean(x, na.rm = T)
                                     , season_grps = par_season_grp
                                     , season_names = par_season_names
                                     , season_start = par_season_start[[1]])
    
    new_dir_result <- check_make_dir(seasonal_box_ttl)
    ggsave(filename = seasonal_box_ttl, plot = seasonal_box, height = 4, width = 6, units = 'in', dpi = 300)
    
    # SEASONAL BOXPLOT WITH TARGET YEAR----
    message("Creating boxplot_seasonal_w_target_yr")
    # Make plot name
    seasonal_yr_box_ttl <- paste('output/', data_type, '/boxplot_seasonal_w_target_yr/seasonal_boxplot_', sta, '_', par_inst[j], '_yr.png', sep = '')

    seasonal_yr_box <- seasonal_boxplot(dat
                                        , param = par_inst[j]
                                        , hist_rng = year_range
                                        , target_yr = target_year
                                        , criteria = par_threshold[[j]]
                                        , log_trans = par_log_transform[j]
                                        , free_y = par_free_y[j]
                                        , converted = converted_par
                                        , plot_title = include_station_ttl
                                        , season_grps = par_season_grp
                                        , season_names = par_season_names
                                        , season_start = par_season_start[[1]])
    
    new_dir_result <- check_make_dir(seasonal_yr_box_ttl)
    ggsave(filename = seasonal_yr_box_ttl, plot = seasonal_yr_box, height = 4, width = 6, units = 'in', dpi = 300)
    
    # ANNUAL RANGE ----
    message("Creating range_annual")
    annual_rng_ttl <- paste('output/', data_type, '/range_annual/annual_range_', sta, '_', par_inst[j], '_yr.png', sep = '')

    annual_range <- annual_range(dat
                                 , param = par[j]
                                 , target_yr = target_year
                                 , criteria = par_threshold[[j]]
                                 , log_trans = par_log_transform[j]
                                 , free_y = par_free_y[j]
                                 , converted = converted_par
                                 , criteria_lab = 'WQ Threshold'
                                 , plot_title = include_station_ttl
                                 , plot = TRUE
                                 , season_grps = par_season_grp
                                 , season_names = par_season_names
                                 , season_start = par_season_start[[1]])
    
    new_dir_result <- check_make_dir(annual_rng_ttl)
    ggsave(filename = annual_rng_ttl, plot = annual_range, height = 4, width = 6, units = 'in', dpi = 300)
    
    # HISTORICAL DAILY RANGE ----
    message("Creating range_historical_daily")
    if(data_type != 'nut') {
      hist_daily_rng_ttl <- paste('output/', data_type, '/range_historical_daily/historical_daily_', sta, '_', par_inst[j], '_yr.png', sep = '')

      hist_daily_rng <- historical_daily_range(dat
                                               , param = par_inst[j]
                                               , hist_rng = year_range
                                               , target_yr = target_year
                                               , criteria = par_threshold[[j]]
                                               , log_trans = par_log_transform[j]
                                               , free_y = par_free_y[j]
                                               , converted = converted_par
                                               , criteria_lab = 'WQ Threshold'
                                               , plot_title = include_station_ttl
                                               , plot = TRUE
                                               , season_grps = par_season_grp
                                               , season_names = par_season_names
                                               , season_start = par_season_start[[1]])
      
      new_dir_result <- check_make_dir(hist_daily_rng_ttl)
      ggsave(filename = hist_daily_rng_ttl, plot = hist_daily_rng, height = 4, width = 6, units = 'in', dpi = 300)
    }
    
    # HISTORICAL SEASONAL RANGE ----
    message("Creating range_historical_seasonal")
    hist_seas_rng_ttl <- paste('output/', data_type, '/range_historical_seasonal/historical_seasonal_', sta, '_', par_inst[j], '.png', sep = '')

    hist_seas_rng <- historical_range(dat
                                      , param = par_inst[j]
                                      , hist_rng = year_range
                                      , target_yr = target_year
                                      , criteria = par_threshold[[j]]
                                      , log_trans = par_log_transform[j]
                                      , free_y = par_free_y[j]
                                      , converted = converted_par
                                      , criteria_lab = 'WQ Threshold'
                                      , plot_title = include_station_ttl
                                      , plot = TRUE
                                      , season_grps = par_season_grp
                                      , season_names = par_season_names
                                      , season_start = par_season_start[[1]])
    
    new_dir_result <- check_make_dir(hist_seas_rng_ttl)
    ggsave(filename = hist_seas_rng_ttl, plot = hist_seas_rng, height = 4, width = 6, units = 'in', dpi = 300)
    
    
    if(par_criteria_type[j] == 'criteria') {
      
      # THRESHOLD PLOTS for TARGET YEAR ----
      message("Creating threshold_criteria for target year")
      threshold_yr_ttl <- paste('output/', data_type, '/threshold_criteria/threshold_criteria_plot_', sta, '_', par_inst[j], '_yr.png', sep = '')

      threshold_crit_plt_yr <- threshold_criteria_plot(dat
                                                       , param = par_inst[j]
                                                       , rng = target_year
                                                       , thresholds = as.numeric(par_criteria[j, ])
                                                       , threshold_labs = as.character(par_criteria_labs[j, ])
                                                       , threshold_cols = as.character(par_criteria_cols[j, ])
                                                       , crit_threshold = par_crit_threshold[j]
                                                       , log_trans = par_log_transform[j]
#                                                       , free_y = par_free_y[j]
                                                       , monthly_smooth = par_month_smooth[j]
                                                       , plot_title = include_station_ttl)
      
      new_dir_result <- check_make_dir(threshold_yr_ttl)
      ggsave(filename = threshold_yr_ttl, plot = threshold_crit_plt_yr, height = 4, width = 6, units = 'in', dpi = 300)
      
      
      # THRESHOLD PLOTS for TIME SERIES ----
      message("Creating threshold_criteria all years")
      threshold_ts_ttl <- paste('output/', data_type, '/threshold_criteria/threshold_criteria_plot_', sta, '_', par_inst[j], '_ts.png', sep = '')

      threshold_crit_plt_ts <- threshold_criteria_plot(dat
                                                       , param = par_inst[j]
                                                       , rng = year_range
                                                       , thresholds = as.numeric(par_criteria[j, ])
                                                       , threshold_labs = as.character(par_criteria_labs[j, ])
                                                       , threshold_cols = as.character(par_criteria_cols[j, ])
                                                       , crit_threshold = par_crit_threshold[j]
                                                       , log_trans = par_log_transform[j]
                                                       , monthly_smooth = par_month_smooth[j]
#                                                       , free_y = par_free_y[j]
                                                       , plot_title = include_station_ttl)
      
      new_dir_result <- check_make_dir(threshold_ts_ttl)
      ggsave(filename = threshold_ts_ttl, plot = threshold_crit_plt_ts, height = 4, width = 6, units = 'in', dpi = 300)
      
    }
    
    if(par_criteria_type[j] == 'percentile') {
      
      # THRESHOLD PLOTS for TARGET YEAR ---
      message("Creating threshold_percentile target year")
      threshold_perc_ttl <- paste('output/', data_type, '/threshold_percentile/threshold_percentile_', sta, '_', par_inst[j], '_yr.png', sep = '')

      threshold_perc_plt_yr <- threshold_percentile_plot(dat
                                                         , param = par_inst[j]
                                                         , hist_rng = year_range
                                                         , target_yr = target_year
                                                         , percentiles = as.numeric(par_criteria[j, ]) %>% .[complete.cases(.)]
                                                         , by_month = par_monthly[j]
                                                         , log_trans = par_log_transform[j]
                                                         , free_y = par_free_y[j]
                                                         , converted = converted_par
                                                         , plot_title = include_station_ttl)
      
      new_dir_result <- check_make_dir(threshold_perc_ttl)
      ggsave(filename = threshold_perc_ttl, plot = threshold_perc_plt_yr, height = 4, width = 6, units = 'in', dpi = 300)
      
      # THRESHOLD PLOTS for TIME SERIES ----
      message("Creating threshold_percentile all years")
      threshold_perc_ttl <- paste('output/', data_type, '/threshold_percentile/threshold_percentile_', sta, '_', par_inst[j], '_ts.png', sep = '')

      threshold_perc_plt_ts <- threshold_percentile_plot(dat
                                                         , param = par_inst[j]
                                                         , hist_rng = year_range
                                                         , percentiles = as.numeric(par_criteria[j, ]) %>% .[complete.cases(.)]
                                                         , by_month = par_monthly[j]
                                                         , log_trans = par_log_transform[j]
                                                         , converted = converted_par
                                                         , free_y = par_free_y[j]
                                                         , plot_title = include_station_ttl)
      
      new_dir_result <- check_make_dir(threshold_perc_ttl)
      ggsave(filename = threshold_perc_ttl, plot = threshold_perc_plt_ts, height = 4, width = 6, units = 'in', dpi = 300)
    }
    
    
    if(!is.na(par_threshold_val[j])) {
      
      # THRESHOLD IDENTIFICATION ----
      message("Creating threshold_identification year")
      threshold_id_ttl <- paste('output/', data_type, '/threshold_identification/threshold_id_', sta, '_', par_inst[j], '.csv', sep = '')

      # a temporary data frame is used for setstep
      if(data_type != 'nut') {
        df_temp <- dat
        df_temp <- setstep(df_temp)
      } else {
        df_temp <- dat
        par_threshold_time[j] <- list(NULL)
      }
      
      threshold_id_tbl <- threshold_identification(df_temp
                                                   , param = par_inst[j]
                                                   , parameter_threshold = par_threshold_val[j]
                                                   , threshold_type = par_threshold_type[j]
                                                   , time_threshold = par_threshold_time[[j]])
      
      new_dir_result <- check_make_dir(threshold_id_ttl)
      write.csv(threshold_id_tbl, file = threshold_id_ttl, row.names = FALSE)
      
      # THRESHOLD IDENTIFICATION SUMMARY by month and season----
      message("Creating threshold_identification month")
      if(nrow(threshold_id_tbl) > 0) {
        threshold_id_summ_ttl <- paste('output/', data_type, '/threshold_identification/threshold_id_summary_', sta, '_', par_inst[j], '_month.png', sep = '')
        
        threshold_id_summ <- threshold_summary(df_temp, param = par_inst[j]
                                               , parameter_threshold = par_threshold_val[j]
                                               , threshold_type = par_threshold_type[j]
                                               , time_threshold = par_threshold_time[[j]]
                                               , summary_type = 'month'
                                               , plot_title = TRUE)
        
        new_dir_result <- check_make_dir(threshold_id_summ_ttl)
        ggsave(filename = threshold_id_summ_ttl, plot = threshold_id_summ, height = 4, width = 6, units = 'in', dpi = 300)
        
        message("Creating threshold_identification season")
        threshold_id_summ_ttl <- paste('output/', data_type, '/threshold_identification/threshold_id_summary_', sta, '_', par_inst[j], '_season.png', sep = '')
        
        threshold_id_summ <- threshold_summary(df_temp, param = par_inst[j]
                                               , parameter_threshold = par_threshold_val[j]
                                               , threshold_type = par_threshold_type[j]
                                               , time_threshold = par_threshold_time[[j]]
                                               , summary_type = 'season'
                                               , plot_title = TRUE
                                               , season_grps = list(c(1,2,3), c(4,5,6), c(7,8,9), c(10, 11, 12))
                                               , season_names = c('Winter', 'Spring', 'Summer', 'Fall'))
        
        new_dir_result <- check_make_dir(threshold_id_summ_ttl)
        ggsave(filename = threshold_id_summ_ttl, plot = threshold_id_summ, height = 4, width = 6, units = 'in', dpi = 300)
      }
      
      rm(df_temp)
    }
    
    # SEASONAL DOT PLOT ----
    message("Creating trend_dot_plot")
    seas_dot_ttl <- paste('output/', data_type, '/trend_dot_plot/seasonal_dot_', sta, '_', par_inst[j], '.png', sep = '')
    
    # Check for than one year of data
    trnd_lab <- ifelse(dat[c('datetimestamp', par[j])] %>% .[complete.cases(.), ] %>% .[, 1] %>% year %>% unique() %>% length == 1, FALSE, TRUE)
    
    seas_dot <- seasonal_dot(dat
                             , param = par_inst[j]
                             , lm_trend = trnd_lab
                             , lm_lab = trnd_lab  
                             , free_y = par_free_y[j]
                             , converted = converted_par
                             , plot_title = include_station_ttl
                             , plot = TRUE
                             , season_grps = par_season_grp
                             , season_names = par_season_names)
    
    new_dir_result <- check_make_dir(seas_dot_ttl)
    ggsave(filename = seas_dot_ttl, plot = seas_dot, height = 8, width = 10, units = 'in', dpi = 300)
    
  }
}

# Perform analyses for cumulative parameters --------
if(length(par_cumulative) > 0) {
  message("Analyse cumulative parameters")
  for(i in 1:length(ls_par)) {
    
    # select a station data frame
    dat <- ls_par[[i]]
    
    # converted_par <- ifelse(convert_temp && (par[j] == 'atemp' | par[j] == 'totprcp'), TRUE, FALSE)
    converted_par <- ifelse(convert_temp && (par[j] == 'atemp' || par[j] == 'temp'), TRUE,
                            ifelse(convert_wind && (par[j] == 'wspd' || par[j] == 'maxwspd'), TRUE,
                                   ifelse(convert_depth && par[j] == 'depth', TRUE, FALSE)))
    
    # determine a station
    sta <- attributes(dat)$station
    
    for(j in 1:length(par_cumulative)) {
      
      # Determine plot conversion
      converted_par <- ifelse(convert_temp && par_cumulative[j] == 'totprcp', TRUE, FALSE)

      message("Create barplot_seasonal")      
      seas_bar_stack_ttl <- paste('output/', data_type, '/barplot_seasonal/seas_bar_stack_', sta, '_', par_cumulative[j], '_yr.png', sep = '')
      
      seas_bar_stack <- seasonal_barplot(dat
                                         , param = par_cumulative[j]
                                         , hist_rng = year_range
                                         , season_grps = barplot_season_grp
                                         , season_names = barplot_season_names
                                         , season_start = barplot_season_start[[1]]
                                         , hist_avg = include_hist_avg
                                         , bar_position = 'stack'
                                         , season_facet = FALSE
                                         , plot_title = include_station_ttl
#                                         , free_y = par_free_y[j]
                                         , converted = converted_par)
      
      new_dir_result <- check_make_dir(seas_bar_stack_ttl)
      ggsave(filename = seas_bar_stack_ttl, plot = seas_bar_stack, height = 4, width = 6, units = 'in', dpi = 300)
      
      message("Create barplot_seasonal dodge")      
      
      seas_bar_dodge_ttl <- paste('output/', data_type, '/barplot_seasonal/seas_bar_dodge_', sta, '_', par_cumulative[j], '_yr.png', sep = '')
      
      seas_bar_dodge <- seasonal_barplot(dat
                                         , param = par_cumulative[j]
                                         , hist_rng = year_range
                                         , season_grps = barplot_season_grp
                                         , season_names = barplot_season_names
                                         , season_start = barplot_season_start[[1]]
                                         , hist_avg = include_hist_avg
                                         , bar_position = 'dodge'
                                         , season_facet = FALSE
#                                         , free_y = par_free_y[j]
                                         , plot_title = include_station_ttl
                                         , converted = converted_par)
      
      new_dir_result <- check_make_dir(seas_bar_dodge_ttl)
      ggsave(filename = seas_bar_dodge_ttl, plot = seas_bar_dodge, height = 4, width = 6, units = 'in', dpi = 300)
      
      
      message("Create barplot_seasonal facet")      
      seas_bar_facet_ttl <- paste('output/', data_type, '/barplot_seasonal/raw_boxplot_', sta, '_', par_cumulative[j], '_yr.png', sep = '')
      
      seas_bar_facet <- seasonal_barplot(dat
                                         , param = par_cumulative[j]
                                         , hist_rng = year_range
                                         , season_grps = barplot_season_grp
                                         , season_names = barplot_season_names
                                         , season_start = barplot_season_start[[1]]
                                         , hist_avg = include_hist_avg
                                         , season_facet = TRUE
                                         , plot_title = include_station_ttl
#                                         , free_y = par_free_y[j]
                                         , converted = converted_par)
      
      new_dir_result <- check_make_dir(seas_bar_facet_ttl)
      ggsave(filename = seas_bar_facet_ttl, plot = seas_bar_facet, height = 2 * length(barplot_season_names), width = 6, units = 'in', dpi = 300)
    }
  }
}

message("all_plot_analysis complete")