# Check all Excel spreadsheets
# 
suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
  library(readxl)
  library(janitor)
})

# N.B.: This path is hard coded, since there is no expectation that 
# annual updates will reside within this package during the QA/QC process.
# In fact, I recommend against it.  Instead copy them into the 
# ../../00_Annual_Update/Updated_reserve_var_sheets directory when they have
# passed QA/QC.  That should be a cleaner process, IMO.
reserve_updates_path <- "E:/SWMP/2020_SWMP_Updated_reserve_var_sheets"

site_files <- (list.files(path = reserve_updates_path, pattern = "xlsx"))

test_year <- 2020
report_file <- paste0("check_results/reserve_var_checks_", test_year,".txt")

sheets <- c('Flags', 'Years_of_Interest', 'Seasons', 'Mapping',
            'Bonus_Settings', 'Basic_Plotting', 'Threshold_Plots',
            'Threshold_Identification')

min_rows <- c(5, 2, 13, 5, 11, 21, 21, 21)
min_cols <- c(1, 2,  7, 6,  2,  6, 14,  5)

# Begin testing
# 

msg <- paste0("Begin check at ", Sys.time())
write.table(msg, report_file, col.names = FALSE,
            row.names = FALSE, quote = FALSE, append = FALSE)

for(wb_name in site_files) {
  xl_path <- paste0(reserve_updates_path, "/", wb_name)
  print(wb_name)
  msg <- paste0("\nProcessing: ",wb_name)
  write.table(msg, report_file, col.names = FALSE,
              row.names = FALSE, quote = FALSE, append = TRUE)
  # Flags sheet should have at least 5 entries in 1 column
  for(i in 1:length(sheets)) {
    sheet <- sheets[i]
    wks <- read_xlsx(path = xl_path, sheet = sheet) 
    wks <- remove_empty(wks, which = "rows")
    if(nrow(wks) < min_rows[i]) {
      msg <- paste0("! -- Missing rows on sheet *", sheet,
                    "*, has ", nrow(wks), " needs ", min_rows[i])
      print(msg)
      write.table(msg, report_file, col.names = FALSE,
                  row.names = FALSE, quote = FALSE, append = TRUE)
    }
    if(ncol(wks) < min_cols[i]) {
      msg <- paste0("! -- Missing columns on sheet *", sheet,
                    "*, has ", ncol(wks), " needs ", min_cols[i])
      print(msg)
      write.table(msg, report_file, col.names = FALSE,
                  row.names = FALSE, quote = FALSE, append = TRUE)
    }
  } 
}
