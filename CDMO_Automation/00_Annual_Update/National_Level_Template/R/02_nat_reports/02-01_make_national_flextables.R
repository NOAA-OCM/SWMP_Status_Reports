# National level template variables ----

# Load year range and target year from variable spreadsheet
wb_name <- 'template_files/text/National_Level_Template_Text_Entry.xlsx'
sheets <- c('Page_2_NERRS_in_Trend_Table', 'Page_2_Params_in_Trend_Table')

# Load reserve names and abbreviations
par <- read_xlsx(path = wb_name, sheet = sheets[2])
reserve <- read_xlsx(path = wb_name, sheet = sheets[1])

ls_trend_tbl <- vector('list', length(par$Parameter) + 1)

# Generate flex tables for the desired parameters
for(i in 1:length(par$Parameter)) {
  parm <- par$Parameter[i]
  
  par_regex <- paste(parm, '.csv$', sep = '')
  files <- list.files('handoff_files', pattern = par_regex) %>% paste0('handoff_files/', ., sep = '')
  
  abbrev <- substr(files, 15, 17)
  
  x <- lapply(files, read.csv, header = T, stringsAsFactors = F, encoding = 'UTF-8') %>% bind_rows
  
  x$NERR.Site.ID <- abbrev
  
  # Removing the 5th location for easier formatting, make this optional
  tbl <- left_join(reserve, x) %>% select(-NERR.Site.ID, -Region, -Reserve, -LOC.5)
  
  # Replace NA values with X values
  tbl[is.na(tbl)] <- 'x'

  ls_trend_tbl[[i + 1]] <- create_sk_national_ft_results(tbl, param = parm)
}

# Generate flex table for reserve names
ls_trend_tbl[[1]] <- create_sk_national_ft_reserves(tbl)