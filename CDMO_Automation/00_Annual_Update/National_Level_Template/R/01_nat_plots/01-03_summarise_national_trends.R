##################################################################
# This script generates all of the data plots for later use     ##
# with the reserve level template                               ##
#                                                               ##
# It performs the following actions                             ##
# for all parameters with handoff files:                        ##
### summarise_handoff_files()                                   ##
###                                                             ##
### It then aggregates the results for all available            ##
### parameters and outputs a summary table at the top           ##
### level of the output folder                                  ##
##################################################################

# determine the unique parameters in the handoff_files folder
unique_params <- list.files(path = 'handoff_files') %>% 
  substr(., 5, (nchar(.) - 4)) %>% 
  unique(.)

# summarise the handoff files for each parameter
handoff_summary <- lapply(unique_params, 
                          function(x) summarise_handoff_files(path = 'handoff_files', param = x, res_region = reserve_region))

# ensure that each region is represented
handoff_summary <- lapply(handoff_summary, function(x) left_join(unique_regions, x))

# ensure that each region is represented
handoff_summary <- lapply(handoff_summary, function(x) left_join(unique_regions, x))

# combine separate lists into a final data.frame
handoff_summary <- do.call(rbind, handoff_summary)

# fill in missing parameter values
#handoff_summary$parameter <- na.locf(handoff_summary$parameter, na.rm = FALSE)
handoff_summary$parameter <- array(t(replicate(nrow(unique_regions), unique_params)))

# write csv to file
write.csv(handoff_summary, file = 'output/NERRS_Trend_Summary_From_Handoff_Files.csv', row.names = F)
