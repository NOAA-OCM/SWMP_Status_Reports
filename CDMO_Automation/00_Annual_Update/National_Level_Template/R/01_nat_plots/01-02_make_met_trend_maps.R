##################################################################
# This script generates seasonal kendall trend maps             ##
# for later use with the national level template                ##
#                                                               ##
# It performs the following actions                             ##
# for all MET parameters:                                       ##
### national_sk_map()                                           ##
#                                                               ##
##################################################################



for(i in 1:length(par$Parameter)) {
  param <- par$Parameter[i]
  
  par_regex <- paste(param, '.csv$', sep = '')
  files <- list.files('handoff_files', pattern = par_regex) %>% paste0('handoff_files/', ., sep = '')
  
  abbrev <- substr(files, 15, 17)
  
  x <- lapply(files, read.csv, header = T, encoding = 'UTF-8') %>% bind_rows
  
  x$NERR.Site.ID <- abbrev
  
  x$LOC.1 <- gsub('i', 'dec', x$LOC.1)
  x$LOC.1 <- gsub('h', 'inc', x$LOC.1)
  x$LOC.1 <- gsub('\u2014', 'insig', x$LOC.1)
  x$LOC.1 <- gsub('x', 'insuff', x$LOC.1)
  
  hi <- data.frame(Reserve = 'He\'eia', LOC.1 = 'insuff', NERR.Site.ID = 'HEE')
  
  x <- rbind(x, hi)
  
  nerr_states <- c('01', '02', '06', '10', '12', '13', '15'
                   , '23', '24', '25', '28', '33', '34', '36', '37', '39'
                   , '41', '44', '45', '48', '51', '53', '55', '72')
  
  sk_map <- national_sk_map(highlight_states = nerr_states
                            , sk_reserves = x$NERR.Site.ID
                            , sk_results = x$LOC.1)
  
  file_nm <- paste('output/met/trend_sk_maps/system_sk_', param, '.png', sep = '')
  
  ggsave(filename = file_nm, plot = sk_map, width = 6, height = 4, units = 'in', dpi = 300, bg = 'transparent')
}
