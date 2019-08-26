##################################################################
# This script performs a seasonal kendall (SK) test             ##
# for monotonic trends for instantaneous and cumulative         ## 
# parameters. It also generates SK trend maps                   ##
# for each parameter and converts results into a                ##
# flextable-friendly format for use in the reserve level        ##
# template                                                      ##
#                                                               ##
# It performs the following actions                             ##
# for instantaneous and cumulative parameters:                  ##
### sk_seasonal()                                               ##
### SK results reformat                                         ##
### res_sk_map()                                                ##
##################################################################

# TREND ANALYSIS ------
combined_sk_results <- data.frame()

if(length(par_inst) > 0) {
  for(i in 1:length(par_inst)) {
    
    sk_result <- lapply(ls_par, sk_seasonal, param = par[i])
    sk_result <- do.call('rbind', sk_result)
    
    combined_sk_results <- rbind(combined_sk_results, sk_result)
  }
}

if(length(par_cumulative) > 0) {
  for(i in 1:length(par_cumulative)) {
    
    # the method here is a bit different because lapply cannot seem to handle a function with a variable FUN argument
    sk_result <- lapply(ls_par, function(x) {
      sk_seasonal(x, param = par_cumulative[i], stat_lab = 'Sum', FUN = function(x) sum(x, na.rm = T))
    })
    
    sk_result <- do.call('rbind', sk_result)
    
    combined_sk_results <- rbind(combined_sk_results, sk_result)
  }
}

combined_sk_results[, c(1:3, 8, 9)] <- sapply(combined_sk_results[, c(1:3, 8, 9)], as.character)

write.csv(combined_sk_results
          , file = paste('output/', data_type, '/trend_sk/', res_abb, '_', data_type, '_seasonal_kendall_results.csv', sep = '')
          , row.names = F)

# REFORMAT SK RESULTS FOR FLEXTABLE ---------------
## select necessary columns
sk_reformat <- combined_sk_results %>% select(station, parameter, sig.trend) 

## replace values with wing ding 3 compliant values
sk_reformat$sig.trend[sk_reformat$sig.trend == 'inc'] <- 'h'
sk_reformat$sig.trend[sk_reformat$sig.trend == 'dec'] <- 'i'
sk_reformat$sig.trend[sk_reformat$sig.trend == 'insig'] <- '\U2014'
sk_reformat$sig.trend[sk_reformat$sig.trend == 'insuff'] <- 'x'

## reshape
sk_reformat <- sk_reformat %>% 
  select(station, parameter, sig.trend) %>% 
  spread(., key = parameter, value = sig.trend)

write.csv(sk_reformat
          , file = paste('output/', data_type, '/trend_sk/', res_abb, '_', data_type, '_seasonal_kendall_results_reformat.csv', sep = '')
          , row.names = FALSE
          , fileEncoding = 'UTF-8')

# GENERATE TREND MAPS ----------
## generate maps for each parameter
for(i in 1:length(par)) {
  sk_res <- combined_sk_results %>% dplyr::filter(parameter == par[i])
  
  sk_map_ttl <- paste(getwd(), '/output/', data_type, '/trend_sk_maps/', res_abb, '_', par[i], '.png', sep = '')
  
  sk_map <- res_sk_map(nerr_site_id = res_abb, stations = sk_res$station
                       , sk_result = sk_res$sig.trend, bbox = sk_bbox
                       , station_labs = sk_map_station_labels
                       , scale_pos = scale_pos, lab_loc = par_trend_labs, shp = res_spatial)
  
  mapview::mapshot(sk_map, file = sk_map_ttl, remove_url = TRUE, selfcontained = FALSE
                       , vwidth = 250, vheight = 250) 
}