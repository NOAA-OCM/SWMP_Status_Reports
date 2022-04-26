trend_tbl <- readxl::read_xlsx('template_files/text/Reserve_Level_Template_Text_Entry.xlsx', sheet = 5)

# prep sk_wq
wq_stns <- get_sites('data/', 'wq') #stations to include in table
wq_par <- trend_tbl %>% filter(Parameter_Category == 'wq') %>% .$Parameter
wq_file <- paste('output/wq/trend_sk/', res.abb, '_wq_seasonal_kendall_results_reformat.csv', sep = '')
if(file.exists(wq_file)) {
  wq_sk_res <- read.csv(file = wq_file, stringsAsFactors = F,
                        encoding = 'UTF-8')
  ls_wq_ft <- create_sk_flextable_list(wq_sk_res, stations = wq_stns, 
                                       param = wq_par)
} else {
  
}

# prep sk_nut
nut_stns <- get_sites('data/', 'nut')
nut_par <- trend_tbl %>% filter(Parameter_Category == 'nut') %>% .$Parameter
nut_nms <- c('Orthophosphate', 'Nitrate', 'Nitrite', 'Ammonium', 'Chlorophyll-a')
nut_file <- paste('output/nut/trend_sk/', res.abb, '_nut_seasonal_kendall_results_reformat.csv', sep = '')
if(file.exists(nut_file)){
  nut_sk_res <- read.csv(file = nut_file, stringsAsFactors = F, 
                         encoding = 'UTF-8')
  ls_nut_ft <- create_sk_flextable_list(nut_sk_res, stations = nut_stns, 
                                        param = nut_par)
} else {
  
}

# prep sk_met
met_stns <- get_sites('data/', 'met')
met_par <- trend_tbl %>% filter(Parameter_Category == 'met') %>% .$Parameter
met_nms <- c('Precipitation', 'Air \nTemperature')
met_file <- paste('output/met/trend_sk/', res.abb, '_met_seasonal_kendall_results_reformat.csv', sep = '')
if(file.exists(met_file)) {
  met_sk_res <- read.csv(file = met_file, stringsAsFactors = F,
                         encoding = 'UTF-8')
  ls_met_ft <- create_sk_flextable_list(met_sk_res, stations = met_stns, 
                                        param = met_par)
} else {
  
}
